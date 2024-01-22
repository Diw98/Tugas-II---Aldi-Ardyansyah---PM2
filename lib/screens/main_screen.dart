import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:menu/screens/date_screen.dart';
import 'package:menu/screens/listview_screen.dart';
import 'package:menu/screens/profile.dart';
import 'package:menu/screens/staggeredGridViewScreen.dart';
import 'package:menu/screens/add_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  int _index = 0;
  final List<Widget> _screens = [
    const StaggeredGridViewScreen(),
    const ListVieww(),
    const DateScreen(),
    const AddScreen(),
    const Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Aldi Showroom')),
      body: _screens[_index],
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: _index,
        height: 60,
        items: const [
          Icon(Icons.grid_view, size: 30),
          Icon(Icons.list, size: 30),
          Icon(Icons.date_range_outlined, size: 30),
          Icon(Icons.search, size: 30),
          Icon(Icons.perm_identity, size: 30),
        ],
        color: Colors.white,
        buttonBackgroundColor: Colors.lightBlue,
        backgroundColor: Colors.grey,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 600),
        onTap: (index) {
          setState(() {
            _index = index;
          });
        },
      ),
    );
  }
}
