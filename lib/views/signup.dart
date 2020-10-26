import 'package:chat_doc_doc/helper/helperfunctions.dart';
import 'package:chat_doc_doc/services/auth.dart';
import 'package:chat_doc_doc/services/database.dart';
import 'package:chat_doc_doc/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:chat_doc_doc/views/chatRoomScreen.dart';

class SignUp extends StatefulWidget {
  final Function toggle;
  SignUp(this.toggle);
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLoading = false;
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  //HelperFunctions helperFunctions = new HelperFunctions();

  final formKey = GlobalKey<FormState>();
  TextEditingController userNameTextEditingController = new TextEditingController();
  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();

  signMeUp() {
    if (formKey.currentState.validate()) {
      HelperFunctions.saveUserNameSharedPreference(userNameTextEditingController.text);
      HelperFunctions.saveUserEmailSharedPreference(emailTextEditingController.text);
      setState(() {
        isLoading = true;
      });

      authMethods
          .signUpWithEmailAndPassword(emailTextEditingController.text,
              passwordTextEditingController.text)
          .then((val) {
        print("{$val.uid}");
        Map<String, String> userInfoMap = {
          "name" : userNameTextEditingController.text,
          "email" : emailTextEditingController.text
        };
        databaseMethods.uploadUserInfo(userInfoMap);
        HelperFunctions.saveUserLoggedInSharedPreference(true);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ChatRoom()
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading
          ? Container(child: Center(child: CircularProgressIndicator()))
          : SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Column(children: [
                Form(
                  key: formKey,
                  child: Column(children: [
                    SizedBox(height: 50),
                    TextFormField(
                        validator: (val) {
                          return val.isEmpty || val.length < 2
                              ? "The username must be longer than 3 characters"
                              : null;
                        },
                        controller: userNameTextEditingController,
                        style: simpleTextFieldStyle(),
                        decoration: textFieldInputDecoration("Usuario")),
                    TextFormField(
                        validator: (val) {
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
                  ]),
                ),
                SizedBox(height: 50),
                GestureDetector(
                  onTap: () {
                    signMeUp();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text("Registrarse",
                        style: TextStyle(color: Colors.white, fontSize: 24)),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: LinearGradient(colors: [
                          const Color(0xff007EF4),
                          const Color(0xff2A75BC)
                        ])),
                  ),
                ),

                SizedBox(height: 20),

                GestureDetector(
                  child: GestureDetector(
                    onTap: (){
                      widget.toggle();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Text("+ Iniciar Sesion", style: simpleTextFieldStyle()),
                    ),
                  ),
                ),

              ])),
    );
  }
}
