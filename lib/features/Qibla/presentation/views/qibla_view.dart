import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islami/core/utils/app_colors.dart';
import 'dart:math' as math;
import 'package:islami/generated/l10n.dart';

// import 'package:flutter_qibla/flutter_qibla.dart'; // باكدج القبلة

class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

enum _QiblaStatus {
  checking,
  ready,
  noSensor,
  serviceDisabled,
  denied,
  deniedForever,
}

class _QiblaScreenState extends State<QiblaScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  // final Color AppColors.primaryColor = const AppColors.primaryColor;

  // الأنيميشن الخاص بالنبض (Glow)
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  // من غير إذن الموقع الـ stream بيرجع error والبوصلة كانت بتتعرض على زاوية 0
  _QiblaStatus _status = _QiblaStatus.checking;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // بنشيك بس من غير ما نطلب الإذن، لأن الشاشة دي بتتبني مع فتح الأبلكيشن (IndexedStack)
    _checkStatus();

    // تشغيل الأنيميشن وتكراره
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pulseController.dispose();
    super.dispose();
  }

  // لما المستخدم يرجع من الإعدادات (فتح الـ GPS أو اداها الإذن)
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _status != _QiblaStatus.ready) {
      _checkStatus();
    }
  }

  Future<void> _checkStatus() async {
    _QiblaStatus status;
    try {
      final hasSensor =
          await FlutterQiblah.androidDeviceSensorSupport() ?? true;
      final location = await FlutterQiblah.checkLocationStatus();
      if (!hasSensor) {
        status = _QiblaStatus.noSensor;
      } else if (!location.enabled) {
        status = _QiblaStatus.serviceDisabled;
      } else if (location.status == LocationPermission.deniedForever) {
        status = _QiblaStatus.deniedForever;
      } else if (location.status == LocationPermission.always ||
          location.status == LocationPermission.whileInUse) {
        status = _QiblaStatus.ready;
      } else {
        status = _QiblaStatus.denied;
      }
    } catch (e) {
      status = _QiblaStatus.denied;
    }
    if (!mounted) return;
    // الـ stream بتاع المكتبة singleton، فلو كان خلص بـ error لازم يتعمل من جديد
    if (status == _QiblaStatus.ready && _status != _QiblaStatus.ready) {
      FlutterQiblah().dispose();
    }
    setState(() => _status = status);
  }

  Future<void> _onStatusAction() async {
    switch (_status) {
      case _QiblaStatus.denied:
        await FlutterQiblah.requestPermissions();
        await _checkStatus();
      case _QiblaStatus.deniedForever:
        await Geolocator.openAppSettings();
      case _QiblaStatus.serviceDisabled:
        await Geolocator.openLocationSettings();
      default:
        await _checkStatus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          // نفس نسب التصميم الأصلي (300 / 240 / 220) بس محسوبة من المساحة المتاحة
          final double compassSize = math.min(
            constraints.maxWidth * 0.8,
            constraints.maxHeight * 0.45,
          );
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(child: _buildContent(compassSize)),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent(double compassSize) {
    return Column(
      children: [
        SizedBox(height: 20.h),

        // العنوان
        Text(
          S.of(context).qiblaDirection,
          style: GoogleFonts.amiri(
            color: AppColors.text,
            fontSize: 28.sp,
            fontWeight: FontWeight.bold,
          ),
        ),

        const Spacer(),

        // بناء البوصلة واستقبال البيانات من الحساس
        if (_status == _QiblaStatus.checking)
          Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          )
        else if (_status != _QiblaStatus.ready)
          _buildStatusMessage(compassSize)
        // التاب مش ظاهر (IndexedStack بيقفل الـ TickerMode): بنفصل الحساس
        // عشان قراءاته متفضلش تعيد بناء البوصلة في الخلفية
        else if (!TickerMode.valuesOf(context).enabled)
          SizedBox(height: compassSize)
        else
          StreamBuilder<QiblahDirection>(
            stream: FlutterQiblah.qiblahStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return _buildStatusMessage(
                  compassSize,
                  message: S.of(context).locationFailed,
                );
              }
              // لو لسه بيحمل أو مفيش بيانات
              if (snapshot.connectionState == ConnectionState.waiting ||
                  snapshot.data == null) {
                return Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                );
              }

              // زاوية القبلة (بنجيبها من الباكدج وبنحولها لـ Radians)
              final double qiblaAngle = snapshot.data!.qiblah * (math.pi / 180);

              return Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // 1. التوهج الذهبي (الآن يظهر بوضوح)
                    AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) {
                        return Container(
                          width: compassSize * 0.73,
                          height: compassSize * 0.73,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            // وضعنا لون داكن متطابق مع الخلفية حتى ينعكس الظل
                            color: AppColors.surface,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryColor.withValues(
                                  alpha: 0.8 * _pulseAnimation.value,
                                ),
                                blurRadius:
                                    60 *
                                    _pulseAnimation.value, // تكبير الانتشار
                                spreadRadius: 15 * _pulseAnimation.value,
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    // 2. الإطار الخارجي للبوصلة (ثابت)
                    Container(
                      width: compassSize,
                      height: compassSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primaryColor.withValues(alpha: 0.4),
                          width: 2,
                        ),
                      ),
                      child: Stack(
                        children: [
                          _buildDirectionMarker(Alignment.topCenter, 'N'),
                          _buildDirectionMarker(Alignment.bottomCenter, 'S'),
                          _buildDirectionMarker(Alignment.centerRight, 'E'),
                          _buildDirectionMarker(Alignment.centerLeft, 'W'),
                        ],
                      ),
                    ),

                    // 3. النجمة/الإبرة الدوارة (تتحرك مع حركة الموبايل)
                    Transform.rotate(
                      angle: qiblaAngle, // الزاوية الحقيقية للقبلة من الحساس
                      child: CustomPaint(
                        size: Size.square(compassSize * 0.8),
                        painter: QiblaNeedlePainter(
                          gold: AppColors.goldGradient.colors,
                          kaaba: AppColors.isDark
                              ? const Color(0xFF05080B)
                              : const Color(0xFF1A2530),
                          tail: AppColors.textFaint,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

        SizedBox(height: 60.h),

        Container(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: AppColors.primaryColor.withValues(alpha: 0.4),
            ),
          ),
          child: Text(
            S.of(context).rotateDeviceForQibla,
            style: TextStyle(
              color: AppColors.text,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        const Spacer(),
        SizedBox(height: MediaQuery.paddingOf(context).bottom + 16.h),
      ],
    );
  }

  Widget _buildStatusMessage(double compassSize, {String? message}) {
    final s = S.of(context);
    final (String text, String? action) = switch (_status) {
      _QiblaStatus.noSensor => (s.noCompassSensor, null),
      _QiblaStatus.serviceDisabled => (s.turnOnGpsForQibla, s.openSettings),
      _QiblaStatus.deniedForever => (s.locationDeniedForever, s.openSettings),
      _ => (s.locationNeededForQibla, s.allowLocation),
    };
    return SizedBox(
      height: compassSize,
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.location_off_rounded,
                color: AppColors.primaryColor,
                size: 56.r,
              ),
              SizedBox(height: 16.h),
              Text(
                message ?? text,
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.text, fontSize: 16.sp),
              ),
              if (message != null || action != null) ...[
                SizedBox(height: 16.h),
                OutlinedButton(
                  onPressed: message != null ? _checkStatus : _onStatusAction,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primaryColor,
                    side: BorderSide(color: AppColors.primaryColor),
                  ),
                  child: Text(message != null ? s.retry : action!),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDirectionMarker(Alignment alignment, String label) {
    return Align(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(
          label,
          style: TextStyle(
            color: AppColors.primaryColor.withValues(alpha: 0.6),
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

/// إبرة القبلة: سهم دهبي ناحية الكعبة (مكعب أسود بحزام دهبي) وذيل باهت.
/// مرسومة بالكود بدل صورة الإبرة
class QiblaNeedlePainter extends CustomPainter {
  QiblaNeedlePainter({
    required this.gold,
    required this.kaaba,
    required this.tail,
  });

  final List<Color> gold;
  final Color kaaba;
  final Color tail;

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.shortestSide / 2;
    final w = r * 0.11;

    final goldPaint = Paint()
      ..shader = LinearGradient(
        colors: gold,
      ).createShader(Rect.fromCenter(center: c, width: w * 2, height: r * 2));

    // نص السهم اللي ناحية القبلة
    final head = Path()
      ..moveTo(c.dx, c.dy - r * 0.62)
      ..lineTo(c.dx + w, c.dy)
      ..lineTo(c.dx - w, c.dy)
      ..close();
    canvas.drawPath(head, goldPaint);

    // الذيل
    final back = Path()
      ..moveTo(c.dx, c.dy + r * 0.55)
      ..lineTo(c.dx + w, c.dy)
      ..lineTo(c.dx - w, c.dy)
      ..close();
    canvas.drawPath(back, Paint()..color = tail.withValues(alpha: 0.5));

    // الكعبة فوق السهم
    final side = r * 0.24;
    final cube = Rect.fromCenter(
      center: Offset(c.dx, c.dy - r * 0.8),
      width: side,
      height: side,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(cube, Radius.circular(side * 0.08)),
      Paint()..color = kaaba,
    );
    canvas.drawRect(
      Rect.fromLTWH(cube.left, cube.top + side * 0.22, side, side * 0.14),
      goldPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(cube, Radius.circular(side * 0.08)),
      Paint()
        ..shader = goldPaint.shader
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    // المحور
    canvas.drawCircle(c, w * 0.9, goldPaint);
    canvas.drawCircle(c, w * 0.4, Paint()..color = kaaba);
  }

  @override
  bool shouldRepaint(QiblaNeedlePainter old) =>
      old.kaaba != kaaba || old.tail != tail;
}
