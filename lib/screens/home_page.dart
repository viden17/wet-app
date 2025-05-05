import 'package:flutter/material.dart';
import 'package:project_one/screens/channel_doctor_screen.dart';
import 'package:project_one/screens/dog_food_center_screen.dart';
import 'package:project_one/screens/find_vet_screen.dart';
import 'package:project_one/screens/medical_records_screen.dart';

import 'package:project_one/screens/profile_screen.dart';
import 'package:project_one/screens/vaccinations_screen.dart';
import 'package:project_one/widgets/bottom_nav_bar.dart';
import 'package:project_one/screens/chat_bot_screen.dart';

class HomeScreen extends StatefulWidget {
  final int initialIndex;

  const HomeScreen({this.initialIndex = 0, super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _selectedIndex;
  late PageController _pageController;

  Future<void> _onItemTapped(int index) async {
    setState(() {
      _selectedIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
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
          FindvetScreen(),
    
          DogFoodStoreScreen(),
          ChannelDoctorScreen()
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showChatBotDialog,
        child: const Icon(Icons.chat_bubble_outline),
      ),
    );
  }

  void _showChatBotDialog() {
  showDialog(
    context: context,
    barrierDismissible: true, // Allow close by tapping outside
    builder: (context) => Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40), // control the padding from screen edges
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        height: 500,
        child: Column(
          children: [
            // Chatbot Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              width: double.infinity,
              child: const Text(
                'Ask PetCare AI Bot',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            // Chat content (chatbot screen inside)
            const Expanded(
              child: ChatBotScreen(),
            ),
          ],
        ),
      ),
    ),
  );
}

}
