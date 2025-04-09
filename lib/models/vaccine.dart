import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Vaccine {
  final String id; // Firestore will auto-generate this
  final String name;
  final String type;
  final DateTime administeredDate;
  final DateTime expiredDate;
  final double weight;
  final String vetName;
  final String vetPhoneNumber;
  final String userId; // Added userId

  Vaccine({
    this.id = '',
    required this.name,
    required this.type,
    required this.administeredDate,
    required this.expiredDate,
    required this.weight,
    required this.vetName,
    required this.vetPhoneNumber,
    this.userId = '', // Added userId
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'type': type,
      'administeredDate': administeredDate,
      'expiredDate': expiredDate,
      'weight': weight,
      'vetName': vetName,
      'vetPhoneNumber': vetPhoneNumber,
      'userId': userId, // Added userId to map
    };
  }

  factory Vaccine.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    DateTime administeredDate = (data['administeredDate'] as Timestamp).toDate();
    DateTime expiredDate = (data['expiredDate'] as Timestamp).toDate();
    return Vaccine(
      id: doc.id, // Firestore auto-generates the id
      name: data['name'],
      type: data['type'],
      administeredDate: administeredDate,
      expiredDate: expiredDate,
      weight: data['weight'],
      vetName: data['vetName'],
      vetPhoneNumber: data['vetPhoneNumber'],
      userId: data['userId'], // Added userId field
    );
  }
}

class VaccineControllers {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addVaccine(Vaccine vaccine) async {
    // Get the current user's ID from Firebase Auth
    String userId = _auth.currentUser!.uid;
    String newId = _firestore.collection('medical_records').doc().id;

    // Add the userId to the vaccine before saving to Firestore
    vaccine = Vaccine(
      id: newId, // Firestore will auto-generate the ID
      name: vaccine.name,
      type: vaccine.type,
      administeredDate: vaccine.administeredDate,
      expiredDate: vaccine.expiredDate,
      weight: vaccine.weight,
      vetName: vaccine.vetName,
      vetPhoneNumber: vaccine.vetPhoneNumber,
      userId: userId, // Set the userId
    );

    // Add vaccine data to Firestore
    await _firestore
        .collection("vaccines")
        .add(vaccine.toMap()); // Use .add to let Firestore generate the ID
  }

  Future<void> deleteVaccine(String id) async {
    await _firestore.collection("vaccines").doc(id).delete();
  }

  Stream<List<Vaccine>> getAllVaccines() {
    return _firestore
        .collection("vaccines")
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Vaccine.fromDocument(doc))
            .toList());
  }

  // Get all vaccines for a particular userId
  Stream<List<Vaccine>> getVaccinesByUserId(String userId) {
    return _firestore
        .collection("vaccines")
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Vaccine.fromDocument(doc))
            .toList());
  }
}
