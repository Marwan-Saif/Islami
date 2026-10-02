# flutter_local_notifications saves scheduled notifications with Gson.
# Without these rules R8 strips the generic signatures and every
# zonedSchedule call fails in release builds with "Missing type parameter".
# Rules from https://github.com/google/gson/blob/main/examples/android-proguard-example/proguard.cfg

# Gson uses generic type information stored in a class file when working with fields.
-keepattributes Signature

# For using GSON @Expose annotation
-keepattributes *Annotation*

# Gson specific classes
-dontwarn sun.misc.**

# Prevent R8 from leaving Data object members always null
-keepclassmembers,allowobfuscation class * {
  @com.google.gson.annotations.SerializedName <fields>;
}

# Retain generic signatures of TypeToken and its subclasses with R8 version 3.0 and higher.
-keep,allowobfuscation,allowshrinking class com.google.gson.reflect.TypeToken
-keep,allowobfuscation,allowshrinking class * extends com.google.gson.reflect.TypeToken

# Notification models that the plugin serializes
-keep class com.dexterous.** { *; }
