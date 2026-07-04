import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../models/book.dart';

class PdfReaderPage extends StatelessWidget {
  final Book book;
  final String? localPath;

  const PdfReaderPage({
    super.key,
    required this.book,
    this.localPath,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(
          book.title,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.primary,
          ),
        ),
        backgroundColor: theme.colorScheme.surface,
        surfaceTintColor: theme.colorScheme.surfaceTint,
        iconTheme: IconThemeData(color: theme.colorScheme.primary),
      ),
      body: SfPdfViewer.network(
        localPath ?? book.fileUrl,
        canShowScrollStatus: true,
        canShowPaginationDialog: true,
        enableDoubleTapZooming: true,
        enableTextSelection: true,
      ),
    );
  }
}
