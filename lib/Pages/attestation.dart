import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/src/client.dart';
import 'package:flutter/cupertino.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/web3dart.dart';
import '../Models/address.dart';
import '../Models/secure_storage.dart';
import 'homepage.dart';
import 'help.dart';
import 'keys.dart';
import 'package:web3dart/contracts.dart';
import 'package:http/http.dart' as http;



class Attestation extends StatefulWidget {
  @override
  _Attestation createState() => _Attestation();
}

class _Attestation extends State<Attestation> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _addformKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _signformKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _verifyformKey = GlobalKey<FormState>();
  late DateTime _selectedDate = DateTime.now();
  late String _description;
  late String _signNote;
  late String _certificateName;
  late String _certificateIndex;
  late String _ownerAddress;
  late String _trustedAddress;
  late String _certificateLocation;
  int _currentIndex = 0;
  bool isVisible = true;
  String _privateKey='';
  String _publicKey='';
  String _username='';
  bool _someBoolean= true;
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
				"internalType": "address",
				"name": "_entityAddress",
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
				"internalType": "uint256",
				"name": "_issueDate",
				"type": "uint256"
			}
		],
		"name": "addCertificate",
		"outputs": [
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
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
		"outputs": [
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			}
		],
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
				"internalType": "string",
				"name": "",
				"type": "string"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"name": "allEntities",
		"outputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			}
		],
		"stateMutability": "view",
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
		"inputs": [],
		"name": "getAllEntities",
		"outputs": [
			{
				"internalType": "address[]",
				"name": "",
				"type": "address[]"
			},
			{
				"internalType": "string[]",
				"name": "",
				"type": "string[]"
			}
		],
		"stateMutability": "view",
		"type": "function"
	}
]
  ''';

  final TextEditingController recipientAddress = TextEditingController();
  final TextEditingController issuerAddress = TextEditingController();
  final TextEditingController description  = TextEditingController();
  final TextEditingController dateIssued = TextEditingController();
  final TextEditingController validity = TextEditingController();
  // Deploy a new contract

  Future<Future> addCertificate(String certName, String certDescription, DateTime issueDate) async {
   retrievePrivateKeys();
    final String rpcUrl = "https://sepolia.infura.io/v3/69df087c067c4585bcf18d4fa1189ec3";
    final String contractAddress = "0xd9145CCE52D386f254917e481eB44e9943F39138";
    int millisecondsSinceEpoch = issueDate.millisecondsSinceEpoch;
    BigInt _issueDate= BigInt.from(millisecondsSinceEpoch);
    print(_issueDate);

    String field1 ="This is test";
    String field2="asdjkflhaskdjfhalskdfasdf";


    final client = Web3Client(rpcUrl, http.Client());

    print(_privateKey);
    final credentials = EthPrivateKey.fromHex(_privateKey);
    final address = credentials.address;
print(address);
    final contract = DeployedContract(
      ContractAbi.fromJson(contractAbi, "myContract"),
      EthereumAddress.fromHex(contractAddress),
    );

    final function = contract.function("addCertificate");
    final result = await client.call(
      contract: contract,
      function: function,
      params: [address, field1, field2,_issueDate],
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
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

  Widget buildCertificate () {
    return SingleChildScrollView(
      child: Form(
        key: _addformKey,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Certificate Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a certificate name';
                  }
                  return null;
                },
                onSaved: (value) => _certificateName = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
                onSaved: (value) => _description = value!,
              ),
              SizedBox(height: 3),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_selectedDate == null
                      ? 'No date selected'
                      : 'Selected date: ${_selectedDate.toLocal().toString().split(' ')[0]}'),
                  ElevatedButton(
                    onPressed: () => _selectDate(context),
                    child: Text('Issuing Date'),
                  ),
                ],
              ),
              SizedBox(height: 3),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    addCertificate(_certificateName, _description, _selectedDate);
                    print('Certificate Name: $_certificateName');
                    print('Description: $_description');
                    print('Issuing Date: $_selectedDate');
                  }
                },
                child: Text('Add Certificate'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSignature () {
    return SingleChildScrollView(
      child: Form(
        key: _signformKey,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Certificate Index'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a certificate name';
                  }
                  return null;
                },
                onSaved: (value) => _certificateIndex = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Note'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
                onSaved: (value) => _signNote = value!,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // addCertificate(_certificateName, _description, _selectedDate);
                  }
                },
                child: Text('Sign'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildVerify () {
    return SingleChildScrollView(
      child:    Form(
        key: _verifyformKey,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Owner ETH Address'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter address';
                  }
                  return null;
                },
                onSaved: (value) => _ownerAddress = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Certificate index'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a index';
                  }
                  return null;
                },
                onSaved: (value) => _certificateLocation = value!,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // addCertificate(_certificateName, _description, _selectedDate);
                  }
                },
                child: Text('Verify'),
              ),
            ],
          ),
        ),
      )
    );

  }

  Widget buildTrusty () {
    return SingleChildScrollView(
        child:    Form(
          key: _verifyformKey,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Trusted ETH Address'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter address';
                    }
                    return null;
                  },
                  onSaved: (value) => _trustedAddress = value!,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      // addCertificate(_certificateName, _description, _selectedDate);
                    }
                  },
                  child: Text('Trust'),
                ),
              ],
            ),
          ),
        )
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
    retrievePrivateKeys();
    print("*******************");
    print(_privateKey);
    print("*******************");
    super.initState();
    _tabController = TabController(vsync: this, length: 4);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
              child: LayoutBuilder(
                builder:(BuildContext context, BoxConstraints constraints) {
                  double widthPercentage = 0.5; // 50% of the screen width
                  double heightPercentage = 0.3; // 30% of the screen height

                  double boxWidth = constraints.maxWidth * widthPercentage;
                  double boxHeight = constraints.maxHeight * heightPercentage;

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: boxHeight,
                      ),
                      Center(
                          child: Image(image: AssetImage("assets/dapp.png"),
                              fit: BoxFit.cover
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      Align(alignment: Alignment.centerLeft,
                        child: Text('SECURE MOBILE ETH WALLET PROVIDER',
                          style: TextStyle(
                              letterSpacing: 7,
                              fontSize: MediaQuery
                                  .of(context)
                                  .size
                                  .width * 0.015,
                              fontWeight: FontWeight.normal,
                              color: Colors.blue),),),
                      SizedBox(height: 25.0),

                      Container(

                        color: Colors.black,

                        child: TabBar(
                          controller: _tabController,
                          labelColor: Colors.black,
                          // Text color of selected tab
                          unselectedLabelColor: Colors.white,
                          // Text color of unselected tabs
                          indicator: BoxDecoration(
                            color: Colors.orangeAccent,
                            // Selected tab background color
                            borderRadius: BorderRadius.circular(00),
                          ),
                          tabs: [
                            Tab(text: '➕ Cert '),
                            Tab(text: '➕ Trusty'),
                            Tab(text: '✍️ Sign'),
                            Tab(text:'✔ ️Verify')

                          ],
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,

                          children: [
                            buildCertificate(),
                            buildTrusty(),
                           buildSignature(),
                            buildVerify(),

                          ],
                        ),
                      ),

                    ],

                  );
                }
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