import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:path_provider/path_provider.dart';

import 'homepage.dart';
import 'keys.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPage createState() => _LandingPage();
}

class _LandingPage extends State<LandingPage> {
  String _walletName = '';
  bool _webviewLoaded = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final String url = 'https://artifitialleap.ai/';
  int _currentIndex = 0;
  changeView(index) {
    switch (index) {
      case 0:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => Keys()));
        break;
      case 1:
        print("Signature");
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => Keys()));
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
  Future<String?> getWalletName() async {
    // Get the application documents directory
    Directory directory = await getApplicationDocumentsDirectory();

    // Create a file with the name "wallet_details.txt" in the documents directory
    File file = File("${directory.path}/wallet_details.txt");

    if (await file.exists()) {
      // Read the contents of the file
      String fileContents = await file.readAsString();

      // Extract the wallet name from the file contents
      RegExp exp = RegExp(r"Wallet Name: (.+)");
      Match match = exp.firstMatch(fileContents) as Match;
      if (match != null) {
        setState(() {
          _walletName= match.group(1)!;

          print(_walletName);
        });

        return match.group(1);
      }
    }
    // Return null if the file does not exist or the wallet name is not found
    setState(() {
      _walletName= "My Account";
    });

    return null;
  }

  Widget buildInAppWebView(){
    return Container(
        child: InAppWebView(
          initialUrlRequest: URLRequest(url: Uri.parse(url)),
          initialOptions: InAppWebViewGroupOptions(
            crossPlatform: InAppWebViewOptions(

            ),
          ),
          onWebViewCreated: (InAppWebViewController controller) {
            controller.evaluateJavascript(source:'document.title').then((value) {
              print(value); // prints the title of the loaded page
            });
          },
          onLoadError: (controller, url, code, message) {
            print(controller);
            print(url);
            print(code);
            print(message);

            setState(() {
              _webviewLoaded = false;
            });
          },
        )
      );
}

  Widget buildLoadError(){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/logo_black.png',
            width: 150.0,
            height: 100.0,
          ),
          SizedBox(height: 20.0),
          Text(
            'Oops! Something went wrong.',
            style: TextStyle(
              color: Colors.black,
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _webviewLoaded = true;
              });
            },
            child: Text(
              'Retry',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.blue,
              padding: EdgeInsets.symmetric(
                vertical: 12.0,
                horizontal: 24.0,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
          ),
        ],
      ),
    );
}

@override
  void initState() {
    super.initState();
    getWalletName();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryIconTheme: IconThemeData(color: Colors.blue)),
      home: Scaffold(
          extendBodyBehindAppBar: true,
          drawerEdgeDragWidth: double.maxFinite,
          appBar: AppBar(
            backgroundColor: Colors.white.withOpacity(0.9),
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
                        radius: 50.0,
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        _walletName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.home),
                  title: Text('Home'),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Settings'),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Log Out'),
                  onTap: () {},
                ),
              ],
            ),
          ),
        body: _webviewLoaded? buildInAppWebView() : buildLoadError(),
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