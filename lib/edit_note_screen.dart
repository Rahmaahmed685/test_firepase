import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test_firepase/note.dart';
class EditNoteScreen extends StatefulWidget {
  const EditNoteScreen({super.key, required this.note});

  final Note note;

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;

  final formKey = GlobalKey<FormState>();
  bool uploading = false;
  String imageUrl ='';

  @override
  void initState() {
    super.initState();
    titleController.text = widget.note.title;
    contentController.text = widget.note.content;
    imageUrl=widget.note.image;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Note"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: () => pickImage(),
                    child: Container(
                      height: 150,
                      width: double.infinity,
                      child: Image.network(imageUrl),
                    ),
                  ),
                  Visibility(
                    visible: uploading,
                    child: const CircularProgressIndicator(),
                  ),
                ],
              ),
              const SizedBox(height: 10),
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
                  onPressed: () => updateNote(),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue,
                  ),
                  child: const Text("Update"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void updateNote() {
    if (!formKey.currentState!.validate()) {
      return;
    }

    String title = titleController.text;
    String content = contentController.text;
    String image = imageUrl;

    widget.note.title = title;
    widget.note.content = content;
    widget.note.image = image;

    firestore.collection("name")
        .doc(widget.note.id)
        .update(widget.note.toMap());

    Navigator.pop(context, widget.note);
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