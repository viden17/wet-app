import 'package:flutter/material.dart';

class VetCard extends StatelessWidget {
  final String name;
  final String location;
  final double rating;
  final String distance;

  const VetCard({super.key,
    required this.name,
    required this.location,
    required this.rating,
    required this.distance,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(Icons.location_on, color: Colors.blue),
        title: Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(location),
            SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.star, color: Colors.orange, size: 18),
                SizedBox(width: 4),
                Text("$rating"),
                SizedBox(width: 10),
                Text(distance),
              ],
            ),
          ],
        ),
        trailing: Icon(Icons.arrow_forward),
      ),
    );
  }
}