import 'dart:html';

class ImageUploadModel {
  //bool? isUploaded;
  //bool? uploading;
  File? imageFile;
  String? imageUrl;

  ImageUploadModel({
    //this.isUploaded,
    //this.uploading,
    this.imageFile,
    this.imageUrl,
  });

  factory ImageUploadModel.fromMap(Map<String, dynamic> data) => ImageUploadModel(
    imageFile: data["item_number"],
    imageUrl: data["item_name"],
  );
}