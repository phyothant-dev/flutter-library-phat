import '../config/supabase.dart';
import '../models/credit.dart';

class CreditService {
  static final CreditService _instance = CreditService._();
  factory CreditService() => _instance;
  CreditService._();

  Future<List<Credit>> getCredits() async {
    final response = await SupabaseConfig.client
        .from('credits')
        .select('*')
        .order('created_at', ascending: true);
    return (response as List)
        .map((json) => Credit.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
