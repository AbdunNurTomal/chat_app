
import 'package:multi_image_picker2/multi_image_picker2.dart';

class ListItem {
  String? id;
  String? itemValue;
  String? item;
  DateTime? createdTime;
  List<Asset> images;
  List<int> edited;

  ListItem({
    this.id,
    required this.itemValue,
    required this.item,
    required this.images,
    required this.edited,
    this.createdTime,
  });

}
