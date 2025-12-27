import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  // Khởi tạo các instance của Firestore để dùng chung trong toàn bộ app
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Cung cấp các getter để lấy các collection nhanh chóng
  CollectionReference get patients => _firestore.collection('patients');
  CollectionReference get doctors => _firestore.collection('doctors');
  CollectionReference get appointments => _firestore.collection('appointments');

  // Có thể thêm các hàm dùng chung như kiểm tra kết nối mạng hoặc xử lý lỗi tập trung tại đây
}
