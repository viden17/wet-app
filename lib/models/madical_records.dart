import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MedicalRecord {
  final String virus;
  final String vetName;
  final String type;
  final DateTime date;
  final String purpose;
  final String comment;
  final DateTime expires;
  final String id;
  final String userId;

  MedicalRecord({
    this.id = '',
    required this.virus,
    required this.vetName,
    required this.type,
    required this.date,
    required this.purpose,
    required this.comment,
    required this.expires,
    this.userId = '',
  });

  // Convert a MedicalRecord object to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'virus': virus,
      'vetName': vetName,
      'type': type,
      'date': date.toIso8601String(),
      'purpose': purpose,
      'comment': comment,
      'expires': expires.toIso8601String(),
      'userId': userId,
    };
  }

  // Convert Firestore document data into a MedicalRecord object
  factory MedicalRecord.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;

    if (data == null) {
      throw Exception("Document data is null");
    }

    return MedicalRecord(
      id: doc.id, // Use Firestore document ID
      virus: data['virus'] ?? '',
      vetName: data['vetName'] ?? '',
      type: data['type'] ?? '',
      date: DateTime.tryParse(data['date'] ?? '') ?? DateTime.now(),
      purpose: data['purpose'] ?? '',
      comment: data['comment'] ?? '',
      expires: DateTime.tryParse(data['expires'] ?? '') ?? DateTime.now(),
      userId: data['userId'] ?? '',
    );
  }
}

class MedicalRecordController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Add a new record to Firestore
  Future<void> addRecord(MedicalRecord record) async {
    User? user = _auth.currentUser;
    if (user == null) return;

    String newId = _firestore.collection('medical_records').doc().id;

    MedicalRecord newRecord = MedicalRecord(
      id: newId, // Firestore will generate the ID
      virus: record.virus,
      vetName: record.vetName,
      type: record.type,
      date: record.date,
      purpose: record.purpose,
      comment: record.comment,
      expires: record.expires,
      userId: user.uid, // Assign logged-in user’s ID
    );

    await _firestore.collection('medical_records').doc(newId).set(newRecord.toMap());
  }

  // Get all medical records for the current user as a stream from Firestore
  Stream<List<MedicalRecord>> getUserMedicalRecords() {
    User? user = _auth.currentUser;
    if (user == null) return const Stream.empty();

    return _firestore
        .collection('medical_records')
        .where('userId', isEqualTo: user.uid)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => MedicalRecord.fromFirestore(doc)).toList());
  }

  // Update an existing record in Firestore
  Future<void> updateRecord(String recordId, MedicalRecord updatedRecord) async {
    await _firestore.collection('medical_records').doc(recordId).update(updatedRecord.toMap());
  }

  // Delete a record from Firestore
  Future<void> deleteRecord(String recordId) async {
    await _firestore.collection('medical_records').doc(recordId).delete();
  }
}
