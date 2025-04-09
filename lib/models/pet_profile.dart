// pet_profile_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PetProfileModel {
  String name;
  String type;
  String breed;
  int age;
  String birthday;
  double weight;
  double height;

  PetProfileModel({
    required this.name,
    required this.breed,
    required this.type,
    required this.age,
    required this.birthday,
    required this.weight,
    required this.height,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'breed': breed,
      'age': age,
      'birthday': birthday,
      'weight': weight,
      'height': height,
      'type': type,
    };
  }

  factory PetProfileModel.fromMap(Map<String, dynamic> map) {
    return PetProfileModel(
      name: map['name'] ?? '',
      breed: map['breed'] ?? '',
      type: map['type'] ?? '',
      age: map['age'] ?? 0,
      birthday: map['birthday'] ?? '',
      weight: map['weight']?.toDouble() ?? 0.0,
      height: map['height']?.toDouble() ?? 0.0,
    );
  }
}

class PetProfileController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<PetProfileModel?> getPetProfile() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('pets').doc(user.uid).get();
      if (userDoc.exists) {
        return PetProfileModel.fromMap(userDoc.data() as Map<String, dynamic>);
      }
    }
    return null;
  }

  Future<void> savePetProfile(Map<String, dynamic> petData) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('pets').doc(user.uid).set(petData);
    }
  }

  // Update existing pet profile (partial update)
  Future<void> updatePetProfile(Map<String, dynamic> petData) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('pets').doc(user.uid).update(petData);
    }
  }

  // Helper method to save or update based on whether profile exists
  Future<void> saveOrUpdatePetProfile(Map<String, dynamic> petData) async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('pets').doc(user.uid).get();

      if (userDoc.exists) {
        // Update existing doc
        await _firestore.collection('pets').doc(user.uid).update(petData);
      } else {
        // Create new doc
        await _firestore.collection('pets').doc(user.uid).set(petData);
      }
    }
  }

  Future<bool> isNewUser() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('pets').doc(user.uid).get();
      return !userDoc.exists;
    }
    return false;
  }
}
