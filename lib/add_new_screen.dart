
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test_firepase/note.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  String imageUrl = '';
  bool uploading = false;

  final formKey = GlobalKey<FormState>();

  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Note"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: formKey,
          child: Column(
            children: [

              SizedBox(height: 10,),
              if (imageUrl.isEmpty)
                InkWell(
                  borderRadius: BorderRadius.circular(50),
                  onTap: () => pickImage(),
                  child:
                  Container(
                    color: Colors.blue,
                    height: 150,
                    width: double.infinity,
                    child: Icon(
                      Icons.photo_library_outlined,
                      size: 45,
                      color: Colors.white,
                    ),
                  ),
                )
              else
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(50),
                        onTap: () => pickImage(),
                        child: Image.network(
                          imageUrl,
                          height: 150,
                          width: double.infinity,
                        ),
                      ),
                    ),
                    Visibility(
                      visible: uploading,
                      child: const CircularProgressIndicator(),
                    ),
                  ],
                ),
              const SizedBox(height: 20),
              TextFormField(
                controller: titleController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text("Title"),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Title required";
                  }
                  if (value.length < 5) {
                    return "Title is very small!";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: contentController,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text("Content"),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Content required";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () => addNote(),
                  child: const Text("Add"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void addNote() {
    if (!formKey.currentState!.validate()) {
      return;
    }

    String title = titleController.text;

    String content = contentController.text;

    String id = DateTime.now().millisecondsSinceEpoch.toString();

    String image = imageUrl;

    final note = Note(id, title, content,image);

    firestore.collection("name").doc(id).set(note.toMap()).then((value) {
      Navigator.pop(context);
    }).catchError((error) {

    });
  }

  void pickImage() async {
    final ImagePicker picker = ImagePicker();
    // Pick an image.
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);

    File image = File(file!.path);

    uploadImage(image);
  }

  void uploadImage(File image) {
    setState(() {
      uploading = true;
    });
    final userId = auth.currentUser!.uid;

    storage.ref("profileImages/$userId").putFile(image).then((value) {
      print('uploadImage => SUCCESS');
      getImageUrl();
    }).catchError((error) {
      setState(() {
        uploading = false;
      });
      print('uploadImage => $error');
    });
  }

  void getImageUrl() {
    final userId = auth.currentUser!.uid;

    storage.ref("profileImages/$userId").getDownloadURL().then((value) {
      print('getImageUrl => $value');
      setState(() {
        imageUrl = value;
        uploading = false;
      });
      saveImageUrl(imageUrl);
    }).catchError((error) {
      print('getImageUrl => $error');
    });
  }

  void saveImageUrl(String imageUrl) {
    final userId = auth.currentUser!.uid;

    firestore.collection("name").doc(userId).update({
      'imageUrl': imageUrl,
    });
  }
}