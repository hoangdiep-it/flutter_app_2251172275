import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faker/faker.dart';
import 'package:intl/intl.dart';
import '../models/doctor_model.dart';
import '../models/patient_model.dart';
import '../models/appointment_model.dart';
import 'dart:math';

class FakerData {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 1. Tạo dữ liệu cho Bác sĩ
  static Future<void> seedDoctors() async {
    final faker = Faker();
    final random = Random();
    final specializations = ["Cardiology", "Dermatology", "Pediatrics", "Orthopedics", "General"];
    final days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"];
    final times = ["08:00", "09:00", "10:00", "11:00", "14:00", "15:00", "16:00"];

    for (int i = 0; i < 10; i++) {
      String id = _firestore.collection('doctors').doc().id;
      List<String> selectedDays = (List.from(days)..shuffle()).take(3).toList().cast<String>();
      List<String> selectedTimes = (List.from(times)..shuffle()).take(4).toList().cast<String>();

      DoctorModel doctor = DoctorModel(
        doctorId: id,
        email: faker.internet.email(),
        fullName: "Dr. ${faker.person.name()}",
        phoneNumber: faker.phoneNumber.us(),
        specialization: specializations[random.nextInt(specializations.length)],
        qualification: "Chuyên khoa II",
        experience: random.nextInt(15) + 5,
        consultationFee: (random.nextInt(100) + 50).toDouble(),
        availableDays: selectedDays,
        availableTimeSlots: selectedTimes,
        rating: double.parse((random.nextDouble() * 1.5 + 3.5).toStringAsFixed(1)),
        isActive: true,
        createdAt: DateTime.now(),
      );
      await _firestore.collection('doctors').doc(id).set(doctor.toMap());
    }
  }

  // 2. Tạo dữ liệu cho Bệnh nhân
  static Future<void> seedPatients() async {
    final faker = Faker();
    final random = Random();
    final bloodTypes = ["A", "B", "AB", "O"];
    
    PatientModel testPatient = PatientModel(
      patientId: "patient_123",
      email: "test@gmail.com",
      fullName: "Nguyễn Văn Test",
      phoneNumber: "0901234567",
      dateOfBirth: DateTime(1995, 5, 20),
      gender: "male",
      address: "123 Đường ABC, TP.HCM",
      bloodType: "O",
      allergies: ["Bụi", "Hải sản"],
      emergencyContact: "0909999999",
      createdAt: DateTime.now(),
    );
    await _firestore.collection('patients').doc("patient_123").set(testPatient.toMap());

    for (int i = 0; i < 4; i++) {
      String id = _firestore.collection('patients').doc().id;
      PatientModel patient = PatientModel(
        patientId: id,
        email: faker.internet.email(),
        fullName: faker.person.name(),
        phoneNumber: faker.phoneNumber.us(),
        dateOfBirth: DateTime(1980 + random.nextInt(30), 1, 1),
        gender: random.nextBool() ? "male" : "female",
        address: faker.address.streetAddress(),
        bloodType: bloodTypes[random.nextInt(bloodTypes.length)],
        allergies: ["Phấn hoa"],
        emergencyContact: faker.phoneNumber.us(),
        createdAt: DateTime.now(),
      );
      await _firestore.collection('patients').doc(id).set(patient.toMap());
    }
  }

  // 3. Tạo dữ liệu cho Lịch hẹn
  static Future<void> seedAppointments() async {
    final random = Random();
    final statuses = ["scheduled", "confirmed", "completed"];
    
    QuerySnapshot doctorSnaps = await _firestore.collection('doctors').get();
    if (doctorSnaps.docs.isEmpty) return;

    Set<String> usedSlots = {};

    for (int i = 0; i < 5; i++) {
      var doctorDoc = doctorSnaps.docs[random.nextInt(doctorSnaps.docs.length)];
      DoctorModel doctor = DoctorModel.fromMap(doctorDoc.data() as Map<String, dynamic>, doctorDoc.id);

      DateTime? appointmentDate;
      for (int dayOffset = 1; dayOffset <= 10; dayOffset++) {
        DateTime targetDate = DateTime.now().add(Duration(days: dayOffset));
        String dayName = DateFormat('EEEE').format(targetDate);
        if (doctor.availableDays.contains(dayName)) {
          appointmentDate = targetDate;
          break;
        }
      }

      if (appointmentDate == null) continue;

      String timeSlot = doctor.availableTimeSlots[random.nextInt(doctor.availableTimeSlots.length)];
      String dateStr = DateFormat('yyyy-MM-dd').format(appointmentDate);
      String slotKey = "${doctor.doctorId}_${dateStr}_$timeSlot";

      if (usedSlots.contains(slotKey)) continue;
      usedSlots.add(slotKey);

      String id = _firestore.collection('appointments').doc().id;
      String status = statuses[random.nextInt(statuses.length)];

      AppointmentModel appointment = AppointmentModel(
        appointmentId: id,
        patientId: "patient_123",
        doctorId: doctor.doctorId, // Đã sửa: Lưu ID
        doctorName: doctor.fullName, // Đã sửa: Lưu Tên
        appointmentDate: appointmentDate,
        appointmentTime: timeSlot,
        reason: i % 2 == 0 ? "Đau họng kéo dài" : "Khám sức khỏe tổng quát",
        status: status,
        diagnosis: status == "completed" ? "Viêm họng cấp" : null,
        prescription: status == "completed" ? "Amoxicillin 500mg x 10 viên" : null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _firestore.collection('appointments').doc(id).set(appointment.toMap());
    }
  }

  static Future<void> seedAll() async {
    await seedDoctors();
    await seedPatients();
    await seedAppointments();
  }
}
