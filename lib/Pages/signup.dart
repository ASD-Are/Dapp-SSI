import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:master/Pages/login.dart';
import 'package:master/Pages/keys.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:master/Models/secure_storage.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUp createState() => _SignUp();
}

class _SignUp extends State<SignUp> {
  DateTime? _lastPressedAt;
  late SharedPreferences sharedPreferences;
  final TextEditingController passController = TextEditingController();
  final TextEditingController passControllerrepeat = TextEditingController();
  final TextEditingController WalletName = TextEditingController();
  final TextEditingController SecurityPhrase = TextEditingController();


  Future<void> storeWalletDetails2(String walletName, String seedPhrase, String password, String repeatPassword) async {
    // Get the application documents directory
    Directory directory = await getApplicationDocumentsDirectory();

    // Create a file with the name "wallet_details.txt" in the documents directory
    File file = File("${directory.path}/wallet_details.txt");

    if (await file.exists()) {
      // Show a dialog if the file already exists
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Wallet Details"),
            content: Text("Wallet details already exist, no need to create a new wallet."),
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
    } else {
      // Write the wallet name, seed phrase, and password to the file as a string
      // await file.writeAsString("Wallet Name: $walletName\nSeed Phrase: $seedPhrase\nPassword: $password");
      await file.writeAsString("Wallet Name: $walletName\nPassword: $password");
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(child: Text("New Wallet Created ✔")),
            content: Text("Wallet Details Saved Successfuly. Press 'OK' to Login"),
            actions: [
              ElevatedButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Keys()),
                  );

                },
              ),
            ],
          );
        },
      );
    }
  }
  Future<void> storeWalletDetails(String walletName, String seedPhrase, String password, String repeatPassword) async {
    String? privateKey = await storage.read(key: 'private_key');

    if (privateKey != null && privateKey.isNotEmpty) {
      // Show a dialog if the private key already exists
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Wallet Details"),
            content: Text("Wallet details already exist, no need to create a new wallet."),
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
    }
    else {
      // Write the wallet name, seed phrase, and password to the secure storage
      await storage.write(key: 'wallet_name', value: walletName);
      await storage.write(key: 'seed_phrase', value: seedPhrase);
      await storage.write(key: 'password', value: password);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(child: Text("New Wallet Created ✔")),
            content: Text("Wallet Details Saved Successfully. Press 'OK' to Login"),
            actions: [
              ElevatedButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Keys()),
                  );
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> validateinput(String walletName, String seedPhrase, String password, String repeatPassword) async {

    // if (walletName.isNotEmpty && seedPhrase.isNotEmpty && password.isNotEmpty && repeatPassword.isNotEmpty) {
      if (walletName.isNotEmpty && password.isNotEmpty && repeatPassword.isNotEmpty) {
      if (password == repeatPassword) {
        bool isPasswordStrong = checkPasswordStrong(password);
        print(isPasswordStrong);
        if (isPasswordStrong) {
          storeWalletDetails(walletName, seedPhrase, password, repeatPassword);
        }
        else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Error"),
                content: Text("Password is not strong enough"),
                actions: [
                  ElevatedButton(
                    child: Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUp()),
                      );
                    },
                  ),
                ],
              );
            },
          );
        }
      }
      else {
// Show a dialog if the passwords do not match
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text("Passwords do not match"),
              actions: [
                ElevatedButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUp()),
                    );
                  },
                ),
              ],
            );
          },
        );
      }
    }
    else{
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(child: Text("⛔")),
            content: Text("Please fill all input fields!"),
            actions: [
              ElevatedButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUp()),
                  );
                },
              ),
            ],
          );
        },
      );
    }
  }

  bool checkPasswordStrong(String password) {

    bool hasLowercase(String password) {
      return RegExp(r'[a-z]').hasMatch(password);}
    bool hasUppercase(String password) {
      return RegExp(r'[A-Z]').hasMatch(password);}

    bool hasNumbers(String password) {
      return RegExp(r'[0-9]').hasMatch(password);}

    bool hasSpecialChars(String password) {
      return RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(password);}
    return password.length >= 8 &&
        hasLowercase(password) &&
        hasUppercase(password) &&
        hasNumbers(password) &&
        hasSpecialChars(password);
  }

  Widget buildWalletName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
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
            controller: WalletName,
            keyboardType: TextInputType.text,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14),
                prefixIcon:
                Icon(Icons.account_box, color: Colors.grey),
                hintText: 'Wallet Name',
                hintStyle: TextStyle(color: Colors.grey)),
          ),
        )
      ],
    );
  }
  Widget buildPhrase() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
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
            controller: SecurityPhrase,
            keyboardType: TextInputType.text,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14),
                prefixIcon:
                Icon(Icons.account_circle, color: Colors.grey),
                hintText: 'Security Phrase',
                hintStyle: TextStyle(color: Colors.grey)),
          ),
        )
      ],
    );
  }
  Widget buildPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
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
            controller: passController,
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
  Widget buildPasswordRepeat() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 1),
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Colors.transparent, blurRadius: 3, offset: Offset(0, 2))
              ]),
          height: 60,
          child: TextField(
            controller: passControllerrepeat,
            obscureText: true,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14),
                prefixIcon: Icon(Icons.lock, color: Colors.grey),
                hintText: 'Repeat Password',
                hintStyle: TextStyle(color: Colors.grey)),
          ),
        )
      ],
    );
  }
  Widget buildSignupBtn() {
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
            validateinput(WalletName.text, SecurityPhrase.text,passController.text, passControllerrepeat.text);

          }, child: Text("SIGN UP", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),

        ));
  }
  @override
  void dispose() {
    super.dispose();
    WalletName.dispose();
    passController.dispose();
    passControllerrepeat.dispose();
    SecurityPhrase.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: WillPopScope(
              onWillPop: () async {
                final now = DateTime.now();
                if (_lastPressedAt == null || now.difference(_lastPressedAt!) > Duration(seconds: 2)) {
                  _lastPressedAt = now;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Press back again to exit")),

                  );
                  return false;
                }
                return true;
              },
              child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/bg.png"), fit: BoxFit.cover),
                  ),

                  child: SingleChildScrollView(
                    child: Center(
                      child: Container(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Spacer(),
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
                                buildWalletName(),
                                // buildPhrase(),
                                buildPassword(),
                                buildPasswordRepeat(),
                                SizedBox(height: 10),


                                buildSignupBtn(),



                              ],
                            ),
                          )


                      ),
                    ),
                  )
              ),
            )
        )
    );
  }

}



