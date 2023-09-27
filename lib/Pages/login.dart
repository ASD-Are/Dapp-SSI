import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:master/Pages/homepage.dart';
import 'package:master/Pages/signup.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:master/Models/secure_storage.dart';


class Login2 extends StatefulWidget {
  @override
  _Login2 createState() => _Login2();
}

class _Login2 extends State<Login2> {

  final TextEditingController pswdController = TextEditingController();
  late SharedPreferences sharedPreferences;
  String LoginStatus = "Not Logged In";

  Future<void> authenticateUser(String inputPassword) async {
    // Get the stored password from Flutter Secure Storage
    String? storedPassword = await storage.read(key: 'password');

    if (storedPassword == null) {
      // Show a dialog if the password has not been set yet
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(child: Text("❌")),
            content: Text("You haven't created a wallet yet!"),
            actions: [
              ElevatedButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else if (inputPassword.isEmpty) {
      // Show a dialog if the input password is empty
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(child: Text("⛔")),
            content: Text("Please input your password!"),
            actions: [
              ElevatedButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Login2()),
                  );
                },
              ),
            ],
          );
        },
      );
    } else if (inputPassword == storedPassword) {
      // Show a dialog if the passwords match
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Homepage()));
    } else {
      // Show a dialog if the passwords do not match
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: Center(
              child: AlertDialog(
                title: Center(child: Text("👀")),
                content: const Text("Incorrect Password"),
                actions: [
                  ElevatedButton(
                    child: Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  Widget buildPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Text(
        //   'Password',
        //   style: TextStyle(
        //       color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        // ),
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: Colors.black, width: 1),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Colors.transparent, blurRadius: 3, offset: Offset(0, 2))
              ]),
          height: 60,
          child: TextField(
            controller: pswdController,
            obscureText: true,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14),
                prefixIcon: Icon(Icons.lock, color: Colors.grey),
                hintText: 'Password',
                hintStyle: TextStyle(color: Colors.grey)),
          ),
        )
      ],
    );
  }

  Widget buildLoginBtn() {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 25),
        width: 120,
        child: ElevatedButton(
          style: ButtonStyle(
              shadowColor: MaterialStateProperty.all(Colors.cyanAccent),
              elevation: MaterialStateProperty.all(10.0),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.black)
          ),
          onPressed: () {
            authenticateUser(pswdController.text);
          }, child: Text("LOGIN", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),

        ));
  }

  Widget buildSignupBtn() {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        width: double.tryParse("Sign up with Email"),
        height: 60,
        child: ElevatedButton.icon(
          icon: Icon(Icons.wallet),
          // icon: FaIcon(FontAwesomeIcons., color: Colors.red,),
          style: ButtonStyle(
              shadowColor: MaterialStateProperty.all(Colors.lightGreenAccent),
              elevation: MaterialStateProperty.all(5.0),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.cyan)
          ),
          onPressed: () {
            print("Pressed!");
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignUp()),
            );
          }, label: Text("Creat New Wallet", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),

        ));
  }

  Widget buildForgetPswd(){
    return  InkWell(
        onTap: () {
          // TODO: Implement forgot password functionality
          // This function will be called when the user taps on the "Forgot Password?" text
          print('Forgot Password tapped!');
        },
        child: Align(
          alignment: Alignment.bottomCenter,
          child: RichText(
            text: TextSpan(
                children: [
                TextSpan(
                text: 'Forgot Password?',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,)
            ),
            TextSpan(
            text: ' RESET',
            style: TextStyle(
            color: Colors.red,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline)

        )]
    ),),
      )
    );

    }

  @override
  void dispose() {
    super.dispose();
    pswdController.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: Container(
          width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
          image: DecorationImage(
          image: AssetImage("assets/bg.png"), fit: BoxFit.cover),
    ),

      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          height: double.infinity,
          child: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      SizedBox(height:200.0),
                      Center(
                        child:Image(image: AssetImage("assets/logo_black.png"), fit: BoxFit.cover)
                      ),
                      // SizedBox(height:25.0),
                      Align(
                        alignment: Alignment.centerLeft,
                        child:
                        Text('Hey There,\nWelcome Back',
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),),
                      ),
                      SizedBox(height: 5.0),

                      buildPassword(),

                      buildLoginBtn(),

                      SizedBox(height: 0),


                      buildSignupBtn(),

                      SizedBox(height: 30,),

                      buildForgetPswd()
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      )
    )
    )
    );
  }

}