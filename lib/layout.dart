import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:visite3000/main.dart';
import 'package:visite3000/settings.dart';
import 'package:visite3000/share.dart';
import 'package:visite3000/views/my_cards/my_cards.dart';
import 'package:visite3000/views/wallet/wallet.dart';

class Layout extends StatefulWidget
{
  const Layout({super.key});

  @override
  State<Layout> createState() => _LayoutState();

}

class _LayoutState extends State<Layout>
{

  final _storage = const FlutterSecureStorage();
  String selectedPageName = "";

  void _logOut(){
    _storage.deleteAll();

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => const MyApp()));
  }

  final List<Widget> _pagesDestinationList = const [
    Wallet(),
    Share(),
    MyCards()
  ];

  final List<String> _pagesDestinationNameList = const [
    "Wallet",
    "Share",
    "MyCards"
  ];

  int _selectedIndex = 0;

  void _onItemTapped(int index)
  {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(_pagesDestinationNameList[_selectedIndex]),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset("assets/icons/Logo-Visite3000-Splash.png"),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: _logOut,
              child: const Icon(
                Icons.power_settings_new_outlined
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (builder) => const Settings())),
              child: const Icon(
                Icons.settings
              ),
            ),
          )
        ],
      ),
      body: _pagesDestinationList[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.pink,
        selectedItemColor: Colors.yellow,
        unselectedItemColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.wallet, color: Colors.white),
            activeIcon: Icon(Icons.wallet, color: Colors.yellow),
            label: "Wallet"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.offline_share, color: Colors.white),
            activeIcon: Icon(Icons.offline_share, color: Colors.yellow),
            label: 'Share'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.white),
            activeIcon: Icon(Icons.home, color: Colors.yellow),
            label: 'My cards'
          )
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
