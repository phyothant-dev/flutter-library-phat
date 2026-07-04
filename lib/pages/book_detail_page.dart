import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/book.dart';
import '../providers/download_provider.dart';

class BookDetailPage extends ConsumerWidget {
  final Book book;

  const BookDetailPage({super.key, required this.book});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final download = ref.watch(downloadProvider(book));

    ref.listen(downloadProvider(book), (prev, next) {
      if (next.status == DownloadStatus.downloaded && next.localPath != null) {
        context.push('/reader/${book.id}?localPath=${Uri.encodeComponent(next.localPath!)}', extra: book);
      }
    });

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            stretch: true,
            backgroundColor: theme.colorScheme.surface,
            surfaceTintColor: theme.colorScheme.surfaceTint,
            leading: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: theme.colorScheme.primary),
                onPressed: () => context.pop(),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [StretchMode.blurBackground],
              background: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 56),
                  child: Center(
                    child: Hero(
                      tag: book.id,
                      child: Container(
                        width: 180,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF1A281E).withValues(alpha: 0.08),
                              blurRadius: 60,
                              offset: const Offset(20, 20),
                            ),
                            BoxShadow(
                              color: const Color(0xFF1A281E).withValues(alpha: 0.03),
                              blurRadius: 15,
                              offset: const Offset(-5, 0),
                            ),
                          ],
                        ),
                        child: AspectRatio(
                          aspectRatio: 2 / 3,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: CachedNetworkImage(
                              imageUrl: book.coverUrl,
                              fit: BoxFit.contain,
                              placeholder: (context, url) => Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: theme.colorScheme.secondary,
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: theme.colorScheme.surfaceContainerHigh,
                                child: Icon(
                                  Icons.book_outlined,
                                  size: 64,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 32),
                  Text(
                    book.title,
                    style: GoogleFonts.ebGaramond(
                      fontSize: 32,
                      fontWeight: FontWeight.w500,
                      height: 40 / 32,
                      letterSpacing: -0.02,
                      color: theme.colorScheme.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    book.author.toUpperCase(),
                    style: GoogleFonts.hankenGrotesk(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.05,
                      height: 20 / 14,
                      color: theme.colorScheme.outline,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  _buildDownloadButton(context, ref, theme, download),
                  const SizedBox(height: 12),
                  _buildReadButton(context, theme, download),
                  const SizedBox(height: 40),
                  Row(
                    children: [
                      Text(
                        'Description',
                        style: GoogleFonts.ebGaramond(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          height: 28 / 20,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    book.description,
                    style: GoogleFonts.hankenGrotesk(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      height: 28 / 18,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDownloadButton(
      BuildContext context, WidgetRef ref, ThemeData theme, DownloadState download) {
    final isDownloading = download.status == DownloadStatus.downloading;
    final isDownloaded = download.status == DownloadStatus.downloaded;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: isDownloading
            ? null
            : () => ref.read(downloadProvider(book).notifier).download(),
        icon: isDownloading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  value: download.progress,
                  strokeWidth: 2,
                  color: theme.colorScheme.surfaceBright,
                ),
              )
            : Icon(
                isDownloaded ? Icons.download_done_rounded : Icons.download_rounded,
                size: 20,
              ),
        label: Text(isDownloading
            ? '${(download.progress * 100).toInt()}%'
            : isDownloaded
                ? 'Downloaded'
                : 'Download'),
        style: ElevatedButton.styleFrom(
          backgroundColor: isDownloaded
              ? theme.colorScheme.secondaryContainer
              : theme.colorScheme.primary,
          foregroundColor: isDownloaded
              ? theme.colorScheme.onSecondaryContainer
              : theme.colorScheme.surfaceBright,
          disabledBackgroundColor: theme.colorScheme.primary,
          disabledForegroundColor: theme.colorScheme.surfaceBright,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
          textStyle: GoogleFonts.hankenGrotesk(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.05,
          ),
        ),
      ),
    );
  }

  Widget _buildReadButton(
      BuildContext context, ThemeData theme, DownloadState download) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {
          final path = download.status == DownloadStatus.downloaded &&
                  download.localPath != null
              ? '?localPath=${Uri.encodeComponent(download.localPath!)}'
              : '';
          context.push('/reader/${book.id}$path', extra: book);
        },
        icon: const Icon(Icons.menu_book, size: 20),
        label: const Text('Read Now'),
        style: OutlinedButton.styleFrom(
          foregroundColor: theme.colorScheme.primary,
          side: BorderSide(color: theme.colorScheme.outline),
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
          textStyle: GoogleFonts.hankenGrotesk(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.05,
          ),
        ),
      ),
    );
  }
}
