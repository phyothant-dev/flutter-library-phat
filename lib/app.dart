import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'config/theme.dart';
import 'pages/home_page.dart';
import 'pages/book_detail_page.dart';
import 'pages/pdf_reader_page.dart';
import 'pages/credits_list_page.dart';
import 'models/book.dart';

final _rootKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: _rootKey,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (_, _) => const HomePage(),
    ),
    GoRoute(
      path: '/book/:id',
      builder: (_, state) => BookDetailPage(
        book: state.extra as Book,
      ),
    ),
    GoRoute(
      path: '/credits',
      builder: (_, _) => const CreditsListPage(),
    ),
    GoRoute(
      path: '/reader/:id',
      builder: (_, state) {
        final book = state.extra as Book;
        return PdfReaderPage(
          book: book,
        );
      },
    ),
  ],
);

class PhatApp extends StatelessWidget {
  const PhatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'ဖတ်',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      routerConfig: router,
    );
  }
}
