import 'package:flutter/material.dart';
import 'package:manga_application/screens/account_page.dart';
import 'package:manga_application/screens/all_page.dart';
import 'package:manga_application/screens/category_page.dart';
import 'package:manga_application/screens/new_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  void _onTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('')),
      body: PageView(
        controller: _pageController,
        children: [NewPage(), AllPage(), CategoryPage(), AccountPage()],
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.fiber_new), label: 'มาใหม่'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'ทั้งหมด'),
          BottomNavigationBarItem(icon: Icon(Icons.storage), label: 'ประเภท'),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box),
            label: 'บัญชี',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.amber,
        onTap: _onTapped,
      ),
    );
  }
}
