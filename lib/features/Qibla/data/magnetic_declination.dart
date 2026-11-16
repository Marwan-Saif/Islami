import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:islami/features/Timer/data/prayer_times_service.dart';

/// الانحراف المغناطيسي (بالدرجات، الشرق موجب) لمكان المستخدم.
///
/// البوصلة على أندرويد (flutter_compass) بترجع اتجاه الشمال المغناطيسي، واتجاه
/// القبلة من flutter_qiblah محسوب من الشمال الجغرافي، فلازم نضيف الانحراف على
/// قراية البوصلة (في مصر حوالي 4-5 درجات، وده كان "الانحراف البسيط").
/// على iOS المكتبة بترجع trueHeading أصلاً، فالانحراف صفر.
/// الحساب بموديل WMM اللي جوه أندرويد (GeomagneticField) في MainActivity.
abstract class MagneticDeclination {
  static const MethodChannel _channel = MethodChannel('athar/geomagnetic');

  static Future<double> forCurrentLocation() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return 0;
    // بنستخدم الموقع اللي الأبلكيشن جايبه أصلاً للمواقيت بدل طلب GPS جديد:
    // الانحراف بيتغير ببطء جداً مع المسافة، وطلبات الموقع الزيادة بتعمل نداءات
    // على الـ thread الرئيسي لخدمة الموقع في النظام
    final (latitude, longitude) = PrayerTimesService.currentCoordinates;
    try {
      final declination = await _channel.invokeMethod<double>('declination', {
        'latitude': latitude,
        'longitude': longitude,
      });
      return declination ?? 0;
    } catch (e) {
      log('could not compute magnetic declination: $e');
      return 0;
    }
  }
}
