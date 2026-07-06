import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/book.dart';
import '../providers/book_list_provider.dart';
import '../widgets/book_card.dart';
import '../widgets/shimmer_book_card.dart';

final _genres = [
  'All',
  'Programming',
  'System Design',
  'Architecture',
  'Linux',
  'AI/ML',
  'Fiction',
  'Blockchain',
  'Algorithm',
];

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(bookListProvider.notifier).loadMore();
    }
  }

  Future<void> _onRefresh() {
    return ref.read(bookListProvider.notifier).refresh();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(bookListProvider);
    final filtered = state.filtered;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              floating: true,
              pinned: false,
              snap: false,
              backgroundColor: theme.colorScheme.surface,
              surfaceTintColor: theme.colorScheme.surfaceTint,
              scrolledUnderElevation: 0,
              flexibleSpace: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(left: 24, right: 8),
                  child: SizedBox(
                    height: 72,
                    child: Row(
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(28),
                              child: Image.asset(
                                'assets/logo.png',
                                width: 56,
                                height: 56,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.favorite_border_rounded,
                            color: theme.colorScheme.outline,
                          ),
                          onPressed: () => context.push('/credits'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (state.status == LoadStatus.error && state.books.isNotEmpty)
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.wifi_off_rounded, size: 18,
                          color: theme.colorScheme.onErrorContainer),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Showing cached books — no internet connection',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.onErrorContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    _buildSearchBar(theme),
                    const SizedBox(height: 16),
                    _buildGenreChips(theme, state.genre),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            _buildBody(theme, state, filtered),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(ThemeData theme, BookListState state, List<Book> filtered) {
    switch (state.status) {
      case LoadStatus.initial:
      case LoadStatus.loading:
        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 16,
              mainAxisSpacing: 24,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) => const ShimmerBookCard(),
              childCount: 6,
            ),
          ),
        );

      case LoadStatus.error:
        return SliverToBoxAdapter(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 48),
              child: GestureDetector(
                onTap: () => ref.read(bookListProvider.notifier).refresh(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.wifi_off_rounded, size: 32,
                        color: theme.colorScheme.outline),
                    const SizedBox(height: 8),
                    Text(
                      'Tap to retry',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.outline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

      case LoadStatus.loaded:
      case LoadStatus.loadingMore:
        if (filtered.isEmpty) {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.search_off_rounded, size: 48, color: theme.colorScheme.outline),
                  const SizedBox(height: 12),
                  Text('No books found',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      )),
                ],
              ),
            ),
          );
        }

        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 16,
              mainAxisSpacing: 24,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index >= filtered.length) return null;
                final book = filtered[index];
                return BookCard(
                  book: book,
                  onTap: () => context.push('/book/${book.id}', extra: book),
                );
              },
              childCount: filtered.length + (state.status == LoadStatus.loadingMore ? 2 : 0),
            ),
          ),
        );
    }
  }

  Widget _buildSearchBar(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: theme.colorScheme.outlineVariant,
          width: 1,
        ),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          ref.read(bookListProvider.notifier).search(value);
        },
        decoration: InputDecoration(
          hintText: 'Search by title or author...',
          hintStyle: TextStyle(
            color: theme.colorScheme.outline.withValues(alpha: 0.6),
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 16, right: 8),
            child: Icon(Icons.search, color: theme.colorScheme.outline, size: 20),
          ),
          prefixIconConstraints: const BoxConstraints(minWidth: 44, minHeight: 0),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.close, color: theme.colorScheme.outline, size: 18),
                  onPressed: () {
                    _searchController.clear();
                    ref.read(bookListProvider.notifier).search('');
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        style: theme.textTheme.bodyMedium,
      ),
    );
  }

  Widget _buildGenreChips(ThemeData theme, String selected) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _genres.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final genre = _genres[index];
          final isSelected = selected == genre;
          return GestureDetector(
            onTap: () => ref.read(bookListProvider.notifier).setGenre(genre),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: isSelected
                    ? theme.colorScheme.secondary
                    : theme.colorScheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(100),
                border: Border.all(
                  color: isSelected
                      ? theme.colorScheme.secondary
                      : theme.colorScheme.outlineVariant,
                  width: 1,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                genre,
                style: GoogleFonts.hankenGrotesk(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.05,
                  height: 20 / 14,
                  color: isSelected
                      ? theme.colorScheme.onSecondary
                      : theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
