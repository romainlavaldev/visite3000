import 'package:flutter/material.dart';
import 'package:visite3000/my_cards.dart';
import 'package:visite3000/share.dart';
import 'package:visite3000/wallet.dart';

class Layout extends StatefulWidget
{
  const Layout({super.key});

  @override
  State<Layout> createState() => _LayoutState();

}

class _LayoutState extends State<Layout>
{

  final List<Widget> _pagesDestinationList = const [
    Wallet(),
    Share(),
    MyCards()
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
      appBar: AppBar(
        title: const Text("Layout"),
      ),
      body: _pagesDestinationList[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.wallet),
            label: 'Wallet'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.offline_share),
            label: 'Share'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'My cards'
          )
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
