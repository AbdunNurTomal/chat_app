import 'dart:io';

class ListImagesItem {
  //bool? isUploaded;
  //bool? uploading;
  int? itemValue;
  String? oldImgName; //Unique
  File? oldImgUriFile;
  String? newImgName;
  String? newImgPath;
  String? proImgName;
  bool isImgEdited;

  ListImagesItem({
    //this.isUploaded,
    //this.uploading,
    this.itemValue,
    this.oldImgName,
    this.oldImgUriFile,
    this.newImgName,
    this.newImgPath,
    this.proImgName,
    this.isImgEdited = false,
  });

  // factory ListImagesItem.fromMap(Map<String, dynamic> data) => ListImagesItem(
  //   oldImgName: data["old_image_name"],
  //   oldImgFile: data["old_image_file"],
  //   oldImgUri: data["old_image_uri"],
  //   oldImgPath: data["old_image_path"],
  //   newImgName: data["new_image_name"],
  //   newImgFile: data["new_image_file"],
  //   newImgUri: data["new_image_uri"],
  //   newImgPath: data["new_image_path"],
  //   isImgEdited: data["is_image_edited"],
  // );
}