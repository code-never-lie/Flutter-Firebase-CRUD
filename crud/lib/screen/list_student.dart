// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud/screen/update_student.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListStudentPage extends StatefulWidget {
  const ListStudentPage({Key? key}) : super(key: key);

  @override
  _ListStudentPageState createState() => _ListStudentPageState();
}

class _ListStudentPageState extends State<ListStudentPage> {
  final Stream<QuerySnapshot> studentsStrem =
      FirebaseFirestore.instance.collection("students").snapshots();

  //for delete

  CollectionReference student =
      FirebaseFirestore.instance.collection('students');

  Future<void> deleteUser(id) {
    // ignore: avoid_print
    print(id);
    return student.doc(id).delete().then((value) =>
        // ignore: avoid_print
        print("User Deleted")).catchError((error) =>
        // ignore: avoid_print
        print("Failed to delete user: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: studentsStrem,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapShot) {
          if (snapShot.hasError) {
            // ignore: avoid_print
            print("Something went worng");
          }
          if (snapShot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final List stroedoc = [];
          snapShot.data!.docs.map((DocumentSnapshot document) {
            Map data = document.data() as Map<String, dynamic>;
            data['id'] = document.id;
            stroedoc.add(data);
          }).toList();

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Table(
                border: TableBorder.all(),
                columnWidths: const <int, TableColumnWidth>{
                  1: FixedColumnWidth(140),
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(children: [
                    TableCell(
                        child: Container(
                      color: Colors.greenAccent,
                      child: const Center(
                        child: Text(
                          "Name",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )),
                    TableCell(
                        child: Container(
                      color: Colors.greenAccent,
                      child: const Center(
                        child: Text(
                          "Email",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )),
                    TableCell(
                        child: Container(
                      color: Colors.greenAccent,
                      child: const Center(
                        child: Text(
                          "Action",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ))
                  ]),
                  for (int i = 0; i < stroedoc.length; i++) ...[
                    TableRow(children: [
                      TableCell(
                          child: Text(
                        stroedoc[i]['name'],
                        style: TextStyle(fontSize: 18.0),
                      )),
                      TableCell(
                          child: Text(
                        stroedoc[i]['email'],
                        style: TextStyle(fontSize: 18.0),
                      )),
                      TableCell(
                          child: Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => UpdateStudentPage(
                                            id: stroedoc[i]['id'])));
                              },
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.orange,
                              )),
                          IconButton(
                              onPressed: () {
                                deleteUser(stroedoc[i]['id']);
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.orange,
                              ))
                        ],
                      ))
                    ]),
                  ]
                ],
              ),
            ),
          );
        });
  }
}
