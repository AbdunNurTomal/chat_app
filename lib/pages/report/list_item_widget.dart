import 'package:chat_app/models/list_item.dart';
import 'package:chat_app/provider/list_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'item_widget.dart';

class ListItemWidget extends StatefulWidget {

  @override
  State<ListItemWidget> createState() => _ListItemWidgetState();
}

class _ListItemWidgetState extends State<ListItemWidget> {
  late ListProvider taskItems;


  @override
  void didChangeDependencies() {
    taskItems = Provider.of<ListProvider>(context);
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    final listClass = taskItems.allListItem;
    return listClass.isEmpty
        ? const Center(
          child: Text(
            'No Item.',
            style: TextStyle(fontSize: 20),
          ),
        )
        : ListView.separated(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(10),
            separatorBuilder: (context, index) => const Divider(
              height: 6,
              //color: Colors.black,
            ),
            itemCount: listClass.length,
            itemBuilder: (context, index) {
              final listItem = listClass[index];
              return ItemWidget(listItem: listItem);
            },
        );
  }
}
