import 'package:chat_doc_doc/helper/helperfunctions.dart';
import 'package:chat_doc_doc/services/auth.dart';
import 'package:chat_doc_doc/services/database.dart';
import 'package:chat_doc_doc/views/chatRoomScreen.dart';
import 'package:chat_doc_doc/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  final Function toggle;
  SignIn(this.toggle);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final formKey = GlobalKey<FormState>();
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();
  bool isLoading = false;
  QuerySnapshot snapshotUserInfo;

  signIn(){
    if(formKey.currentState.validate()){
      HelperFunctions.saveUserEmailSharedPreference(emailTextEditingController.text);
      databaseMethods.getUserByEmail(emailTextEditingController.text).then((val){
        snapshotUserInfo = val;
        HelperFunctions.saveUserNameSharedPreference(snapshotUserInfo.documents[0].data["name"]);
        print("${snapshotUserInfo.documents[0].data["name"]} this is so bad");
      });

      setState(() {
        isLoading = true;
      });

      authMethods.signInWithEmailAndPassword(emailTextEditingController.text, passwordTextEditingController.text).then((val){
        if (val != null){
          HelperFunctions.saveUserLoggedInSharedPreference(true);
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => ChatRoom()
          ));
        }
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: formKey,
            child: Column(children: [
              TextFormField(validator: (val) {
                return RegExp(
                    r"^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$")
                    .hasMatch(val)
                    ? null
                    : "Please provide a valid email address";
              },
                  controller: emailTextEditingController,
                  style: simpleTextFieldStyle(),
                  decoration: textFieldInputDecoration("Correo")),
              TextFormField(
                obscureText: true,
                validator: (val) {
                  return val.length > 6
                      ? null
                      : "The password must be longer than 6 characters";
                },
                controller: passwordTextEditingController,
                style: simpleTextFieldStyle(),
                decoration: textFieldInputDecoration("Contraseña"),
              ),

              SizedBox(height: 50),
              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: LinearGradient(colors: [
                  const Color(0xff007EF4),
                  const Color(0xff2A75BC)
                ])),
                child: GestureDetector(
                  onTap: (){
                  signIn();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text("Acceder",
                        style: TextStyle(color: Colors.white, fontSize: 24,)),
                  ),
                ),
              ),
              SizedBox(height: 8),
              GestureDetector(
                onTap: (){
                  widget.toggle();
                },
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text("+ Registrarse", style: simpleTextFieldStyle()),
                ),
              ),


            ]),
          )),
    );
  }
}
