import 'dart:html';

class ImageUploadModel {
  bool? isUploaded;
  bool? uploading;
  File? imageFile;
  String? imageUrl;

  ImageUploadModel({
    this.isUploaded,
    this.uploading,
    this.imageFile,
    this.imageUrl,
  });
}