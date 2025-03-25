# Evitar que R8 elimine clases necesarias
-keep class android.window.** { *; }

# Mantener todas las clases del plugin flutter_inappwebview
-keep class com.pichillilorenzo.flutter_inappwebview.** { *; }

# Evitar eliminación de clases utilizadas por Flutter
-keep class io.flutter.** { *; }

# No optimizar ciertas clases de AndroidX
-dontwarn androidx.**
-ignorewarnings
-keep class * {
  public private *;
 }