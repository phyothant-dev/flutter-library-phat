# Flutter
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.plugin.editing.** { *; }

# Flutter Embedding
-keep class io.flutter.embedding.** { *; }

# Dio (network)
-keep class com.dio.** { *; }
-keepattributes Signature

# Supabase / PostgREST
-keep class com.supabase.** { *; }

# CachedNetworkImage
-keep class com.bumptech.glide.** { *; }
-keep class com.bumptech.glide.integration.** { *; }

# Sqflite
-keep class com.tencent.wcdb.** { *; }

# Keep model classes (used via reflection by Supabase JSON serialization)
-keep class com.phat.phat.** { *; }

# Missing classes from Play Core (needed by Flutter)
-dontwarn com.google.android.play.core.splitcompat.SplitCompatApplication
-dontwarn com.google.android.play.core.splitinstall.SplitInstallException
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManager
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManagerFactory
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest$Builder
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest
-dontwarn com.google.android.play.core.splitinstall.SplitInstallSessionState
-dontwarn com.google.android.play.core.splitinstall.SplitInstallStateUpdatedListener
-dontwarn com.google.android.play.core.tasks.OnFailureListener
-dontwarn com.google.android.play.core.tasks.OnSuccessListener
-dontwarn com.google.android.play.core.tasks.Task
