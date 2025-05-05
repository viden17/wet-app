import 'package:flutter/material.dart';
import 'package:project_one/screens/find_vet_screen.dart';
import 'package:project_one/screens/medical_records_screen.dart';

import 'package:project_one/screens/profile_screen.dart';
import 'package:project_one/screens/vaccinations_screen.dart';
import 'package:project_one/screens/dog_food_center_screen.dart';
import 'package:project_one/screens/channel_doctor_screen.dart';
import 'package:iconsax/iconsax.dart';

import '../theme/colors.dart';


class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int _selectedIndex = 0;
  final _views = <Widget>[
    ProfileScreen(),
    MedicalRecordsScreen(),
    VaccinationsScreen(),
    FindvetScreen(),
    
    ChannelDoctorScreen(),
    DogFoodStoreScreen(),
  ];
  final _appBars = <AppBar>[
    AppBar(
      title: const Text('Profile'),
      centerTitle: true,
    ),
    AppBar(
      title: const Text('Medical Records'),
      centerTitle: true,
    ),
    AppBar(
      title: const Text('Vaccinations'),
      centerTitle: true,
    ),
    AppBar(
      title: const Text('Find Vet'),
      centerTitle: true,
    ),
    AppBar(
      title: const Text('Dog Food Center'), // Added AppBar for Dog Food Center
      centerTitle: true,
    ),
    AppBar(
      title: const Text('Channel Doctor'), // Added AppBar for Channel Doctor
      centerTitle: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBars[_selectedIndex],
      body: _views[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.blue,
        unselectedItemColor: AppColors.black.shade400,
        elevation: 12,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Iconsax.home_2),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.link_1),
            label: 'Links',
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.dollar_circle),
            label: 'Payme',
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.wallet),
            label: 'Wallet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pets),
            label: 'Dog Food', // Added Dog Food Center
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_hospital),
            label: 'Doctor', // Added Channel Doctor
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}