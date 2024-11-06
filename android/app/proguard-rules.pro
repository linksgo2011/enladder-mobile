# Flutter 必要的保留规则
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }

# 保留 WebView 的类
-keep class android.webkit.WebView { *; }
-keepclassmembers class * extends android.webkit.WebView {
   public *;
}
# Keep Joda-Time related classes
-keep class org.joda.time.** { *; }
-keep class org.joda.convert.** { *; }

# Please add these rules to your existing keep rules in order to suppress warnings.
# This is generated automatically by the Android Gradle plugin.
-dontwarn com.google.android.play.core.splitcompat.SplitCompatApplication
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManager
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManagerFactory
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest$Builder
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest
-dontwarn com.google.android.play.core.splitinstall.SplitInstallStateUpdatedListener
-dontwarn com.google.android.play.core.tasks.OnFailureListener
-dontwarn com.google.android.play.core.tasks.OnSuccessListener
-dontwarn com.google.android.play.core.tasks.Task
-dontwarn org.joda.convert.FromString
-dontwarn org.joda.convert.ToString