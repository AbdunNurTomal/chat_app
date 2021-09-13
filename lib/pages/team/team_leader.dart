import 'package:chat_app/models/dynamic_list.dart';
import 'package:chat_app/provider/list_provider.dart';
import 'package:chat_app/utils/global_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import 'defect_image_form.dart';

class TeameLeaderPage extends StatefulWidget {
  //const AdminHomePage({Key? key}) : super(key: key);
  static const String routeName = "\team_leader";

  @override
  _TeameLeaderPageState createState() => _TeameLeaderPageState();
}

class _TeameLeaderPageState extends State<TeameLeaderPage> {//with SingleTickerProviderStateMixin {
  //GlobalKey<FormState> _formKey;
  var taskItems;
  int counter = 0;
  late DynamicList listClass;

  final _formKey = GlobalKey<FormState>();
  //final List<Widget> _picturesReportFormWidget = [];
  final String _error = 'No Problem';
  bool processButtn = false;

  @override
  void initState() {
    super.initState();

    taskItems = Provider.of<ListProvider>(context, listen: false);
    listClass = DynamicList(taskItems.list);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
          title: Row(
            children: [
              SizedBox(
                  width:20,
                  child:Image.asset("images/pqc.png")
              ),
              const SizedBox(width:10),
              const Text('Pictures Report Form'),
            ],
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.add),
              tooltip: 'Add form field',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Trying to add field in form'),
                  ),
                );
                taskItems.addItem(DefectImageForm());
              },
            ),
        /*
            IconButton(
              icon: const Icon(Icons.navigate_next),
              tooltip: 'Go to the second page',
              onPressed: () {
                Navigator.push(context, MaterialPageRoute<void>(
                  builder: (BuildContext context) {
                    return AppbarSecondHome();
                  },
                ));
              },
            ),

       */
          ],
        ),
        /*
        floatingActionButton: FloatingActionButton(
          child: Text(
            '+',
            style: TextStyle(fontSize: 20.0),
          ),
          shape: RoundedRectangleBorder(
              side: BorderSide(
                  color: Colors.black26, width: 1.0, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(10.0)),
          onPressed: () {
            setState(() {
              _listDefectImageFormWidget.add(
                  DeleteImageForm(defectItemName: 'Defect Item',
              ));
            });
          },
        ),
         */
        body: Column(
            key: _formKey,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child:
                (!processButtn) ? Text('Error: $_error'): ElevatedButton(
                  onPressed: (){

                  },
                  child: const Text("Process")
                ),
              ),
              Consumer<ListProvider>(builder: (context, provider, child) {
                return Expanded(
                  child: ListView.separated(
                    itemCount: listClass.list.length,
                    separatorBuilder: (context, index) => const Divider(
                        height: 8,
                        color: Colors.black,
                      ),
                    itemBuilder: buildList,
                  ),
                );
              }),
            ],
          ),
    );
  }

  Widget buildList(BuildContext context, int index) {
    counter++;
    return Dismissible(
      key: Key(counter.toString()),
      direction: DismissDirection.endToStart,
      onDismissed: (DismissDirection direction){
          taskItems.deleteItem(index);
      },
      confirmDismiss: (DismissDirection direction) async {
        return await showDialog(
        context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Delete Confirmation"),
              content: const Text(
              "Are you sure you want to delete this item?"),
              actions: <Widget>[
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text("Delete"),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("Cancel"),
                ),
              ],
            );
          },
        );
      },
      secondaryBackground: Container(
        child: const Center(
          child: Text(
            'Delete',
            style: TextStyle(color: Colors.white),
          ),
        ),
        color: Colors.red,
      ),
      background: Container(),
      child: Container(
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black45,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(5)
        ),
        child: listClass.list[index],
      )
    );
  }

}
