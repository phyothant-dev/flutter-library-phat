import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app.dart';
import 'config/supabase.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: '.env');
  } catch (_) {
    // .env file is optional — use --dart-define instead
  }

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
