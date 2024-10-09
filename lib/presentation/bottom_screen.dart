import 'dart:io';

import 'package:flutter/material.dart';
import 'package:untitled/presentation/insurance_cover.dart';
import 'package:untitled/presentation/profile_screen.dart';
import 'package:untitled/presentation/reports_screen.dart';
import 'package:untitled/theme/color_constant.dart';

  class BottomScreen extends StatefulWidget {
  const BottomScreen({super.key});

  @override
  State<BottomScreen> createState() => _BottomScreenState();
}

class _BottomScreenState extends State<BottomScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetOptions = <Widget>[
      InsuranceCover(),
      ReportsScreen(),
      ProfileScreen(),
    ];

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: ColorConstant.gray900,
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Color(0xFF30BEB6),
          unselectedItemColor: ColorConstant.gray900,
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              backgroundColor: ColorConstant.gray600,
              icon: const Icon(Icons.medical_information_outlined),
              label: 'Insurance Cover',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.details_outlined),
              label: 'Reports',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_sharp),
              label: 'Account',
            ),
          ],
        ),
        body: widgetOptions.elementAt(_selectedIndex),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    _onBackPressed();
    return true;
  }

  Object _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm'),
          content: const Text('Do you want to exit the App'),
          actions: <Widget>[
            MaterialButton(
              child: const Text(
                'No',
                style: TextStyle(color: Colors.blue),
              ),
              onPressed: () {
                Navigator.of(context).pop(false); //Will not exit the App
              },
            ),
            MaterialButton(
              child: const Text(
                'Yes',
                style: TextStyle(color: Colors.blue),
              ),
              onPressed: () {
                exit(0);
              },
            )
          ],
        );
      },
    );
  }

  // ignore: unused_element
  void _onTap(int index) {
    _selectedIndex = index;
    setState(() {});
  }
}
