import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/book.dart';
import '../services/download_service.dart';

enum DownloadStatus { idle, downloading, downloaded, error }

class DownloadState {
  final DownloadStatus status;
  final double progress;
  final String? localPath;
  final String? error;

  const DownloadState({
    this.status = DownloadStatus.idle,
    this.progress = 0,
    this.localPath,
    this.error,
  });

  DownloadState copyWith({
    DownloadStatus? status,
    double? progress,
    String? localPath,
    String? error,
  }) {
    return DownloadState(
      status: status ?? this.status,
      progress: progress ?? this.progress,
      localPath: localPath ?? this.localPath,
      error: error ?? this.error,
    );
  }
}

class DownloadNotifier extends StateNotifier<DownloadState> {
  DownloadNotifier(this.book) : super(const DownloadState());

  final Book book;
  final _service = DownloadService();

  Future<void> checkStatus() async {
    final downloaded = await _service.isDownloaded(book.id);
    if (downloaded) {
      final path = await _service.localPath(book.id);
      state = DownloadState(
        status: DownloadStatus.downloaded,
        localPath: path,
      );
    }
  }

  Future<void> download() async {
    state = state.copyWith(status: DownloadStatus.downloading, progress: 0);

    final result = await _service.download(
      book: book,
      onProgress: (progress) {
        state = state.copyWith(progress: progress);
      },
    );

    result.when(
      success: (path) {
        state = DownloadState(
          status: DownloadStatus.downloaded,
          localPath: path,
        );
      },
      failure: (message, _) {
        state = state.copyWith(
          status: DownloadStatus.error,
          error: message,
        );
      },
    );
  }

  Future<void> delete() async {
    await _service.delete(book.id);
    state = const DownloadState();
  }
}

final downloadProvider =
    StateNotifierProvider.family<DownloadNotifier, DownloadState, Book>(
  (_, book) => DownloadNotifier(book),
);
