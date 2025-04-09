import 'package:flutter/material.dart';
import 'package:project_one/widgets/bottom_nav_bar.dart';

class DummyPage extends StatelessWidget {
  const DummyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text('Dummy Screen'),
      ),
      body: Center(
        child: Text('This is a dummy screen.'),
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 0, onTap: (index) {
        // Handle bottom navigation tap
        Text('Tapped on index: $index');
      }),
    );
  }
}