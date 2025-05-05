import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key, 
    required this.currentIndex, 
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    // Updated colors to match the green theme from the screenshot
    final primaryColor = Colors.green[600]!;
    final secondaryColor = const Color.fromARGB(255, 31, 30, 30);
    final backgroundColor = const Color.fromARGB(255, 232, 224, 224);
    
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(
              index: 0,
              label: "Profile",
              icon: Icons.pets_rounded,
              primaryColor: primaryColor,
              secondaryColor: secondaryColor,
            ),
            _buildNavItem(
              index: 1,
              label: "Medical",
              icon: Icons.medical_services_rounded,
              primaryColor: primaryColor,
              secondaryColor: secondaryColor,
            ),
            _buildNavItem(
              index: 2,
              label: "Vaccines",
              icon: Icons.vaccines_rounded,
              primaryColor: primaryColor,
              secondaryColor: secondaryColor,
            ),
            _buildNavItem(
              index: 3,
              label: "Find Vet",
              icon: Icons.location_on_rounded,
              primaryColor: primaryColor,
              secondaryColor: secondaryColor,
            ),
             _buildNavItem(
              index: 4,
              label: "Dog Food",
              icon: Icons.pets_rounded,
        
              primaryColor: primaryColor,
              secondaryColor: secondaryColor,
            ),
               _buildNavItem(
              index: 5,
              label: "Channel Doctor",
              icon: Icons.local_hospital_rounded,
              primaryColor: primaryColor,
              secondaryColor: secondaryColor,
            ),
                      ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required String label,
    required IconData icon,
    required Color primaryColor,
    required Color secondaryColor,
  }) {
    final isSelected = currentIndex == index;
    
    return InkWell(
      onTap: () => onTap(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Updated icon style to match the screenshot
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: isSelected ? primaryColor : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isSelected ? Colors.white : secondaryColor,
              size: 22,
            ),
          ),
          const SizedBox(height: 4),
          // Small dot indicator instead of text for cleaner look
          if (isSelected)
            Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                color: primaryColor,
                shape: BoxShape.circle,
              ),
            )
          else
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: secondaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
    );
  }
}