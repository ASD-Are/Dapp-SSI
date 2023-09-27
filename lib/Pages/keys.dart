import 'dart:io';
import 'package:flutter/material.dart';
import 'package:master/Pages/signcontract.dart';
import 'package:path_provider/path_provider.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:bip32/bip32.dart' as bip32;
import 'package:flutter/cupertino.dart';
import 'package:web3dart/credentials.dart';
import '../Models/secure_storage.dart';
import 'attestation.dart';
import 'homepage.dart';
import 'help.dart';


class Keys extends StatefulWidget {
  @override
  _Keys  createState() => _Keys ();
}

class _Keys  extends State<Keys> {
  int _currentIndex = 0;
  bool isVisible = true;



  Future<void> retrievePrivateKeys() async {
    // Get the private key from Flutter Secure Storage
    String? privateKey = await storage.read(key: "private_key");

    if (privateKey != null) {
      // Display the decoded private key in a pop-up page
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Elliptic Curve Keys"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  SelectableText("Private Key: 0x$privateKey"),
                ],
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                child: Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      // Show an error message if the private key doesn't exist in the storage
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("❌"),
            content: Text("You haven't created key pairs yet"),
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
  }

  Future<void> retrievePublicKeys() async {
    // Read the public key from the secure storage
    String? publicKey = await storage.read(key: 'public_key');

    if (publicKey != null) {
      // display the decoded public key in a pop-up page
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Elliptic Curve Keys"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  SelectableText("Public Key: 0x$publicKey"),
                ],
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                child: Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      // Show an error message if the public key doesn't exist
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("❌"),
            content: Text("You haven't created key pairs yet"),
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
  }

  Future<void> fetchseedPhrase() async {
    String? seedPhrase = await storage.read(key: 'seed_phrase');

    if (seedPhrase != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Seed Phrase"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  SelectableText(seedPhrase),
                ],
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                child: Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("❌"),
            content: Text("You haven't created key pairs yet"),
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
  }

  Future<bool> checkVisibility() async {
    final privateKey = await storage.read(key: 'private_key');
    final publicKey = await storage.read(key: 'public_key');

    return privateKey != null && publicKey != null;
  }

  Widget buildGenerateKeys() {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        width: 200,
        height: 70,
        child: ElevatedButton(
          style: ButtonStyle(
              shadowColor: MaterialStateProperty.all(Colors.cyanAccent),
              elevation: MaterialStateProperty.all(10.0),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white)
          ),
          onPressed: () {
            print("object");
            // derivePrivateKey();
          }, child: Text("Generate Keys", style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal, color: Colors.black ),),

        ));
  }

  Widget buildPublicKey() {
    return Visibility(
        visible: isVisible,
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
              retrievePublicKeys();
            },
            child: Text("Show Public Key", style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),),

          )),
    );
  }

  Widget buildPrivateKey() {
    return Visibility(
      visible: isVisible,
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
              retrievePrivateKeys();
              // retrieveAndDisplayPrivateKeys();
            },
            child: Text("Show Private Key", style: TextStyle(fontSize: 11, fontWeight: FontWeight.normal),),

          )),
    );
  }

  Widget buildSeedPhrase() {
    return Visibility(
      visible: isVisible,
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
              fetchseedPhrase();
            },
            child: Text("Show Phrase", style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),),

          )),
    );
  }

  changeView(index) {
    switch (index) {
      case 0:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => Keys()));
        break;
      case 1:
        print("Signature");
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => Attestation()));
        break;
      case 2:
        print("Home Page");
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => Homepage()));
        break;
      case 3:
        print("Request Page");
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => Keys()));
        break;
      case 4:
        print("Wallet Page");
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => LandingPage()));
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    checkVisibility().then((value) {
      setState(() {
        print(value);
        isVisible = value;

      });
    });
  }


  @override
  Widget build(BuildContext context) {


    return MaterialApp(

      home: Scaffold(
        body:  Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
        image: DecorationImage(
        image: AssetImage("assets/bg.png"), fit: BoxFit.cover),
    ),
    padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 70,
              ),
              Center(
              child: Image(image: AssetImage("assets/dapp.png"), fit: BoxFit.cover
             )),
              SizedBox(
                height: 10,
              ),
               Align(alignment: Alignment.centerLeft,
                child: Text('SECURE MOBILE ETH WALLET PROVIDER',
                  style: TextStyle(letterSpacing: 7, fontSize: MediaQuery.of(context).size.width * 0.015, fontWeight: FontWeight.normal, color: Colors.blue),),),
              SizedBox(height:25.0),
              buildPrivateKey(),
              buildPublicKey(),
              buildSeedPhrase()
            ],
          ),
        ),
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.grey,
            iconSize: 21.0,
            selectedFontSize: 14.0,
            unselectedFontSize: 11.0,
            type: BottomNavigationBarType.fixed,
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                print(index);
                _currentIndex = index;
              });
              changeView(_currentIndex);
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.lock),
                label: 'Keys',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.save_as),
                label: 'Sign',
              ),

              BottomNavigationBarItem(
                icon: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.cyan,
                  ),
                  child: Center(
                   child: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.home,
                      color: Colors.white,
                    ),
                  ),
                  ),
                ),
                label: 'Home',
              ),

              BottomNavigationBarItem(
                icon: Icon(Icons.add_box),
                label: 'Request',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.help),
                label: 'Help',
              ),

            ],
          )
      ));
  }
}

