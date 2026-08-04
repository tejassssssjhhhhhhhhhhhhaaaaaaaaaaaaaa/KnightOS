import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../core/internal/utils/knight_logger.dart';
import '../../../../core/providers/integration_providers.dart';

class ManualImportState {
  const ManualImportState({
    this.isImporting = false,
    this.lastImportedId,
    this.error,
  });

  final bool isImporting;
  final String? lastImportedId;
  final String? error;

  ManualImportState copyWith({
    bool? isImporting,
    String? lastImportedId,
    String? error,
  }) {
    return ManualImportState(
      isImporting: isImporting ?? this.isImporting,
      lastImportedId: lastImportedId ?? this.lastImportedId,
      error: error ?? this.error,
    );
  }
}

class ManualImportNotifier extends Notifier<ManualImportState> {
  @override
  ManualImportState build() {
    return const ManualImportState();
  }

  Future<void> pickAndImport(String type) async {
    state = state.copyWith(isImporting: true, error: null);

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'csv', 'jpg', 'png', 'txt'],
      );

      if (result == null || result.files.isEmpty) {
        state = state.copyWith(isImporting: false);
        return;
      }

      final file = result.files.first;
      final path = file.path;
      if (path == null) throw Exception('Invalid file path');

      final caid = 'local_${DateTime.now().millisecondsSinceEpoch}_${file.name}';
      
      final connector = ref.read(manualConnectorProvider);

      KnightLogger.info('[UI] Importing file: ${file.name} as $type');

      await connector.importFile(
        type: type,
        path: path,
        caid: caid,
        name: file.name,
        metadata: {
          'mime_type': _getMimeType(file.extension),
          'size': file.size,
          'extension': file.extension,
          'timestamp': DateTime.now().toIso8601String(),
          'title': '${type.toUpperCase()}: ${file.name}',
        },
      );

      state = state.copyWith(isImporting: false, lastImportedId: caid);
    } catch (e) {
      KnightLogger.error('[UI] Import failed', error: e);
      state = state.copyWith(isImporting: false, error: e.toString());
    }
  }

  String _getMimeType(String? extension) {
    switch (extension?.toLowerCase()) {
      case 'pdf': return 'application/pdf';
      case 'csv': return 'text/csv';
      case 'jpg':
      case 'jpeg': return 'image/jpeg';
      case 'png': return 'image/png';
      default: return 'application/octet-stream';
    }
  }
}

final manualImportControllerProvider = NotifierProvider<ManualImportNotifier, ManualImportState>(
  ManualImportNotifier.new,
);
