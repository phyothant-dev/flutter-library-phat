import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'config/supabase.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  PaintingBinding.instance.imageCache.maximumSize = 100;
  PaintingBinding.instance.imageCache.maximumSizeBytes = 50 << 20;

  try {
    if (SupabaseConfig.isConfigured) {
      await SupabaseConfig.initialize();
    }
  } catch (e) {
    debugPrint('Supabase init skipped: $e');
  }

  runApp(const ProviderScope(child: PhatApp()));
}
