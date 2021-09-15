class Defects {
  String itemNumber;
  String itemName;

  Defects({required this.itemNumber,required this.itemName});

  factory Defects.fromMap(Map<String, dynamic> data) => Defects(
    itemNumber: data["item_number"],
    itemName: data["item_name"],
  );

  Map<String, dynamic> toMap() {
    return {
      'item_number': itemNumber,
      'item_name': itemName,
    };
  }
}
