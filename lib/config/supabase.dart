import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupabaseConfig {
  static String get _supabaseUrl {
    const env = String.fromEnvironment('SUPABASE_URL');
    if (env.isNotEmpty) return env;
    return dotenv.env['SUPABASE_URL'] ?? '';
  }

  static String get _supabaseAnonKey {
    const env = String.fromEnvironment('SUPABASE_ANON_KEY');
    if (env.isNotEmpty) return env;
    return dotenv.env['SUPABASE_ANON_KEY'] ?? '';
  }

  static bool get isConfigured =>
      _supabaseUrl.isNotEmpty && _supabaseAnonKey.isNotEmpty;

  static Future<void> initialize() async {
    if (!isConfigured) return;
    await Supabase.initialize(
      url: _supabaseUrl,
      publishableKey: _supabaseAnonKey,
    );
  }

  static SupabaseClient get client {
    if (!isConfigured) {
      throw StateError(
        'Supabase not configured. Create .env with SUPABASE_URL and SUPABASE_ANON_KEY, '
        'or pass --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...',
      );
    }
    return Supabase.instance.client;
  }
}
