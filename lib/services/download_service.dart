import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import '../config/supabase.dart';
import '../core/result.dart';
import '../models/book.dart';

class DownloadService {
  static final DownloadService _instance = DownloadService._();
  factory DownloadService() => _instance;
  DownloadService._();

  final _dio = Dio();

  Future<String> localPath(String bookId) async {
    final dir = await getApplicationDocumentsDirectory();
    final bookDir = Directory('${dir.path}/books');
    if (!await bookDir.exists()) await bookDir.create(recursive: true);
    return '${bookDir.path}/$bookId.pdf';
  }

  Future<bool> isDownloaded(String bookId) async {
    return File(await localPath(bookId)).exists();
  }

  Future<Result<String>> download({
    required Book book,
    required void Function(double progress) onProgress,
  }) async {
    try {
      final savePath = await localPath(book.id);
      final file = File(savePath);
      if (await file.exists()) return Success(savePath);

      String url = book.fileUrl;
      if (url.isEmpty && SupabaseConfig.isConfigured) {
        url = SupabaseConfig.client.storage
            .from('books')
            .getPublicUrl('${book.id}.pdf');
      }

      await _dio.download(
        url,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) onProgress(received / total);
        },
      );

      return Success(savePath);
    } catch (e) {
      return Failure('Failed to download book', error: e);
    }
  }

  Future<void> delete(String bookId) async {
    final file = File(await localPath(bookId));
    if (await file.exists()) await file.delete();
  }
}
