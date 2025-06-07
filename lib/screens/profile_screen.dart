import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:project_one/screens/landing_page.dart';
import 'package:project_one/models/pet_profile.dart';
import 'package:project_one/widgets/pet_edit_form.dart';
import 'package:project_one/widgets/pet_profile_form.dart'; // Import your form
import 'package:project_one/widgets/buildProfilePicture.dart'; // Import your list
import 'package:restart_app/restart_app.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final PetProfileController _controller = PetProfileController();
  bool _isDisposed = false;
  bool _isLoading = true;
  bool _isNewUser = true;
  PetProfileModel? _petProfile;

  // Add this to the state
  String _selectedLanguage = 'Sinhala';

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _checkUserStatus();
  }

  Future<void> _checkUserStatus() async {
    bool isNew = await _controller.isNewUser();
    PetProfileModel? profile = await _controller.getPetProfile();
    if (_isDisposed) return; // Prevent calling setState on a disposed widget

    setState(() {
      _isNewUser = isNew;
      _petProfile = profile;
      _isLoading = false;
    });
  }

  Future<void> _saveProfile(Map<String, dynamic> petData) async {
    await _controller.savePetProfile(petData);
    _checkUserStatus(); // Reload profile after saving
  }

  Widget _buildProfileView() {
    return CustomScrollView(
      slivers: [
        _buildAppBar(),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
               ProfilePicture(),
                const SizedBox(height: 16),
                Text(
                  "Name: ${_petProfile!.name}",
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                _buildBreedTag(),
                const SizedBox(height: 30),
                _buildBasicInfoCard(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 100,
      pinned: true,
      backgroundColor: Colors.green[600],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      flexibleSpace: FlexibleSpaceBar(
        title: const Text(
          "Pet Profile",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.green[400]!, Colors.green[800]!],
            ),
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
        ),
        centerTitle: true,
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.edit_rounded, color: Colors.white),
          onPressed: () async {
            final PetProfileController controller = PetProfileController();
            final petProfile = await controller.getPetProfile();

            if (petProfile != null) {
              _showEditDialog(context, petProfile);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Could not load pet profile data.'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }, // Add edit logic
        ),
 
        IconButton(
          icon: const Icon(Icons.pets_rounded, color: Colors.white),
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            Fluttertoast.showToast(
              msg: "Logged out successfully",
              backgroundColor: Colors.green,
              textColor: Colors.white,
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LandingPage()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildBreedTag() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.green[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        "Breed: ${_petProfile!.breed}",
        style: const TextStyle(
          color: Colors.green,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildBasicInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            spreadRadius: 5,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline_rounded, color: Colors.green[600]),
              const SizedBox(width: 10),
              const Text(
                "Basic Information",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            icon: Icons.cake_rounded,
            title: "Age & Birthday",
            value: "${_petProfile!.age} - ${_petProfile!.birthday}",
          ),
          _buildInfoRow(
            icon: Icons.fitness_center_rounded,
            title: "Weight",
            value: "${_petProfile!.weight} kg",
          ),
          _buildInfoRow(
            icon: Icons.height_rounded,
            title: "Height",
            value: "${_petProfile!.height} cm",
            showDivider: false,
          ),
          const SizedBox(height: 30),
          // Settings Section
          Row(
            children: [
              Icon(Icons.settings, color: Colors.green[600]),
              const SizedBox(width: 10),
              const Text(
                "Settings",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            "Languages",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedLanguage = 'Sinhala';
                  });
                  Fluttertoast.showToast(msg: 'Sinhala selected', backgroundColor: Colors.green, textColor: Colors.white);
                },
                child: Chip(
                  label: Text('Sinhala', style: TextStyle(color: _selectedLanguage == 'Sinhala' ? Colors.white : Colors.black)),
                  backgroundColor: _selectedLanguage == 'Sinhala' ? Colors.green : Colors.greenAccent,
                ),
              ),
              SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedLanguage = 'Tamil';
                  });
                  Fluttertoast.showToast(msg: 'Tamil selected', backgroundColor: Colors.green, textColor: Colors.white);
                },
                child: Chip(
                  label: Text('Tamil', style: TextStyle(color: _selectedLanguage == 'Tamil' ? Colors.white : Colors.black)),
                  backgroundColor: _selectedLanguage == 'Tamil' ? Colors.green : Colors.greenAccent,
                ),
              ),
              SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedLanguage = 'English';
                  });
                  Fluttertoast.showToast(msg: 'English selected', backgroundColor: Colors.green, textColor: Colors.white);
                },
                child: Chip(
                  label: Text('English', style: TextStyle(color: _selectedLanguage == 'English' ? Colors.white : Colors.black)),
                  backgroundColor: _selectedLanguage == 'English' ? Colors.green : Colors.greenAccent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String value,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.green[600]),
            const SizedBox(width: 10),
            Text(title),
            const SizedBox(width: 10),
            Text(value),
          ],
        ),
        if (showDivider) const Divider(height: 1),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body:
          _isLoading
              ? const Center(
                child: CircularProgressIndicator(),
              ) // Show loading indicator
              : _isNewUser
              ? PetProfileForm(onSave: _saveProfile) // Show form if new user
              : _petProfile == null
              ? const Center(child: Text("No pet profile available"))
              : _buildProfileView(),
    );
  }
}


void _showEditDialog(BuildContext parentContext, PetProfileModel petProfile) {
  showDialog(
    context: parentContext, // Use parentContext here
    builder: (BuildContext context) {
      return PetEditForm(
        onSave: (Map<String, dynamic> petData) async {
          // Get instance of controller
          final PetProfileController controller = PetProfileController();

          // Save updated data to Firebase
          await controller.savePetProfile(petData);
          Fluttertoast.showToast(msg: "Profile updated successfully", backgroundColor: Colors.green, textColor: Colors.white);

          // Use parentContext instead of dialog context
          if (Navigator.of(parentContext).canPop()) {
            Navigator.of(parentContext).pop();
          }
           
        },
        initialData: petProfile,
      );
    },
  );
}
