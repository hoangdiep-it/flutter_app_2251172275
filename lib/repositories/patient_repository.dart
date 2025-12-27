import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/patient_model.dart';

class PatientRepository {
  final CollectionReference _patientCollection =
      FirebaseFirestore.instance.collection('patients');
  final CollectionReference _appointmentCollection =
      FirebaseFirestore.instance.collection('appointments');

  Future<void> addPatient(PatientModel patient) async {
    await _patientCollection.doc(patient.patientId).set(patient.toMap());
  }

  Future<PatientModel?> getPatientById(String patientId) async {
    DocumentSnapshot doc = await _patientCollection.doc(patientId).get();
    if (doc.exists) {
      return PatientModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }
    return null;
  }

  Future<List<PatientModel>> getAllPatients() async {
    QuerySnapshot querySnapshot = await _patientCollection.get();
    return querySnapshot.docs
        .map((doc) => PatientModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  Future<void> updatePatient(PatientModel patient) async {
    await _patientCollection.doc(patient.patientId).update(patient.toMap());
  }

  Future<void> deletePatient(String patientId) async {
    QuerySnapshot scheduledAppointments = await _appointmentCollection
        .where('patientId', isEqualTo: patientId)
        .where('status', isEqualTo: 'scheduled')
        .get();

    if (scheduledAppointments.docs.isNotEmpty) {
      throw Exception('Không thể xóa bệnh nhân đang có lịch hẹn đã đặt trước.');
    }

    await _patientCollection.doc(patientId).delete();
  }
}
