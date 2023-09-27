import 'dart:io';
import 'package:convert/convert.dart';
import 'package:master/Pages/login.dart';
import 'package:master/Pages/signcontract.dart';
import 'package:path_provider/path_provider.dart';
import 'package:web3dart/web3dart.dart';
import 'package:flutter/material.dart';
import 'package:master/Pages/help.dart';
import '../Models/address.dart';
import '../Models/secure_storage.dart';

import 'attestation.dart';
import 'keys.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';

import 'package:bip39/bip39.dart' as bip39;
import 'package:bip32/bip32.dart' as bip32;
import 'package:flutter/cupertino.dart';
import 'package:web3dart/credentials.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';


class Homepage extends StatefulWidget {
  @override
  _Homepage createState() => _Homepage();
}

class _Homepage extends State<Homepage> {

  final String _APIKEY= '69df087c067c4585bcf18d4fa1189ec3';
  String _Url = 'https://mainnet.infura.io/v3/69df087c067c4585bcf18d4fa1189ec3';
  String _walletName='Dan';
  String _privateKey='';
  String _publicKey='';
  String _addressHex='Not generated';
  String _balance = '⏳';
  bool isVisible = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 0;
  late XFile? _picker;
  String _selectedNetwork = 'MAINNET';

  static const String contractAbi= '''
  [
	{
		"inputs": [],
		"stateMutability": "nonpayable",
		"type": "constructor"
	},
	{
		"inputs": [],
		"name": "MAX_TRUSTING_ENTITIES",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "_certificateName",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "_encryptedCertificate",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "_issuer",
				"type": "string"
			},
			{
				"internalType": "uint256",
				"name": "_expiryDate",
				"type": "uint256"
			}
		],
		"name": "SignCertificate",
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
				"name": "_certificateName",
				"type": "string"
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
		"name": "deleteEntity",
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
			},
			{
				"internalType": "uint256",
				"name": "start",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "count",
				"type": "uint256"
			}
		],
		"name": "getTrustingEntities",
		"outputs": [
			{
				"internalType": "address[]",
				"name": "",
				"type": "address[]"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			}
		],
		"name": "isEntity",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "owner",
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
		"inputs": [
			{
				"internalType": "address",
				"name": "_trustedEntity",
				"type": "address"
			}
		],
		"name": "removeTrustedEntity",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"name": "trustiesOf",
		"outputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			}
		],
		"stateMutability": "view",
		"type": "function"
	}
]
   ''';

  Future<void> executeOnce(Function function) async {
    // Check if the function has already been executed
    final hasExecuted = await storage.read(key: 'hasExecuted') == 'true';

    if (!hasExecuted) {
      // Execute the function if it hasn't been executed yet
      await function();

      // Store the value of the hasExecuted variable to indicate that the function has been executed
      await storage.write(key: 'hasExecuted', value: 'true');
    }
  }

  Future<void> derivePrivateKey() async {
    String randomMnemonic = bip39.generateMnemonic();
    print("#############################################");
    print(randomMnemonic);

    // Generate a 512-bit seed from the seed phrase
    final seed = await bip39.mnemonicToSeed(randomMnemonic);
    print("Seed");
    print(seed);

    // Derive a BIP32 extended key from the seed
    final root = bip32.BIP32.fromSeed(seed);
    print("Root");
    print(root);

    // Derive a child key at index 0 of the BIP32 tree using the standard HD path for Ethereum
    final child = root.derivePath("m/44'/60'/0'/0/0");
    print("Child");
    print(child);

    // Return the private key as a hexadecimal string
    var privateKeyHex = hex.encode(child.privateKey as List<int>);
    print("PrivateKey: 0x$privateKeyHex");
    final credentials = EthPrivateKey.fromHex(privateKeyHex);
    final publicKey = await credentials.encodedPublicKey;
    final publicKeyHex = hex.encode(publicKey as List<int>);
    print("PrivateKey: 0x$privateKeyHex");
    print("PrivateKey: 0x$publicKeyHex");
    print(publicKeyHex);

    //  Store the keys locally
    storeKeysInLocalStorage(privateKeyHex, publicKeyHex,randomMnemonic);
  }

  Future<void> storeKeysInLocalStorage(Private, Public, seedPhrase) async {
    // Check if the keys already exist in the storage
    String? privateKey = await storage.read(key: 'private_key');
    String? publicKey = await storage.read(key: 'public_key');
    String? phrase = await storage.read(key: 'seed_phrase');

    if (privateKey != null && publicKey != null && phrase != null) {
      // Show a dialog if the keys already exist
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Key Pairs"),
            content: Text("Elliptic Curve key pairs already exist, no need to generate new ones."),
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
      // Store the private and public keys and seed phrase in the secure storage
      await storage.write(key: 'private_key', value: Private);
      await storage.write(key: 'public_key', value: Public);
      await storage.write(key: 'seed_phrase', value: seedPhrase);

      // Show a dialog to confirm the creation of key pairs and reload the page
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Key Pairs"),
            content: Text("Elliptic Curve key pairs generated successfully."),
            actions: [
              ElevatedButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (BuildContext context) => Keys()),
                  );
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


    if (privateKey != null && privateKey.isNotEmpty) {
      Credentials credentials = EthPrivateKey.fromHex(privateKey);
      EthereumAddress address = await credentials.extractAddress();

      setState(() {
        _privateKey = "0x$privateKey";
        _publicKey = "0x$publicKey";
        _addressHex = address.hex;
      });

      var InfuraUrl = Uri.parse(_Url);

      final String payload = jsonEncode({
        'jsonrpc': '2.0',
        'method': 'eth_getBalance',
        'params': [_addressHex, 'latest'],
        'id': 1
      });

      final http.Response response = await http.post(InfuraUrl, body: payload);

      final Map<String, dynamic> data = jsonDecode(response.body);
      final BigInt balance = BigInt.parse(data['result'].substring(2), radix: 16);

      final double etherBalance = balance / BigInt.from(10).pow(18);

      setState(() {
        _balance = etherBalance.toStringAsFixed(2);
      });
    }
  }

  Future<String?> getWalletName() async {
    // Read the wallet name from Flutter Secure Storage
    String? walletName = await storage.read(key: "wallet_name");

    if (walletName != null) {
      setState(() {
        _walletName = walletName;
        print(_walletName);
      });

      return walletName;
    }

    // Return a default value if the wallet name is not found
    setState(() {
      _walletName = "Not Found";
    });

    return null;
  }

  Future<void> showResultDialog(BuildContext context, String result) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Notification 🔔'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                if (result == "Daniel") // if result is null, display 'Loading...'
                  Text("Congratulations 🎉. You've successfully joined the smart contract!" ),

                if (result != "Daniel") // if result is false, display an error message
                  Text('Error ❌: Something went wrong. Try again'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<List<dynamic>> addEntity() async {
    // Replace with your own RPC URL and contract address
    print("Executing the Function addEntity");

    String? privateKey = await storage.read(key: 'private_key');
    String? publicKey = await storage.read(key: 'public_key');

    final String rpcUrl = "https://sepolia.infura.io/v3/69df087c067c4585bcf18d4fa1189ec3";
    final String contractAddress = "0xF1149aB1581346981Be924be1CaD08F44C9E2121";
    String privateHex="0x$privateKey";;
    String publicHex="0x$publicKey";
    String functionName="addEntity";
retrievePrivateKeys();
    print(privateHex);
    print(publicHex);
    print(_walletName);

    final client = Web3Client(rpcUrl, http.Client());

    final credentials = EthPrivateKey.fromHex(privateHex);
    final address = credentials.address;

    final contract = DeployedContract(
      ContractAbi.fromJson(contractAbi, "MyContract"),
      EthereumAddress.fromHex(contractAddress),
    );

    print(await client.getBalance(address));
    final function = contract.function("addEntity");

    final result = await client.call(
      contract: contract,
      function: function,
     params: [publicHex, _walletName],
    );

    print("###########");
    print(result);
    // Check if transaction receipt exists and has no errors
    // print(await client.getTransactionReceipt);

    // await showResultDialog(context, result[0].toString());

    return result;
  }

  Future<void> checkKeys() async {
    String? privateKey = await storage.read(key: 'private_key');

    if (privateKey != null && privateKey.isNotEmpty) {
      print("Pair Keys has already been generated");
    } else {
      derivePrivateKey();
    }
  }

  Widget buildSendBtn() {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 25),
        width: 125,
        child: ElevatedButton(
          style: ButtonStyle(
              shadowColor: MaterialStateProperty.all(Colors.black),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0),
  ),
),
              elevation: MaterialStateProperty.all(5.0),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlue)
          ),

          onPressed: () {
           addEntity();
          }, child: Text("SEND", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),),

        ));
  }

  Widget buildReciveBtn() {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 25),
        width: 125,
        child: ElevatedButton(
          style: ButtonStyle(
              shadowColor: MaterialStateProperty.all(Colors.black),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              elevation: MaterialStateProperty.all(5.0),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.green)
          ),

          onPressed: () {

          }, child: Text("RECEIVE", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),),

        ));
  }

  Widget buildNetwork() {
    return Container(
      child: DropdownButton<String>(
        value: _selectedNetwork,
        onChanged:(String? newValue) {
          setState(() {
            _selectedNetwork = newValue!;
            _Url = 'https://' + _selectedNetwork + '.infura.io/v3/' + _APIKEY;
            retrievePrivateKeys();


          });
        },
        items: <String>['MAINNET', 'GOERLI', 'SEPOLIA']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  Widget buildAddress() {
    return GestureDetector(
      onLongPress: () {
        Clipboard.setData(ClipboardData(text: _walletName));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Copied to clipboard'),
          ),
        );
      },
      child: Text(
        _walletName,
        style: TextStyle(
          color: Colors.black,
          fontSize: 30.0,
        ),
      ),
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

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().getImage(source: source);

    if (pickedFile != null) {
      final ImageCropper imageCropper = ImageCropper();
      final croppedFile = await imageCropper.cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 100,
        maxHeight: 800,
        maxWidth: 800,
        compressFormat: ImageCompressFormat.png,
        cropStyle: CropStyle.rectangle,

      );

      if (croppedFile != null) {
        setState(() {
          _picker = croppedFile as XFile?;
        });
      }
    }
  }

  void initState() {

    checkKeys();
    getWalletName().then((value) {
      setState(() {print(value);
      _walletName=value!;});
    });
    print('Wallet Name: $_walletName');

   retrievePrivateKeys();
   executeOnce(addEntity);
   addEntity();
  }

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      theme: ThemeData(primaryIconTheme: IconThemeData(color: Colors.blue)),
      home: Scaffold(
          extendBodyBehindAppBar: true,
          drawerEdgeDragWidth: double.maxFinite,
          appBar: AppBar(
            actions: <Widget>[
              buildNetwork()
            ],
            backgroundColor: Colors.white.withOpacity(0.5),
            elevation: 0,
            iconTheme:IconThemeData(
              color: Colors.black,
              size: 40,
              opacity: 1,) ,
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/bg.png'),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.2), BlendMode.plus),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage('assets/Peter.png'),
                        radius: 45.0,
                      ),

                      Text(
                        _walletName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        '$_balance ETH',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.home),
                  title: Text('Home'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Homepage()));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Settings'),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Log Out'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Login2()));
                  },
                ),
              ],
            ),
          ),


          body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/bg.png'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      Colors.white.withOpacity(0.3), BlendMode.darken),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.cyan,
                            width: 4.0,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 50.0,
                          backgroundColor: Colors.transparent,
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: AssetImage('assets/Peter.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                      ),
                      SizedBox(height: 10.0),
                      Text(
                        _walletName,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 30.0,
                        ),
                      ),

                      SelectableText(
                        _addressHex,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    '$_balance ETH',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                    ),
                  ),

                  Divider(
                    thickness: 2,
                    color: Colors.grey,
                    indent: 30.0,
                    endIndent: 30.0,
                  ),
                  // SizedBox(height: 10.0),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildSendBtn(),
                      buildReciveBtn(),

                    ],
                  ),
                ],
              )

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
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.home,
                      color: Colors.white,
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
      ),
    );

  }
}

