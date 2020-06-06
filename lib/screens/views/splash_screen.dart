import 'package:chatsaojoao/utils/utils.dart';
import 'package:chatsaojoao/views/chatscreen.dart';
import 'package:flutter/material.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  Utils utils = Utils();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: utils.getHeigthScreen(context),
          width: utils.getWidthScreen(context),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.blue,
                Colors.white
              ]
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Icon(Icons.message, color: Colors.white,),
              ),
              SizedBox(height: 25,),
              Text(
                'Chat são João',
                style: TextStyle(
                  color: Colors.white
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(
      seconds: 4
    )
    ).then((value) =>
      Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => ChatScreen()),
      (route) => false)
    );
  }

}