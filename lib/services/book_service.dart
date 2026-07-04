import '../config/supabase.dart';
import '../models/book.dart';

class BookService {
  static final BookService _instance = BookService._();
  factory BookService() => _instance;
  BookService._();

  Future<List<Book>> getBooks({int? from, int? to}) async {
    var query = SupabaseConfig.client
        .from('books')
        .select('*')
        .order('created_at', ascending: false);
    if (from != null && to != null) {
      query = query.range(from, to);
    }
    final response = await query;
    return (response as List).map((json) => Book.fromJson(json)).toList();
  }

  Future<Book> getBook(String id) async {
    final response = await SupabaseConfig.client
        .from('books')
        .select('*')
        .eq('id', id)
        .single();
    return Book.fromJson(response);
  }
}
