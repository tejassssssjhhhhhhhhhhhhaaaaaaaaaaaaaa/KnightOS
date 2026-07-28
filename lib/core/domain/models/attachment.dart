class Attachment {
  const Attachment({
    required this.id,
    required this.relatedId,
    required this.filePath,
    required this.fileName,
    this.mimeType,
    this.fileSize,
    this.createdAt,
  });

  final String id;
  final String
  relatedId; // ID of the model this is attached to (e.g. TimelineEvent)
  final String filePath;
  final String fileName;
  final String? mimeType;
  final String? fileSize;
  final DateTime? createdAt;
}
