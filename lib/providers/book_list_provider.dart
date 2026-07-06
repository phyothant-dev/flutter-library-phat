import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/book.dart';
import '../services/book_service.dart';
import '../services/local_db_service.dart';

enum LoadStatus { initial, loading, loaded, error, loadingMore }

class BookListState {
  final List<Book> books;
  final LoadStatus status;
  final String? error;
  final String query;
  final String genre;
  final bool hasMore;
  final int page;

  const BookListState({
    this.books = const [],
    this.status = LoadStatus.initial,
    this.error,
    this.query = '',
    this.genre = 'All',
    this.hasMore = true,
    this.page = 0,
  });

  BookListState copyWith({
    List<Book>? books,
    LoadStatus? status,
    String? error,
    String? query,
    String? genre,
    bool? hasMore,
    int? page,
  }) {
    return BookListState(
      books: books ?? this.books,
      status: status ?? this.status,
      error: error ?? this.error,
      query: query ?? this.query,
      genre: genre ?? this.genre,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
    );
  }

  List<Book> get filtered {
    return books.where((book) {
      final matchesSearch = query.isEmpty ||
          book.title.toLowerCase().contains(query.toLowerCase()) ||
          book.author.toLowerCase().contains(query.toLowerCase());
      final matchesGenre = genre == 'All' || book.category == genre;
      return matchesSearch && matchesGenre;
    }).toList();
  }
}

class BookListNotifier extends StateNotifier<BookListState> {
  BookListNotifier() : super(const BookListState()) {
    _load();
  }

  final _bookService = BookService();
  final _localDb = LocalDbService();
  Timer? _debounce;
  bool _loading = false;

  void search(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (query != state.query) {
        state = state.copyWith(query: query);
      }
    });
  }

  void setGenre(String genre) {
    state = state.copyWith(genre: genre);
  }

  static const int _pageSize = 20;

  Future<void> _load() async {
    if (_loading) return;
    _loading = true;
    state = state.copyWith(status: LoadStatus.loading);

    final cached = await _localDb.getCachedBooks();
    if (cached.isNotEmpty) {
      state = state.copyWith(
        books: cached,
        status: LoadStatus.loaded,
        hasMore: cached.length >= _pageSize,
        page: 1,
      );
    }

    try {
      final books = await _bookService
          .getBooks(from: 0, to: _pageSize - 1)
          .timeout(const Duration(seconds: 10));
      await _localDb.cacheBooks(books);
      state = state.copyWith(
        books: books,
        status: LoadStatus.loaded,
        hasMore: books.length >= _pageSize,
        page: 1,
        error: null,
      );
    } catch (e) {
      if (cached.isEmpty) {
        state = state.copyWith(
          status: LoadStatus.error,
          error: e.toString(),
        );
      }
    } finally {
      _loading = false;
    }
  }

  Future<void> loadMore() async {
    if (state.status == LoadStatus.loadingMore || !state.hasMore) return;

    final nextPage = state.page;
    if (nextPage == 0) return;

    state = state.copyWith(status: LoadStatus.loadingMore);

    try {
      final from = nextPage * _pageSize;
      final to = from + _pageSize - 1;
      final nextBooks = await _bookService
          .getBooks(from: from, to: to)
          .timeout(const Duration(seconds: 10));
      state = state.copyWith(
        books: [...state.books, ...nextBooks],
        status: LoadStatus.loaded,
        hasMore: nextBooks.length >= _pageSize,
        page: nextPage + 1,
      );
    } catch (_) {
      state = state.copyWith(status: LoadStatus.loaded);
    }
  }

  Future<void> refresh() => _load();
}

final bookListProvider =
    StateNotifierProvider<BookListNotifier, BookListState>((_) {
  return BookListNotifier();
});
