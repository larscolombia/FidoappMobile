# Evitar que R8 elimine clases necesarias
-keep class android.window.** { *; }
-dontwarn android.window.**

# Manejar específicamente la clase BackEvent
-keepclassmembers class android.window.BackEvent { *; }
-if class android.window.BackEvent
-keep class android.window.BackEvent

# Mantener todas las clases del plugin flutter_inappwebview
-keep class com.pichillilorenzo.flutter_inappwebview.** { *; }

# Evitar eliminación de clases utilizadas por Flutter
-keep class io.flutter.** { *; }
-keep class io.flutter.view.FlutterView { *; }
-keepclassmembers class io.flutter.view.FlutterView {
    void startBackGesture(android.window.BackEvent);
}

# No optimizar ciertas clases de AndroidX
-dontwarn androidx.**
-ignorewarnings
-keep class * {
  public private *;
 }
