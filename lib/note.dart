import 'package:firebase_auth/firebase_auth.dart';

class Note {
  String _id='';
  String userId='' ;
  String _title='';
  String _content='';
  String image = '';


  Note(this._id,this._title, this._content,this.image);

  Note.fromMap(Map<String, dynamic> data){
    id = data['id'];
    userId = data['userId'];
    title = data['title'];
    content = data['content'];
    image = data['image'];

  }

  String get content => _content;

  set content(String value) {
    _content = value;
  }

  String get title => _title;

  set title(String value) {
    _title = value;
  }


  String get id => _id;

  set id(String value) {
    _id = value;
  }


  Map<String , dynamic> toMap (){
    return {
      'id' : id,
      'userId' : FirebaseAuth.instance.currentUser?.uid,
      'title': title,
      'content' : content,
      'image' : image,
    };
 }

}