import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class MyBottomNavigationBar extends StatefulWidget {
  MyBottomNavigationBar({Key? key, required this.selectedIndexNavBar})
      : super(key: key);
  int selectedIndexNavBar;

  @override
  State<MyBottomNavigationBar> createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  void _onTap(int index) {
    widget.selectedIndexNavBar = index;
    setState(() {
      switch (index) {
        case 0:
          Navigator.pushReplacementNamed(context, '/home');
          break;
        case 1:
          Navigator.pushReplacementNamed(context, '/exercise');
          break;
        case 2:
          Navigator.pushReplacementNamed(context, '/food');
          break;
        case 3:
          Navigator.pushReplacementNamed(context, '/user');
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      index: widget.selectedIndexNavBar,
      color: Colors.deepPurple.shade300,
      backgroundColor: Colors.transparent,
      buttonBackgroundColor: Colors.orange,
      height: 60,
      items: const <Widget>[
        Icon(Icons.home, size: 20),
        Icon(Icons.directions_run, size: 20),
        Icon(Icons.food_bank,size: 20),
        Icon(Icons.person, size: 20),
      ],
      animationDuration: const Duration(milliseconds: 200),
      animationCurve: Curves.bounceInOut,
      onTap: _onTap,
    );
  }
}
