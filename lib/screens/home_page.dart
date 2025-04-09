import 'package:flutter/material.dart';
import 'package:project_one/screens/find_vet_screen.dart';
import 'package:project_one/screens/medical_records_screen.dart';
import 'package:project_one/screens/profile_screen.dart';
import 'package:project_one/screens/vaccinations_screen.dart';
import 'package:project_one/widgets/bottom_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  final int initialIndex;

  const HomeScreen({this.initialIndex = 0, super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _selectedIndex;
  late PageController _pageController;

  Future<void> _onItemTapped(int index) async {
    setState(() {
      _selectedIndex = index;
      _pageController.jumpToPage(index); // Navigate to the selected page
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _pageController =
        PageController(initialPage: _selectedIndex); // Proper initialization
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(), // Disable swipe
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          ProfileScreen(),
          MedicalRecordsScreen(),
          VaccinationsScreen(),
          FindVetScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
} 