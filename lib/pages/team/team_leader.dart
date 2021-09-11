import 'package:chat_app/utils/global_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'defect_image_form.dart';

class TeameLeaderPage extends StatefulWidget {
  //const AdminHomePage({Key? key}) : super(key: key);
  static const String routeName = "\team_leader";

  @override
  _TeameLeaderPageState createState() => _TeameLeaderPageState();
}

class _TeameLeaderPageState extends State<TeameLeaderPage> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final List<Widget> _picturesReportFormWidget = [];
  final String _error = 'No Problem';
  bool processButtn = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
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
                setState(() {
                  _picturesReportFormWidget.add(const DefectImageForm());
                });
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
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              (!processButtn) ? Text('Error: $_error'): ElevatedButton(
                  onPressed: (){

                  },
                  child: const Text("Process")
              ),
              const SizedBox(height: 10),
              Flexible(
                child: ListView.builder(
                  itemCount: _picturesReportFormWidget.length,
                  itemBuilder: (context,index){
                    return _picturesReportFormWidget[index];
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
