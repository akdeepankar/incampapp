import 'package:flutter/material.dart';
import 'bf.dart';
import 'ecosort.dart';

class Foodspace extends StatelessWidget {
  const Foodspace({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          title: PreferredSize(
            preferredSize: Size.fromHeight(40.0),
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
                          width: 150,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.generating_tokens,
                                  color: Colors.black),
                              SizedBox(width: 2),
                              Text('Budget Friendly',
                                  style: TextStyle(color: Colors.black)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            const Bf(),
          ],
        ),
      ),
    );
  }
}
