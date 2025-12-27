import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/doctor_model.dart';

class DoctorRepository {
  final CollectionReference _doctorCollection =
      FirebaseFirestore.instance.collection('doctors');
  final CollectionReference _appointmentCollection =
      FirebaseFirestore.instance.collection('appointments');

  // 1. Thêm Doctor
  Future<void> addDoctor(DoctorModel doctor) async {
    await _doctorCollection.doc(doctor.doctorId).set(doctor.toMap());
  }

  // 2. Lấy Doctor theo ID
  Future<DoctorModel?> getDoctorById(String doctorId) async {
    DocumentSnapshot doc = await _doctorCollection.doc(doctorId).get();
    if (doc.exists) {
      return DoctorModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }
    return null;
  }

  // 3. Lấy tất cả Doctors
  Future<List<DoctorModel>> getAllDoctors() async {
    QuerySnapshot querySnapshot = await _doctorCollection.get();
    return querySnapshot.docs
        .map((doc) => DoctorModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  // 4. Tìm kiếm Doctors (theo name hoặc specialization)
  Future<List<DoctorModel>> searchDoctors(String query) async {
    // Lưu ý: Firestore không hỗ trợ tìm kiếm full-text mạnh mẽ, 
    // ở đây sử dụng logic đơn giản hoặc query theo trường cụ thể
    QuerySnapshot querySnapshot = await _doctorCollection
        .where('fullName', isGreaterThanOrEqualTo: query)
        .where('fullName', isLessThanOrEqualTo: '$query\uf8ff')
        .get();
    
    return querySnapshot.docs
        .map((doc) => DoctorModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  // 5. Lọc Doctors theo Specialization
  Future<List<DoctorModel>> filterBySpecialization(String specialization) async {
    QuerySnapshot querySnapshot = await _doctorCollection
        .where('specialization', isEqualTo: specialization)
        .get();
    
    return querySnapshot.docs
        .map((doc) => DoctorModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  // 6. Lấy Doctors Available trong Time Slot
  // date format: "Monday", "Tuesday", etc. hoặc check dựa trên ngày cụ thể
  Future<List<DoctorModel>> getAvailableDoctors(String dayOfWeek, String time) async {
    // Bước 1: Lấy các bác sĩ có làm việc trong ngày và giờ đó
    QuerySnapshot doctorsSnapshot = await _doctorCollection
        .where('availableDays', arrayContains: dayOfWeek)
        .where('isActive', isEqualTo: true)
        .get();

    List<DoctorModel> allQualifiedDoctors = doctorsSnapshot.docs
        .map((doc) => DoctorModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .where((doctor) => doctor.availableTimeSlots.contains(time))
        .toList();

    // Bước 2: Kiểm tra xem bác sĩ đã có lịch hẹn nào trùng chưa (đây là logic tối giản)
    // Thực tế cần kiểm tra thêm bảng appointments cho ngày cụ thể đó
    return allQualifiedDoctors;
  }
}
