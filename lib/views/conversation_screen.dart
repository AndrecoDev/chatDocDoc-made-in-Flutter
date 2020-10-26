import 'package:chat_doc_doc/helper/contants.dart';
import 'package:chat_doc_doc/services/database.dart';
import 'package:chat_doc_doc/widgets/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConversationScreen extends StatefulWidget {
  final String chatRoomId;
  ConversationScreen(this.chatRoomId);

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController messageController = new TextEditingController();
  Stream chatMessagesStream;

  Widget ChatMessageList(){
    return StreamBuilder(
        stream: chatMessagesStream,
        builder: (context, snapshot){
          return snapshot.hasData ? ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index){
                return MessageTile(snapshot.data.documents[index].data["message"],
                snapshot.data.documents[index].data["sendBy"] == Constants.myName);
              }) : Container();
        },
    );
  }
  sendMessage(){
    if (messageController.text.isNotEmpty){
      Map<String,dynamic> messageMap = {
        "message" : messageController.text,
        "sendBy" : Constants.myName,
        "time" : DateTime.now().microsecondsSinceEpoch
      };
      databaseMethods.addConversationMessages(widget.chatRoomId, messageMap);
      messageController.text = "";
    }

  }
  @override
  void initState() {
    databaseMethods.getConversationMessages(widget.chatRoomId).then((value){
      setState(() {
        chatMessagesStream = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Stack(
          children: [
            ChatMessageList(),
                Container(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    color: Color(0x54FFFFFF),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: Row(
                      children: [
                        Expanded(child: TextField(
                            controller: messageController,
                            decoration: InputDecoration(hintText: "Mensaje...",
                                hintStyle: TextStyle(
                                  color: Colors.white,
                                ))
                        )),
                        GestureDetector(
                          onTap: (){
                            sendMessage();
                          },
                          child: Container(
                            height: 20,
                            width: 60,
                            child: Text("Enviar",
                              style: TextStyle(color: Colors.white, fontSize: 14),),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
  ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;
  MessageTile(this.message, this.isSendByMe);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isSendByMe ? [const Color(0xff007EF4), const Color(0xff2A75BC)]
                : [const Color(0xff997AF4), const Color(0xff997AF4)],
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(message, style: TextStyle(
          color: Colors.white,
          fontSize: 17
        ),),
      ),
    );
  }
}
