import 'package:flutter/material.dart';

import 'book.dart';
import 'research.dart';

class Litpicks extends StatelessWidget {
  const Litpicks({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: PreferredSize(
            preferredSize: Size.fromHeight(50.0),
            child: Container(
              color: Colors.transparent,
              child: Column(
                children: [
                  TabBar(
                    indicator: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blueAccent, Colors.lightBlueAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    indicatorPadding:
                        EdgeInsets.symmetric(horizontal: -4, vertical: 6),
                    tabs: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Container(
                          width: 150, // Adjusted width of the tab container
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.energy_savings_leaf,
                                  color: Colors.black),
                              SizedBox(width: 8),
                              Text('Recommend',
                                  style: TextStyle(color: Colors.black)),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Container(
                          width: 150, // Adjusted width of the tab container
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.assessment, color: Colors.black),
                              SizedBox(width: 8),
                              Text('Research',
                                  style: TextStyle(color: Colors.black)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10), // Add padding below the line
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            Book(),
            Research(),
          ],
        ),
      ),
    );
  }
}
