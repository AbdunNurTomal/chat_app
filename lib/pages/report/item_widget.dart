import 'package:chat_app/models/defect.dart';
import 'package:chat_app/models/list_item.dart';
import 'package:chat_app/provider/list_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'edit_list_item_dialog_widget.dart';

class ItemWidget extends StatelessWidget {
  final ListItem  listItem;
  const ItemWidget({Key? key, required this.listItem}) : super(key: key);

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(5),
    child: Slidable(
      actionPane: const SlidableDrawerActionPane(),
      key: Key(listItem.id!),
      // actions: [
      //   IconSlideAction(
      //     color: Colors.green,
      //     onTap: () => editItem(context, listItem),
      //     caption: 'Edit',
      //     icon: Icons.edit,
      //   )
      // ],
      secondaryActions: [
        IconSlideAction(
          color: Colors.red,
          caption: 'Delete',
          onTap: () => deleteItem(context, listItem),
          icon: Icons.delete,
        )
      ],
      child: buildItem(context),
    ),
  );
  Widget buildItem(BuildContext context) {
    //print("List Item : ${listItem.item}");
    return GestureDetector(
      onTap: () => editItem(context, listItem),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black26,
            width: 3,
          ),
          borderRadius: BorderRadius.circular(5)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildDDItemHead(listItem.item!),
            buildGridView(listItem.images),
            //if (todo.description.isNotEmpty)
            //  Container(
            //    margin: EdgeInsets.only(top: 4),
            //    child: Text(
            //      todo.description,
            //      style: TextStyle(fontSize: 20, height: 1.5),
            //    ),
            //  )
          ],
        ),
      ),
    );
  }

  void deleteItem(BuildContext context, ListItem listItem) {
    final provider = Provider.of<ListProvider>(context, listen: false);
    showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        title: const Text("Delete Confirmation"),
        content: const Text(
            "Are you sure, want to delete this item?"),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              provider.deleteItem(listItem);
              final deleteToAddItem = Defects(
                itemNumber: listItem.itemValue!,
                itemName: listItem.item!,
              );
              DefectData.addDefectItem(deleteToAddItem);
              Navigator.of(context).pop(false);
            },
            child: const Text("Delete"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Cancel"),
          ),
        ],
      );
    }
    );
  }
  void editItem(BuildContext context, ListItem listItem) {
    DefectData.callDefect();
    DefectData.deleteDefectItem(listItem.item!);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditListItemDialogWidget(listItem: listItem),
      ),
    );
    print("Edit Page");
  }

  Widget buildDDItemHead(String _ddItem) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.lightBlueAccent,
          width: 2,
        ),
        color: Colors.lightBlue,
        borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(0),
            bottomRight: Radius.circular(0),
            topLeft: Radius.circular(3),
            topRight: Radius.circular(3)
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          const SizedBox(width: 5.0),
          const Icon(FontAwesomeIcons.coins, size: 22.0, color: Colors.white),
          const SizedBox(width: 10.0),
          Flexible(
            child: Text(_ddItem, style: const TextStyle(color: Colors.black, fontSize: 22)
            ),
          ),
        ],
      ),
    );
  }

  Widget buildGridView(List<Asset> images) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black12,
          width: 2,
        ),
        color: Colors.black54,
        borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(3),
            bottomRight: Radius.circular(3),
            topLeft: Radius.circular(0),
            topRight: Radius.circular(0)
        ),
      ),
      child: Stack(
          children: [
            Container(
              color: Colors.black26,
            ),
            SizedBox(
              height: 128.0,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: images.length,
                itemBuilder: (context, index) {
                  Asset asset = images[index];
                  //print("name ${asset.name}");
                  //print("identifier ${asset.identifier}");
                  return Card(
                    //clipBehavior: Clip.antiAlias,
                    elevation: 5.0,
                    child: Container(
                      height: MediaQuery.of(context).size.width / 3,
                      width: MediaQuery.of(context).size.width / 3,
                      alignment: Alignment.center,
                      child: AssetThumb(
                        asset: asset,
                        width: 300,
                        height: 300,
                        quality: 75,
                      ),
                    ),
                  );
                },
              ),
            ),
          ]
      ),
    );//const SizedBox(height: 10.0),
  }

}
