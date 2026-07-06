import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/credit.dart';
import '../services/credit_service.dart';

final creditsProvider = FutureProvider<List<Credit>>((ref) async {
  final service = CreditService();
  return service.getCredits().timeout(const Duration(seconds: 10));
});
