import 'package:flutter/material.dart';

class ChannelDoctorScreen extends StatelessWidget {
  final List<Map<String, String>> doctors = [
  {
    'name': 'Dr. John Doe',
    'specialty': 'Veterinary Surgeon',
    'place': 'PetCare Clinic, Colombo',
    'availableTime': '9:00 AM - 1:00 PM'
  },
  {
    'name': 'Dr. Jane Smith',
    'specialty': 'Animal Nutritionist',
    'place': 'HealthyPets Center, Kandy',
    'availableTime': '10:00 AM - 2:00 PM'
  },
  {
    'name': 'Dr. Emily Johnson',
    'specialty': 'Pet Behaviorist',
    'place': 'Happy Tails Vet, Galle',
    'availableTime': '1:00 PM - 5:00 PM'
  },
  {
    'name': 'Dr. Michael Brown',
    'specialty': 'Exotic Animal Specialist',
    'place': 'WildCare Vets, Nuwara Eliya',
    'availableTime': '2:00 PM - 6:00 PM'
  },
  {
    'name': 'Dr. Sarah Davis',
    'specialty': 'Emergency Veterinarian',
    'place': 'Animal ER, Kurunegala',
    'availableTime': '24 Hours'
  },
  {
    'name': 'Dr. David Wilson',
    'specialty': 'Orthopedic Veterinarian',
    'place': 'BoneCare Clinic, Anuradhapura',
    'availableTime': '8:00 AM - 12:00 PM'
  },
  {
    'name': 'Dr. Laura Martinez',
    'specialty': 'Dermatology Specialist',
    'place': 'SkinVet, Jaffna',
    'availableTime': '10:00 AM - 3:00 PM'
  },
  {
    'name': 'Dr. James Anderson',
    'specialty': 'Cardiology Specialist',
    'place': 'Heart4Pets, Negombo',
    'availableTime': '9:30 AM - 12:30 PM'
  },
  {
    'name': 'Dr. Linda Thomas',
    'specialty': 'Oncology Specialist',
    'place': 'CancerCare Vets, Matara',
    'availableTime': '11:00 AM - 4:00 PM'
  },
  {
    'name': 'Dr. Robert Taylor',
    'specialty': 'General Practitioner',
    'place': 'VetOne, Ratnapura',
    'availableTime': '9:00 AM - 5:00 PM'
  },
];


  Widget buildStarRating() {
    return Row(
      children: List.generate(
        5,
        (index) => Icon(
          Icons.star,
          size: 16,
          color: Colors.amber,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Channel Doctors",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF4CAF50),
        centerTitle: true,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: ListView.builder(
        itemCount: doctors.length,
        itemBuilder: (context, index) {
          final doctor = doctors[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/images/doctor_one.jpeg'),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          doctor['name']!,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          doctor['specialty']!,
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        SizedBox(height: 4),
                        buildStarRating(),
                        SizedBox(height: 4),
                        Text(
                          'Place: ${doctor['place']}',
                          style: TextStyle(color: Colors.grey[600], fontSize: 13),
                        ),
                        Text(
                          'Available: ${doctor['availableTime']}',
                          style: TextStyle(color: Colors.grey[600], fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Channel request sent to ${doctor['name']}'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text("Channel" , style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500 ,color: Colors.white,), ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
     
    );
  }
}
