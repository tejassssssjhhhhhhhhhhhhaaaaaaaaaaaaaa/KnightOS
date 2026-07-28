import '../domain/import_provider.dart';
import 'providers/google_timeline_provider.dart';
import 'providers/pdf_document_provider.dart';
import 'providers/finance_statement_provider.dart';

class ImportRegistry {
  ImportRegistry._();

  static final List<ImportProvider> _providers = [
    GoogleTimelineProvider(),
    PdfDocumentProvider(),
    FinanceStatementProvider(),
  ];

  /// Returns all registered import providers.
  static List<ImportProvider> get providers => List.unmodifiable(_providers);

  /// Discovers which provider can handle a specific file.
  static ImportProvider? findProviderForFile(dynamic file) {
    return null;
  }
}
