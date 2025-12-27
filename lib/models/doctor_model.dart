import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorModel {
  String doctorId;
  String email;
  String fullName;
  String phoneNumber;
  String specialization;
  String qualification;
  int experience;
  double consultationFee;
  List<String> availableDays;
  List<String> availableTimeSlots;
  double rating;
  bool isActive;
  DateTime createdAt;

  DoctorModel({
    required this.doctorId,
    required this.email,
    required this.fullName,
    required this.phoneNumber,
    required this.specialization,
    required this.qualification,
    required this.experience,
    required this.consultationFee,
    required this.availableDays,
    required this.availableTimeSlots,
    required this.rating,
    required this.isActive,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'doctorId': doctorId,
      'email': email,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'specialization': specialization,
      'qualification': qualification,
      'experience': experience,
      'consultationFee': consultationFee,
      'availableDays': availableDays,
      'availableTimeSlots': availableTimeSlots,
      'rating': rating,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory DoctorModel.fromMap(Map<String, dynamic> map, String documentId) {
    return DoctorModel(
      doctorId: documentId,
      email: map['email'] ?? '',
      fullName: map['fullName'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      specialization: map['specialization'] ?? '',
      qualification: map['qualification'] ?? '',
      experience: map['experience'] ?? 0,
      consultationFee: (map['consultationFee'] ?? 0).toDouble(),
      availableDays: List<String>.from(map['availableDays'] ?? []),
      availableTimeSlots: List<String>.from(map['availableTimeSlots'] ?? []),
      rating: (map['rating'] ?? 0).toDouble(),
      isActive: map['isActive'] ?? true,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
}
