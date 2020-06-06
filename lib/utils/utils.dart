import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Utils {

  Map<String, dynamic> user = {
    'nome': 'Bruno',
    'photo': 'https://firebasestorage.googleapis.com/v0/b/chatsaojoao.appspot.com/o/a.png?alt=media&token=b9489efb-bc27-4d2a-915f-a941e1bc56e4',
  };

  void sendMessage(int tamanho, {String text, String imgUrl,}){
    Firestore.instance.collection("messages").document(tamanho.toString()).setData({
        "text" : text,
        "imgUrl" : imgUrl,
        "senderName" : user['nome'],
        "senderPhotoUrl" : user['photo']
    });
  }

  void handleSubmitted(int tamanho, String text,) async {
    sendMessage(tamanho, text: text);
  }

  double getHeigthScreen(BuildContext context){
    double heigthScreen = MediaQuery.of(context).size.height - 
    MediaQuery.of(context).padding.top;
    return heigthScreen;
  }

  double getHeigthScreenWithAppBar(BuildContext context, double appBar){
    double heigthScreen = MediaQuery.of(context).size.height - 
    MediaQuery.of(context).padding.top - appBar;
    return heigthScreen;
  }

  double getWidthScreen(BuildContext context){
    double widthScreen = MediaQuery.of(context).size.width;
    return widthScreen;
  }

}