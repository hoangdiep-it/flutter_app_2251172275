import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentModel {
  String appointmentId;
  String patientId;
  String doctorId;
  String doctorName; // Thêm trường này
  DateTime appointmentDate;
  String appointmentTime;
  String reason;
  String status;
  String? diagnosis;
  String? prescription;
  String? notes;
  DateTime createdAt;
  DateTime updatedAt;

  AppointmentModel({
    required this.appointmentId,
    required this.patientId,
    required this.doctorId,
    required this.doctorName,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.reason,
    required this.status,
    this.diagnosis,
    this.prescription,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'appointmentId': appointmentId,
      'patientId': patientId,
      'doctorId': doctorId,
      'doctorName': doctorName,
      'appointmentDate': Timestamp.fromDate(appointmentDate),
      'appointmentTime': appointmentTime,
      'reason': reason,
      'status': status,
      'diagnosis': diagnosis,
      'prescription': prescription,
      'notes': notes,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  factory AppointmentModel.fromMap(Map<String, dynamic> map, String documentId) {
    return AppointmentModel(
      appointmentId: documentId,
      patientId: map['patientId'] ?? '',
      doctorId: map['doctorId'] ?? '',
      doctorName: map['doctorName'] ?? 'Bác sĩ', // Mặc định nếu thiếu
      appointmentDate: (map['appointmentDate'] as Timestamp).toDate(),
      appointmentTime: map['appointmentTime'] ?? '',
      reason: map['reason'] ?? '',
      status: map['status'] ?? 'scheduled',
      diagnosis: map['diagnosis'],
      prescription: map['prescription'],
      notes: map['notes'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
    );
  }
}
