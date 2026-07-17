# Flutter-specific ProGuard rules.
# Flutter packages do not use reflection so the default optimised rules work.
# Add any project-specific rules below.

# Keep Flutter engine entry points
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
