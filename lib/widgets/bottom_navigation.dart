import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomNavigation({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: '首页',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.book),
          label: '课程',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: '我的',
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: Colors.blue,
      onTap: onItemTapped,
    );
  }
}

