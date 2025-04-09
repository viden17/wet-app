import 'package:flutter/material.dart';

class AppointmentCard extends StatelessWidget {
  final String title, date, time, location;

  const AppointmentCard({super.key, 
    required this.title,
    required this.date,
    required this.time,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Colors.teal.shade50, // Soft background color
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Pet Icon
            CircleAvatar(
              backgroundColor: Colors.teal,
              child: Icon(Icons.pets, color: Colors.white),
            ),
            SizedBox(width: 12),
            
            // Appointment Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal.shade900,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "$date at $time",
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                  Text(
                    location,
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),

            // Forward Icon
            Icon(Icons.arrow_forward_ios, color: Colors.teal.shade900, size: 20),
          ],
        ),
      ),
    );
  }
}
