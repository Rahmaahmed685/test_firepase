
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:test_firepase/add_new_screen.dart';
import 'package:test_firepase/edit_note_screen.dart';
import 'package:test_firepase/login.dart';
import 'package:test_firepase/note.dart';
import 'package:test_firepase/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // List<String> notes = ["1", "2"];

  List<Note> myNote = [
    //Note('1',"title1", "content"),
  ];

  final firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    getNotes();
  }
  void getNotes(){
    firestore.collection("name")
        .get()
        .then((value) {
      myNote.clear();
      for(var doc in value.docs) {
        // print('Document= ${doc.data()}');
        final note = Note.fromMap(doc.data());
        myNote.add(note);
        setState(() {
        });
      }

    }).catchError((error){

    });
  }
  bool isChecked = false;

  final auth = FirebaseAuth.instance;
  final storage = FirebaseStorage.instance;

  String imageUrl = '';
  bool uploading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text("Your Notes", style: TextStyle(fontSize: 33,
              color: Colors.blue, fontWeight: FontWeight.w900),),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(),

                  ),
                );
              },
              icon: const Icon(Icons.person,color: Colors.blue,),
            ),
            IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.logout,color: Colors.blue,),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          onPressed: () =>
              openAddNewNote(),

          child: Icon(Icons.add),

        ),
        body: ListView.builder(
            itemCount: myNote.length,
            itemBuilder: (context, index) {
              return buildItem(index);
            }
        )

    );
  }

  Widget buildItem(int index) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.cyanAccent,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          myNote[index].image.isEmpty ?
          SizedBox() :
          Image.network(
            myNote[index].image,
            width:double.infinity,
            height: 150,
            fit: BoxFit.fill,),

          Padding(
            padding: const EdgeInsets.all(8),
            child:
            Text(
              myNote[index].title
              , style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 20),),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child:
            Text(
              myNote[index].content
              , style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 20),),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: StadiumBorder(),
                    ),
                    onPressed: () {
                      firestore.collection("name")
                          .doc(myNote[index].id)
                          .delete()
                          .then((value) {
                            myNote.removeAt(index);
                            setState(() {
                            });
                      })
                          .catchError((error){});

                      setState(() {

                      });
                    },
                    icon: Icon(Icons.delete),
                    label: Text("Delete")),
              ),
              SizedBox(width: 10,),
              Expanded(
                child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: StadiumBorder(),
                    ),
                    onPressed: () {
                      editNote(index);
                    },
                    icon: Icon(Icons.edit),
                    label: Text("Edit")),
              ),
            ],)

        ],),
    );
  }

  void openAddNewNote() {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => AddNoteScreen(),
    )
    ).then((value) => getNotes());
  }

  addNote(Note value) {
    myNote.add(value);
    setState(() {});
  }

  void editNote(int index) {
   // final note = Note.fromMap(doc.data());
    Navigator.push(context, MaterialPageRoute(
      builder: (context) =>
          EditNoteScreen(note: myNote[index],),
    ),

    ).then((value)
    => ubdateCurrentNote(index,value),);
  }

  void ubdateCurrentNote(int index, value) {
    myNote[index] = value;
    setState(() {

    });

  }

}