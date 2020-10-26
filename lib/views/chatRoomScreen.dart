import 'package:chat_doc_doc/helper/authenticate.dart';
import 'package:chat_doc_doc/helper/contants.dart';
import 'package:chat_doc_doc/helper/helperfunctions.dart';
import 'package:chat_doc_doc/services/auth.dart';
import 'package:chat_doc_doc/views/search.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  AuthMethods authMethods = new AuthMethods();

  @override
  void initState() {
    // TODO: implement initState
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Doc doc Chats"),
        actions: [
          GestureDetector(
            onTap: (){
              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) => Authenticate()
              ));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Text("Buscar"),
        onPressed: (){
Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen()
          ));
        },
      ),
    );
  }
}
