import 'package:chat_doc_doc/helper/authenticate.dart';
import 'package:chat_doc_doc/helper/helperfunctions.dart';
import 'package:chat_doc_doc/views/chatRoomScreen.dart';
import 'package:chat_doc_doc/views/signup.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool userIsLoggedIn = false;

  @override
  void initState(){
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async {
    await HelperFunctions.getUserLoggedInSharedPreference().then((value){
      setState(() {
        userIsLoggedIn;
        print("${userIsLoggedIn} LOGINNN");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat doc doc',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Color(0xff145C9E),
          scaffoldBackgroundColor: Color(0xff1F1F1F),
          // primaryColor: Colors.blue[900],
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity),
      home: userIsLoggedIn ? ChatRoom() : Authenticate()
    );
  }
}
