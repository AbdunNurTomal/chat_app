
class Defects {
  String itemNumber;
  String itemName;

  Defects({required this.itemNumber,required this.itemName});

  factory Defects.fromMap(Map<String, dynamic> data) => Defects(
    itemNumber: data["item_number"],
    itemName: data["item_name"],
  );

  static List<Defects> fromMapList(List? list) {
    return list!.map((item) => Defects.fromMap(item)).toList();
  }
  String defectsAsString() {
    return '#${itemNumber} ${itemName}';
  }
  bool defectFilterByNumber(String? filter) {
    return itemNumber.toString().contains(filter!);
  }
  bool isEqual(Defects model) {
    return itemNumber == model.itemNumber;
  }

  Map<String, dynamic> toMap() {
    return {
      'item_number': itemNumber,
      'item_name': itemName,
    };
  }

  @override
  String toString() => itemName;
}
