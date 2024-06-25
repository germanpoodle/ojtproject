class UploadFile {
  final String name;
  final int size;
  double progress;
  String? filePath; // Add this field to store the local file path

  UploadFile({
    required this.name,
    required this.size,
    this.progress = 0.0,
    this.filePath,
  });
}
