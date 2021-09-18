import 'dart:io';

import 'package:multi_image_picker2/multi_image_picker2.dart';

class ListItem {
  String? id;
  String? itemValue;
  String? item;
  DateTime? createdTime;
  List<Asset> images;

  ListItem({
    this.id,
    this.itemValue,
    this.item,
    required this.images,
    this.createdTime,
  });

}
