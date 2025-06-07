import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';



import 'package:project_one/screens/auth_page.dart';
  // Import the AuthPage

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();  // Initialize Firebase
  runApp(PetCareBuddyApp());  // Start the appf
}

class PetCareBuddyApp extends StatelessWidget {
  const PetCareBuddyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PetCare Buddy',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:AuthPage(),  // Start with the AuthPage
    );
  }
}
