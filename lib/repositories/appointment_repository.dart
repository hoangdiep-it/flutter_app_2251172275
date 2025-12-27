import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../models/appointment_model.dart';
import '../models/doctor_model.dart';
import '../services/firebase_service.dart';

class AppointmentRepository {
  // Sử dụng Service Class thay vì gọi trực tiếp Firestore instance
  final FirebaseService _firebaseService = FirebaseService();

  Future<void> createAppointment(String patientId, String doctorId,
      DateTime appointmentDate, String time, String reason) async {
    
    DocumentSnapshot docSnap = await _firebaseService.doctors.doc(doctorId).get();
    if (!docSnap.exists) throw Exception('Không tìm thấy thông tin bác sĩ');
    
    DoctorModel doctor = DoctorModel.fromMap(docSnap.data() as Map<String, dynamic>, docSnap.id);
    
    String dayName = DateFormat('EEEE').format(appointmentDate);
    if (!doctor.availableDays.contains(dayName)) {
      throw Exception('Bác sĩ không có lịch làm việc vào ngày này');
    }
    
    if (!doctor.availableTimeSlots.contains(time)) {
      throw Exception('Khung giờ $time không nằm trong lịch làm việc của bác sĩ');
    }

    DateTime startOfDay = DateTime(appointmentDate.year, appointmentDate.month, appointmentDate.day);
    DateTime endOfDay = startOfDay.add(const Duration(days: 1));

    QuerySnapshot existingAppts = await _firebaseService.appointments
        .where('doctorId', isEqualTo: doctorId)
        .where('appointmentDate', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('appointmentDate', isLessThan: Timestamp.fromDate(endOfDay))
        .where('appointmentTime', isEqualTo: time)
        .where('status', whereIn: ['scheduled', 'confirmed'])
        .get();

    if (existingAppts.docs.isNotEmpty) {
      throw Exception('Khung giờ này bác sĩ đã có lịch hẹn khác. Vui lòng chọn giờ khác.');
    }

    String appointmentId = _firebaseService.appointments.doc().id;
    AppointmentModel newAppt = AppointmentModel(
      appointmentId: appointmentId,
      patientId: patientId,
      doctorId: doctorId,
      doctorName: doctor.fullName,
      appointmentDate: appointmentDate,
      appointmentTime: time,
      reason: reason,
      status: 'scheduled',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _firebaseService.appointments.doc(appointmentId).set(newAppt.toMap());
  }

  Future<void> cancelAppointment(String appointmentId) async {
    await _firebaseService.appointments.doc(appointmentId).update({
      'status': 'cancelled',
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    });
  }

  Future<List<AppointmentModel>> getAppointmentsByPatient(String patientId) async {
    QuerySnapshot querySnapshot = await _firebaseService.appointments
        .where('patientId', isEqualTo: patientId)
        .orderBy('appointmentDate', descending: true)
        .get();
    return querySnapshot.docs
        .map((doc) => AppointmentModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }
}
