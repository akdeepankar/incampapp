import 'package:flutter/material.dart';

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
    const Ecospace(),
    const Litpicks(),
    const Foodspace(),
    const Moodspace()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // Simulate a mobile view size (e.g., 375 x 812 for an iPhone X)
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
                    icon: const Icon(Icons.notifications),
                    onPressed: () {},
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
                    icon: Icon(Icons.energy_savings_leaf),
                    label: 'EcoSpace',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.book),
                    label: 'Litpicks',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.fastfood),
                    label: 'BF',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.mood),
                    label: 'Mood',
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
