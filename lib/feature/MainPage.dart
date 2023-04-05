

import 'package:flutter/material.dart';
import 'package:vent_news/feature/category/CategoryPage.dart';
import 'package:vent_news/feature/home/HomePage.dart';
import 'package:vent_news/feature/search/SearchPage.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);


  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _bottomNavIndex = 0;

  final List<BottomNavigationBarItem> _bottomNavbarItems = [
      const BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: "Home",
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.search),
        label: "Search",
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.article_outlined),
        label: "Category",
      ),
  ];

  final List<Widget> _listWidget = [
    const HomePage(),
    const SearchPage(),
    const CategoryPage(),
  ];

  @override
  void initState() { 
    super.initState();
  } 

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _listWidget[_bottomNavIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomNavIndex,
        items: _bottomNavbarItems,
        onTap: (selected) {
          setState(() {
            _bottomNavIndex = selected;
          });
        },
      ),
    );
  }
}