package com.example.islami

import android.hardware.GeomagneticField
import com.ryanheise.audioservice.AudioServiceActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

// AudioServiceActivity بدل FlutterActivity عشان تحكم الصوت من شريط الإشعارات
class MainActivity : AudioServiceActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // الانحراف المغناطيسي للمكان (موديل WMM اللي جوه أندرويد).
        // البوصلة على أندرويد بتقيس الشمال المغناطيسي، واتجاه القبلة محسوب من
        // الشمال الجغرافي، فالفرق ده بيتضاف على القراية (في مصر حوالي 4-5 درجات)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "athar/geomagnetic")
            .setMethodCallHandler { call, result ->
                if (call.method == "declination") {
                    val latitude = call.argument<Double>("latitude")
                    val longitude = call.argument<Double>("longitude")
                    if (latitude == null || longitude == null) {
                        result.error("ARGS", "latitude and longitude are required", null)
                        return@setMethodCallHandler
                    }
                    val altitude = call.argument<Double>("altitude") ?: 0.0
                    val field = GeomagneticField(
                        latitude.toFloat(),
                        longitude.toFloat(),
                        altitude.toFloat(),
                        System.currentTimeMillis(),
                    )
                    result.success(field.declination.toDouble())
                } else {
                    result.notImplemented()
                }
            }
    }
}
