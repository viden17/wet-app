import 'package:flutter/material.dart';
import 'package:project_one/screens/find_vet_screen.dart';
import 'package:project_one/screens/medical_records_screen.dart';
import 'package:project_one/screens/profile_screen.dart';
import 'package:project_one/screens/vaccinations_screen.dart';
import 'package:iconsax/iconsax.dart';

import '../theme/colors.dart';


class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int _selectedIndex = 0;
  final _views = const <Widget>[
          ProfileScreen(),
          MedicalRecordsScreen(),
          VaccinationsScreen(),
          FindVetScreen(),
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
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBars[_selectedIndex],
      body: _views[_selectedIndex],
      bottomNavigationBar: Stack(
        alignment: Alignment.topCenter,
        children: [
          BottomNavigationBar(
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
            ],
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
          ],
      ),
    );
  }
}