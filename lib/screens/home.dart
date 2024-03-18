import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:quickalert/quickalert.dart';

class Datascreen extends StatelessWidget {
  Datascreen({super.key});

  var inputcon = TextEditingController();

  void additem() async {
    await FirebaseFirestore.instance.collection('inputs').add({
      'data' : inputcon.text
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle:  true,
      ),
      body:  Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Gap(20),
              TextField(
                controller: inputcon,
                decoration: InputDecoration(
                  border: OutlineInputBorder()
                ),
              ),
              Gap(10),
              ElevatedButton(onPressed: additem, child: const Text('Add')),
              Gap(10),
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('inputs').snapshots(),
                  builder: (_, snapshots){
                    if(snapshots.connectionState == ConnectionState.waiting){
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    final document = snapshots.data!.docs;
                      return ListView.builder(
                        itemCount: document.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Dismissible
                          (key: Key(document[index].id), 
                          onDismissed: (direction) async {
                            QuickAlert.show(context: context, 
                            type: QuickAlertType.confirm,
                            confirmBtnText: 'Delete',
                            onCancelBtnTap: () {
                              Navigator.of(context).pop();
                            },
                            confirmBtnColor: Colors.red,
                            onConfirmBtnTap: () async {
                              await FirebaseFirestore.instance.collection('inputs').doc(document[index].id).delete();
                              Navigator.of(context).pop();
                            },
                            );
                          },
                          direction: DismissDirection.horizontal,
                          background: Container(
                            color: Colors.red,
                            child: Icon(Icons.delete),
                          ),

                          child: Card(
                            color: Colors.yellow,
                            elevation: 10,
                            child: ListTile(
                              title: Text(document[index]['data']),
                            ),
                          )
                          );
                        },
                      );
                  },
                ),
              )
            ],
          ),
        ),
      
    );
  }
}