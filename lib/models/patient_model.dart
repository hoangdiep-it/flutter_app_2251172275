import 'package:cloud_firestore/cloud_firestore.dart';

class PatientModel {
  String patientId;
  String email;
  String fullName;
  String phoneNumber;
  DateTime dateOfBirth;
  String gender;
  String address;
  String? bloodType;
  List<String> allergies;
  String emergencyContact;
  DateTime createdAt;

  PatientModel({
    required this.patientId,
    required this.email,
    required this.fullName,
    required this.phoneNumber,
    required this.dateOfBirth,
    required this.gender,
    required this.address,
    this.bloodType,
    required this.allergies,
    required this.emergencyContact,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'patientId': patientId,
      'email': email,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'dateOfBirth': Timestamp.fromDate(dateOfBirth),
      'gender': gender,
      'address': address,
      'bloodType': bloodType,
      'allergies': allergies,
      'emergencyContact': emergencyContact,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory PatientModel.fromMap(Map<String, dynamic> map, String documentId) {
    return PatientModel(
      patientId: documentId,
      email: map['email'] ?? '',
      fullName: map['fullName'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      dateOfBirth: (map['dateOfBirth'] as Timestamp).toDate(),
      gender: map['gender'] ?? '',
      address: map['address'] ?? '',
      bloodType: map['bloodType'],
      allergies: List<String>.from(map['allergies'] ?? []),
      emergencyContact: map['emergencyContact'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
}
