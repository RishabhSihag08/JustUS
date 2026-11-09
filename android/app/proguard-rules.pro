# Flutter Secure Storage / Tink
-keep class com.google.crypto.tink.** { *; }
-dontwarn com.google.crypto.tink.**

# WorkManager
-keep class androidx.work.** { *; }
-dontwarn androidx.work.**
-keep class dev.fluttercommunity.workmanager.** { *; }

# Flutter Local Notifications
-keep class com.dexterous.flutterlocalnotifications.** { *; }
-dontwarn com.dexterous.flutterlocalnotifications.**

# Drift / SQLite
-keep class org.sqlite.** { *; }
-dontwarn org.sqlite.**

# Supabase / PostgREST
-keep class io.supabase.** { *; }

# Firebase
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# Play Core (Flutter deferred components)
-dontwarn com.google.android.play.core.**

# Flutter and plugins
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
