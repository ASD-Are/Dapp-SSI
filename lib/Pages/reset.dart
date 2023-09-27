import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:master/Pages/homepage.dart';
import 'package:master/Pages/signup.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:master/Models/secure_storage.dart';


class Reset extends StatefulWidget {
  @override
  _Reset createState() => _Reset();
}

class _Reset extends State<Reset> {

  final TextEditingController pswdController = TextEditingController();
  late SharedPreferences sharedPreferences;
  String LoginStatus = "Not Logged In";


  Widget buildPhrase() {
    return Visibility(
      child: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          width: 120,
          height: 70,
          child: ElevatedButton(
            style: ButtonStyle(
                shadowColor: MaterialStateProperty.all(Colors.cyanAccent),
                elevation: MaterialStateProperty.all(10.0),
                backgroundColor: MaterialStateProperty.all<Color>(Colors.black)
            ),
            onPressed: () {
            },
            child: Text("KeyPhrase", style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),),

          )),
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
          }, child: Text("LOGIN", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),

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


                                buildLoginBtn(),

                                SizedBox(height: 0),




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