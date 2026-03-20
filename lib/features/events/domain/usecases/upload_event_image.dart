import '../repositories/event_repository.dart';

class UploadEventImage {
  final EventRepository repository;

  UploadEventImage(this.repository);

  Future<String> call(String filePath, String fileName) {
    return repository.uploadImage(filePath, fileName);
  }
}
