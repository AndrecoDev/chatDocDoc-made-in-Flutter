import 'package:chat_doc_doc/helper/contants.dart';
import 'package:chat_doc_doc/helper/helperfunctions.dart';
import 'package:chat_doc_doc/services/database.dart';
import 'package:chat_doc_doc/views/conversation_screen.dart';
import 'package:chat_doc_doc/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}
String _myName;

class _SearchScreenState extends State<SearchScreen> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchTextEditingController = new TextEditingController();
  QuerySnapshot searchSnapshot;

  Widget searchList(){
    return  searchSnapshot != null ? ListView.builder(
        itemCount: searchSnapshot.documents.length,
        shrinkWrap: true,
        itemBuilder: (context, index){
          return SearchTile(
            userName: searchSnapshot.documents[index].data["name"],
            userEmail: searchSnapshot.documents[index].data["email"],
          );
        }) : Container();
  }

  initiateSearch() {
    databaseMethods.getUserByUsername(searchTextEditingController.text)
        .then((val) {
    setState(() {
      searchSnapshot = val;
    });
        });
  }

  createChatroomAndStartConversation({String userName}){
    if(userName != Constants.myName){
      String chatRoomId = getChatRoomId(userName,Constants.myName);
      List<String> users = [userName, Constants.myName];
      Map<String, dynamic> charRoomMap = {
        "users": users,
        "chatroomId" : chatRoomId,
      };
      DatabaseMethods().createChatRoom(chatRoomId, charRoomMap);
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => ConversationScreen(chatRoomId)
      ));
    }else{
      print("No tienes mensajes");
    }
  }
Widget SearchTile({String userName,String userEmail}){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(userName, style: simpleTextFieldStyle(),),
              Text(userEmail, style: simpleTextFieldStyle(),)
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: (){
              createChatroomAndStartConversation(
                userName: userName
              );
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(30)
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text("Chatear"),
            ),
          )
        ],
      ),
    );
}

  @override
  void initState() {
    //|getUserInfo();
    super.initState();
  }

  //getUserInfo() async {
  //  _myName = await HelperFunctions.getUserNameSharedPreference();
// setState(() {
//
//   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Column(
          children: [
            Container(color: Color(0x54FFFFFF),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Expanded(child: TextField(
                      controller: searchTextEditingController,
                      decoration: InputDecoration(hintText: "Buscar persona",
                      hintStyle: TextStyle(
                      color: Colors.white,
                      ))
                  )),
                  GestureDetector(
                    onTap: (){
                    initiateSearch();
                    },
                    child: Container(
                      height: 20,
                      width: 60,
                      child: Text("Buscar",
                      style: TextStyle(color: Colors.white, fontSize: 14),),
                    ),
                  )
                ],
              ),
            ),
            searchList(),
          ],
        ),
      ),
    );
  }
}


getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}