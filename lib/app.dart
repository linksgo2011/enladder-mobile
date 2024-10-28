import 'package:enladder_mobile/screens/explore/explore_screen.dart';

import 'screens/books/bookshelf_screen.dart';
import 'package:flutter/material.dart';
import 'screens/home/home_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'widgets/bottom_navigation.dart';


class MyApp extends StatelessWidget {
  final ThemeData theme;
  
  const MyApp({Key? key, required this.theme}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '英语梯子 Enladder',
      theme: theme,
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const BookshelfScreen(),
    const ExploreScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(30.0), // 进一步减小高度
        child: AppBar(
          title: Text('Enladder 英语梯子', style: TextStyle(fontSize: 16)),
          centerTitle: true,
          elevation: 0,
          automaticallyImplyLeading: false, // 移除默认的返回按钮
        ),
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigation(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
