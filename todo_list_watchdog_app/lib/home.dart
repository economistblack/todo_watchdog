import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:todo_list_watchdog_app/view/friendtodo.dart';
import 'package:todo_list_watchdog_app/view/privatetodo.dart';
import 'package:todo_list_watchdog_app/view/publictodo.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0; // 탭바 인덱스


  List<Widget> tabItems = [
    Center(child: PrivateToDo()),
    Center(child: FriendToDo()),
    Center(child: PublicToDo()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: tabItems[_selectedIndex]),
      bottomNavigationBar: FlashyTabBar(
        animationCurve: Curves.linear,
        selectedIndex: _selectedIndex,
        iconSize: 30,
        backgroundColor: Color(0xFF38BDF8),
        showElevation: false,
        onItemSelected:
            (index) => setState(() {
              _selectedIndex = index;
            }),
        items: [
          FlashyTabBarItem(
            icon: Icon(Icons.person, color: Color(0xFFA3E635), size: 40),
            title: Text('프라이빗 To-Do', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF334155)),)
            ),
          FlashyTabBarItem(
            icon: Icon(Icons.group, color: Color(0xFFA3E635), size: 40), 
            title: Text('친구 To-Do', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF334155)),)
            ),
          FlashyTabBarItem(
            icon: Icon(Icons.public, color: Color(0xFFA3E635), size: 40), 
            title: Text('퍼블릭 To-Do', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF334155)),)
            ),
        ],
      ),
    );
  }
}
