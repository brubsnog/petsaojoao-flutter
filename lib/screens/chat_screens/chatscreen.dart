import 'dart:io';

import 'package:petsaojoao-flutter/models/utils_chat/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

void main() async {
  runApp(MyApp());
}

final ThemeData kIOSTheme = ThemeData(
  primarySwatch: Colors.blue,
  primaryColor: Colors.blueAccent[200],
  primaryColorBrightness: Brightness.light,
);

final ThemeData kDefaultTheme = ThemeData(
  primarySwatch: Colors.blue,
  accentColor: Colors.blueAccent[400],
);

final auth = FirebaseAuth.instance;

Color color = Colors.blue;

_handleSubmitted(String text) async {
  _sendMessage(text: text);
}

void _sendMessage({String text, String imgUrl}){
  Firestore.instance.collection("messages").add(
    {
      "text" : text,
      "imgUrl" : imgUrl,
      "senderName" : 'Bruno',
      "senderPhotoUrl" : 'https://cdn.pixabay.com/photo/2020/05/06/19/30/girl-5138908__340.jpg',
      "senderDate": new DateTime.now().toIso8601String()
    }
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Chat App",
      debugShowCheckedModeBanner: false,
      theme: Theme.of(context).platform == TargetPlatform.iOS
          ? kIOSTheme
          : kDefaultTheme,
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> { //essa primeira classe é responsável por exibir as outras duas

  

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text("São João Chat"),
          backgroundColor: color,
          centerTitle: true,
          elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.color_lens),
              onPressed: (){
                if(color == Colors.red){
                  setState(() {
                    color = Colors.blue;
                  });
                }
                else{
                  setState(() {
                    color = Colors.red;
                  });
                }
              },
            )
          ],
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: StreamBuilder(
                  stream: Firestore.instance.collection("messages").orderBy('senderDate').snapshots(),
                  builder: (context, snapshot) {
                    switch(snapshot.connectionState){
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      default:
                        return ListView.builder(
                            reverse: true,
                            itemCount: snapshot.data.documents.length,
                            itemBuilder: (context, index) {
                              List r = snapshot.data.documents.reversed.toList();
                              return ChatMessage(r[index].data); // essa classe é responsável pela verificação de dados e exibe em forma de lista
                            }
                        );
                    }
                  }
              ),
            ),
            Divider(
              height: 1.0,
            ),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
              ),
              child: TextComposer(),
            )
          ],
        ),
      ),
    );
  }
}

class TextComposer extends StatefulWidget { // essa classe é responsável por enviar as mensagens
  @override
  _TextComposerState createState() => _TextComposerState();
}

class _TextComposerState extends State<TextComposer> {

  Utils utils = Utils();

  final _textController = TextEditingController();
  bool _isComposing = false;

  void _reset(){
    _textController.clear();
    setState(() {
      _isComposing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: Theme.of(context).platform == TargetPlatform.iOS
            ? BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey[200])))
            : null,
        child: Row(
          children: <Widget>[
            Container(
              child: IconButton(icon: Icon(Icons.photo_camera, color: color,),
              onPressed: () async {
                File imgFile = await ImagePicker.pickImage(source: ImageSource.gallery);
                if(imgFile == null) return;
                StorageUploadTask task = FirebaseStorage.instance.ref().
                  child(utils.user['nome'] +
                    DateTime.now().millisecondsSinceEpoch.toString()).putFile(imgFile);
                StorageTaskSnapshot snap = await task.onComplete;
                _sendMessage(imgUrl: await snap.ref.getDownloadURL());
              }),
            ),
            Expanded(
              child: TextField(
                controller: _textController,
                decoration:
                    InputDecoration.collapsed(hintText: "Enviar uma Mensagem"),
                onChanged: (text) {
                  setState(() {
                    _isComposing = text.length > 0;
                  });
                },
                onSubmitted: (text){
                  _handleSubmitted(text);
                  _reset();
                },
              ),
            ),
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Theme.of(context).platform == TargetPlatform.iOS
                    ? CupertinoButton(
                        child: Text("Enviar"),
                        onPressed: _isComposing ? () {
                          _handleSubmitted(_textController.text);
                          _reset();
                        } : null,
                      )
                    : IconButton(
                        icon: Icon(Icons.send, color: color ),
                        onPressed: _isComposing ? () {
                          _handleSubmitted(_textController.text);
                          _reset();
                        } : null,
                      ))
          ],
        ),
      ),
    );
  }
}

class ChatMessage extends StatelessWidget { // essa classe é responsável por exibir as mensagens

  final Map<String, dynamic> data;

  ChatMessage(this.data);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage(data["senderPhotoUrl"]),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  data["senderName"],
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: data["imgUrl"] != null ?
                    Image.network(data["imgUrl"], width: 250.0,) :
                      Text(data["text"])
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

