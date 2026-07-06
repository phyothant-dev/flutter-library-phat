import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:go_router/go_router.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import '../models/book.dart';

class PdfReaderPage extends StatefulWidget {
  final Book book;

  const PdfReaderPage({
    super.key,
    required this.book,
  });

  @override
  State<PdfReaderPage> createState() => _PdfReaderPageState();
}

class _PdfReaderPageState extends State<PdfReaderPage> {
  PDFViewController? _controller;
  int _savedPage = 0;
  String? _error;
  bool _isLoading = false;
  bool _isExtracting = false;
  double _downloadProgress = 0;
  String? _localPath;

  @override
  void initState() {
    super.initState();
    _initPdf();
  }

  Future<void> _initPdf() async {
    await _loadLastPage();

    try {
      final tempDir = await getTemporaryDirectory();
      final tempPath = '${tempDir.path}/pdfs/${widget.book.id}.pdf';
      final tempFile = File(tempPath);
      if (await tempFile.exists() && (await tempFile.length()) > 0) {
        setState(() => _localPath = tempPath);
        return;
      }

      if (widget.book.fileUrl.isEmpty) {
        setState(() => _error = 'No file URL available for this book');
        return;
      }

      setState(() => _isLoading = true);
      try {
        await tempFile.parent.create(recursive: true);
        final dio = Dio();
        await dio.download(
          widget.book.fileUrl,
          tempPath,
          onReceiveProgress: (received, total) {
            if (total != -1 && mounted) {
              setState(() => _downloadProgress = received / total);
            }
          },
        );
        if (await tempFile.exists() && (await tempFile.length()) > 0) {
          setState(() => _localPath = tempPath);
        } else {
          setState(() => _error = 'Downloaded file is empty');
        }
      } catch (e) {
        setState(() => _error = 'Download failed');
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    }
  }

  Future<String> _pagePath() async {
    final dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/books/${widget.book.id}.page';
  }

  Future<void> _loadLastPage() async {
    try {
      final pageFile = File(await _pagePath());
      if (await pageFile.exists()) {
        final page = int.tryParse(await pageFile.readAsString());
        if (page != null && page > 0) {
          _savedPage = page;
        }
      }
    } catch (_) {}
  }

  Future<void> _savePage(int page) async {
    try {
      final pageFile = File(await _pagePath());
      await pageFile.writeAsString(page.toString());
    } catch (_) {}
  }

  Future<void> _copyPageText() async {
    if (_localPath == null || _localPath!.isEmpty || _isExtracting) return;

    final file = File(_localPath!);
    final exists = await file.exists();
    if (!exists) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('File not found')),
        );
      }
      return;
    }

    final size = await file.length();
    if (size > 50 * 1024 * 1024) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('File too large for text extraction (max 50MB)')),
        );
      }
      return;
    }

    setState(() => _isExtracting = true);
    try {
      final bytes = await file.readAsBytes();
      final document = PdfDocument(inputBytes: bytes);
      final currentPage = (await _controller?.getCurrentPage()) ?? 0;
      final extractor = PdfTextExtractor(document);
      final text = extractor.extractText(
        startPageIndex: currentPage,
        endPageIndex: currentPage,
      );
      document.dispose();

      if (text.trim().isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No selectable text on this page')),
          );
        }
        return;
      }

      await Clipboard.setData(ClipboardData(text: text));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Copied page ${currentPage + 1} (${text.length} characters)'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Text extraction failed')),
        );
      }
    } finally {
      if (mounted) setState(() => _isExtracting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_error != null) {
      return _buildErrorScreen(theme);
    }

    if (_isLoading || _localPath == null || _localPath!.isEmpty) {
      return _buildLoadingScreen(theme);
    }

    final file = File(_localPath!);
    if (!file.existsSync() || file.lengthSync() == 0) {
      return _buildErrorScreen(theme);
    }

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(
          widget.book.title,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.primary,
          ),
        ),
        backgroundColor: theme.colorScheme.surface,
        surfaceTintColor: theme.colorScheme.surfaceTint,
      ),
      body: PDFView(
        filePath: _localPath!,
        enableSwipe: true,
        swipeHorizontal: false,
        autoSpacing: true,
        pageFling: true,
        onRender: (pages) {
          if (_savedPage > 0 && _controller != null) {
            _controller!.setPage(_savedPage - 1);
          }
        },
        onViewCreated: (controller) {
          _controller = controller;
        },
        onPageChanged: (page, total) {
          if (page != null) _savePage(page + 1);
        },
        onError: (error) {
          if (mounted) setState(() => _error = error);
        },
      ),
    );
  }

  Widget _buildErrorScreen(ThemeData theme) {
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(
          widget.book.title,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.primary,
          ),
        ),
        backgroundColor: theme.colorScheme.surface,
        surfaceTintColor: theme.colorScheme.surfaceTint,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.picture_as_pdf, size: 64,
                  color: theme.colorScheme.error),
              const SizedBox(height: 16),
              Text(
                _error ?? 'Could not open this PDF',
                style: theme.textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.arrow_back, size: 18),
                label: const Text('Go back'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingScreen(ThemeData theme) {
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(
          widget.book.title,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.primary,
          ),
        ),
        backgroundColor: theme.colorScheme.surface,
        surfaceTintColor: theme.colorScheme.surfaceTint,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              value: _downloadProgress > 0 ? _downloadProgress : null,
            ),
            if (_downloadProgress > 0) ...[
              const SizedBox(height: 16),
              Text(
                '${(_downloadProgress * 100).toInt()}%',
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
