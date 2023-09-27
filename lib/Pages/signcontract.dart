import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/src/client.dart';
import 'package:flutter/cupertino.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/web3dart.dart';
import '../Models/secure_storage.dart';
import 'homepage.dart';
import 'help.dart';
import 'keys.dart';
import 'package:web3dart/contracts.dart';
import 'package:http/http.dart' as http;

class Attestation2 extends StatefulWidget {
  @override
  _Attestation2 createState() => _Attestation2();
}

class _Attestation2  extends State<Attestation2> {
  static const String contractAbi='''
[
	{
		"inputs": [],
		"stateMutability": "nonpayable",
		"type": "constructor"
	},
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "_pubKey",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "_username",
				"type": "string"
			}
		],
		"name": "addEntity",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_trustedEntity",
				"type": "address"
			}
		],
		"name": "addTrustedEntity",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "contractName",
		"outputs": [
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_recipient",
				"type": "address"
			},
			{
				"internalType": "string",
				"name": "_certName",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "_certificate",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "_hash",
				"type": "string"
			}
		],
		"name": "issueCertificate",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_entity",
				"type": "address"
			}
		],
		"name": "verifyEntity",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"stateMutability": "view",
		"type": "function"
	}
]
  ''';

  int _currentIndex = 0;
  bool isVisible = true;
  String _privateKey='';
  String _publicKey='';
  String _username='';
  bool _someBoolean= true;
  final TextEditingController recipientAddress = TextEditingController();
  final TextEditingController issuerAddress = TextEditingController();
  final TextEditingController description  = TextEditingController();
  final TextEditingController dateIssued = TextEditingController();
  final TextEditingController validity = TextEditingController();
  // Deploy a new contract

  Future<Future> addCertificate() async {
    final String rpcUrl = "https://sepolia.infura.io/v3/69df087c067c4585bcf18d4fa1189ec3";
    final String contractAddress = "0xe5a5c3EDcC81E4817feaeAC9166495cf570100B8";
    String privateHex="0x292239a93925ad80cc45deb737a0a63b444b7321934c5f03cd7dc1b44de68c66";
    String _certName="Test Certificate";
    String _certificate="The owner of this attestation is authorized bla bla";
    BigInt _issueDate= BigInt.from(1651660800);

    final client = Web3Client(rpcUrl, http.Client());
    final credentials = EthPrivateKey.fromHex(privateHex);
    final address = credentials.address;

    final contract = DeployedContract(
      ContractAbi.fromJson(contractAbi, "myContract"),
      EthereumAddress.fromHex(contractAddress),
    );

    final function = contract.function("addCertificate");
    final result = await client.call(
      contract: contract,
      function: function,
      params: [address, _certName, _certificate,_issueDate],
    );

    // Check if transaction receipt exists and has no errors
    String receipt = result[0];

    if (receipt == "Certificate added successfully") {
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Success"),
            content: Text("The Certificate was added successfully"),
            actions: <Widget>[
              ElevatedButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    } else {
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("There was an error adding the Certificate"),
            actions: <Widget>[
              ElevatedButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }

  }

  Future<Future> addEntity() async {
    final String rpcUrl = "https://sepolia.infura.io/v3/69df087c067c4585bcf18d4fa1189ec3";
    final String contractAddress = "0xF6E12EFfDaCa7275A040C49d312325872FC13c21";
    String privateHex="0x292239a93925ad80cc45deb737a0a63b444b7321934c5f03cd7dc1b44de68c66";
    String publicHex="0x6ae6f0778856b3e071a30ba853fa7b5e14cc9e06d59e2799562889f4a81f4358756dc1d57cc1173d3500ef4f7c45d85ddcfe787288a90e78300782681f798b79";
    String username="Daniel";
    String functionName="addEntity";

    final client = Web3Client(rpcUrl, http.Client());
    final credentials = EthPrivateKey.fromHex(privateHex);
    final address = credentials.address;

    final contract = DeployedContract(
      ContractAbi.fromJson(contractAbi, "myContract"),
      EthereumAddress.fromHex(contractAddress),
    );

    final function = contract.function("addEntity");
    final result = await client.call(
      contract: contract,
      function: function,
      params: [publicHex, username],
    );

    // Check if transaction receipt exists and has no errors
    String receipt = result[0];

    if (receipt == "Daniel") {
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Success"),
            content: Text("The entity was added successfully"),
            actions: <Widget>[
              ElevatedButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    } else {
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("There was an error adding the entity"),
            actions: <Widget>[
              ElevatedButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }

  }

  Future<void> retrievePrivateKeys() async {
    String? privateKey = await storage.read(key: 'private_key');
    String? publicKey = await storage.read(key: 'public_key');
    String? username = await storage.read(key: 'wallet_name');

    if (privateKey != null && privateKey.isNotEmpty && publicKey != null && publicKey.isNotEmpty) {
      Credentials credentials = EthPrivateKey.fromHex(privateKey);
      EthereumAddress address = await credentials.extractAddress();

      setState(() {
        _privateKey = "0x$privateKey";
        _publicKey = "0x$publicKey";
        _username=username!;
      });

    }
  }

  Widget buildInitiateUserBtn() {
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

            },
            child: Text("Join Contract", style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),),

          )),
    );
  }

  Widget buildAddOrganizationBtn() {
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
            },
            child: Text("Verify", style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),),

          )),
    );
  }

  Widget buildrecipientAddress() {
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
            controller: recipientAddress,
            keyboardType: TextInputType.text,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14),
                prefixIcon:
                Icon(Icons.account_circle, color: Colors.grey),
                hintText: '0xa1123a...',
                hintStyle: TextStyle(color: Colors.grey)),
          ),
        )
      ],
    );
  }

  Widget buildissuerAddress() {
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
            controller:  issuerAddress,
            keyboardType: TextInputType.text,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14),
                prefixIcon:
                Icon(Icons.account_circle, color: Colors.grey),
                hintText: '0xa1123a...',
                hintStyle: TextStyle(color: Colors.grey)),
          ),
        )
      ],
    );
  }

  Widget buildDescription() {
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
            controller:  description,
            keyboardType: TextInputType.text,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14),
                prefixIcon:
                Icon(Icons.account_circle, color: Colors.grey),
                hintText: 'Description',
                hintStyle: TextStyle(color: Colors.grey)),
          ),
        )
      ],
    );
  }

  Widget buildDateIssued() {
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
            controller:  dateIssued,
            keyboardType: TextInputType.text,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14),
                prefixIcon:
                Icon(Icons.account_circle, color: Colors.grey),
                hintText: 'Date Issued',
                hintStyle: TextStyle(color: Colors.grey)),
          ),
        )
      ],
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
            builder: (_) => Attestation2()));
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
    retrievePrivateKeys();
    print("*******************");
    print(_privateKey);
    print("*******************");
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

                 buildInitiateUserBtn(),

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

