import 'package:flutter/material.dart';
import 'package:incampapp/test.dart';

import 'ecospace.dart';
import 'foodspace.dart';
import 'home.dart';
import 'litpicks.dart';
import 'moodspace.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const Home(),
    const Moodspace(),
    const Ecospace(),
    const Litpicks(),
    const Foodspace(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showStarPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('images/AI.png'),
              const SizedBox(height: 10),
              const Text(
                'Created with ❤️ in IITM',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double simulatedWidth = 375.0;
        double simulatedHeight = 812.0;

        return Center(
          child: Container(
            width: simulatedWidth,
            height: simulatedHeight,
            child: Scaffold(
              appBar: AppBar(
                title: const Text(
                  'iNCAMPus',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    fontFamily: 'MajorMonoDisplay',
                  ),
                ),
                centerTitle: true,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.star),
                    onPressed: _showStarPopup,
                  ),
                ],
              ),
              body: IndexedStack(
                index: _selectedIndex,
                children: _widgetOptions,
              ),
              bottomNavigationBar: BottomNavigationBar(
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.navigation),
                    label: 'Explore',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.earbuds),
                    label: 'Wise Owl',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.energy_savings_leaf),
                    label: 'EcoSpace',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.book),
                    label: 'Litpicks',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.generating_tokens),
                    label: 'BF',
                  ),
                ],
                currentIndex: _selectedIndex,
                selectedItemColor: Colors.blue,
                unselectedItemColor: Colors.grey,
                onTap: _onItemTapped,
              ),
            ),
          ),
        );
      },
    );
  }
}
