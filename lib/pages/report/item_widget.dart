import 'dart:typed_data';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:chat_app/models/defect.dart';
import 'package:chat_app/models/list_item.dart';
import 'package:chat_app/provider/list_provider.dart';
import 'package:chat_app/utils/image_full_screen_wrapper.dart';
import 'package:chat_app/utils/image_util.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:uri_to_file/uri_to_file.dart';

import 'edit_list_item_dialog_widget.dart';

class ItemWidget extends StatelessWidget {
  final ListItem  listItem;
  ItemWidget({Key? key, required this.listItem}) : super(key: key);

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(5),
    child: Slidable(
      actionPane: const SlidableDrawerActionPane(),
      key: Key(listItem.id!.toString()),
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
            buildDDItemHead(listItem.itemValue!,listItem.item!,listItem.images.length),
            SizedBox(
                height: 10,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    border: Border.all(
                      color: Colors.black12,
                      width: 2,
                    ),
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(0),
                        topLeft: Radius.circular(0),
                        topRight: Radius.circular(0)
                    ),
                  ),
                  child: StepProgressIndicator(
                    totalSteps: 20,
                    currentStep: listItem.images.length,
                    size: 5,
                    selectedColor: Colors.orange,
                    unselectedColor: Colors.white24,
                  )
                ),
            ),
            buildGridView(context, listItem.images),
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
            onPressed: () async {
              String imageDir = await ImageUtility.getImageDirPath();
              int counter = 0;

              for(int i=0;i<listItem.images.length;i++) {
                ++counter;
                // if(await File('$imageDir/${listItem.images[i].name}').exists()){
                //   await File('$imageDir/${listItem.images[i].name}').delete();
                // }

                String? itemSuffix = "${listItem.itemValue}\_$counter.jpg";
                if(await File('$imageDir/$itemSuffix').exists()){
                  await File('$imageDir/$itemSuffix').delete();
                }

                DefectImageData.allListImagesItem.removeWhere((element) => element.newImgName == itemSuffix);

              }
              for (var element in DefectImageData.allListImagesItem) {
                print("element >>> ${element.oldImgName} & newImageName >>> ${element.newImgName} & proImageName >>> ${element.proImgName}");
              }

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
    // DefectData.callDefect();
    // DefectData.deleteDefectItem(listItem.item!);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditListItemDialogWidget(listItem: listItem),
      ),
    );
    print("listed item >> ${listItem.images.length}");
  }

  Widget buildDDItemHead(String _ddItemValue, String _ddItem, int noOfImages) {
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
          const Icon(FontAwesomeIcons.layerGroup, size: 22.0, color: Colors.white),
          const SizedBox(width: 10.0),
          Flexible(
            child: Text("(${noOfImages.toString()} pic)", style: const TextStyle(color: Colors.black, fontSize: 15)
            ),
          ),
          const SizedBox(width: 5.0),
          Flexible(
            child: Text(_ddItem, style: const TextStyle(color: Colors.black, fontSize: 22)
            ),
          ),
        ],
      ),
    );
  }

  Widget buildGridView(BuildContext context,List<Asset> images) {
    final provider = Provider.of<ListProvider>(context, listen: false);
    return SizedBox(
      height: 128.0,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.black54,
          border: Border.all(
            color: Colors.black12,
            width: 2,
          ),
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(3),
              bottomRight: Radius.circular(3),
              topLeft: Radius.circular(0),
              topRight: Radius.circular(0)
          ),
        ),
        // color: Colors.black54,
      child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: images.length,
            itemBuilder: (context, index) {
              Asset asset = images[index];
              // print("item widget >> name ${asset.name}");
              // print("item widget >> identifier ${asset.identifier}");
              return Card(
                // clipBehavior: Clip.antiAlias,
                elevation: 5.0,
                child: SizedBox(
                    height: MediaQuery.of(context).size.width / 3,
                    width: MediaQuery.of(context).size.width / 3,
                    // alignment: Alignment.center,
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
    );//const SizedBox(height: 10.0),
  }
}
