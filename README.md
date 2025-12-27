# Hệ Thống Quản Lý Phòng Khám - MSSV: 2251172275

Ứng dụng Flutter quản lý đặt lịch khám bệnh tích hợp Firebase Firestore, được xây dựng theo kiến trúc Repository Pattern chuẩn.

## 🚀 Tính Năng Chính

*   **Quản lý Bệnh nhân**: Đăng ký thông tin đầy đủ (họ tên, ngày sinh, nhóm máu, đa lựa chọn dị ứng...).
*   **Danh sách Bác sĩ Real-time**: Hiển thị danh sách bác sĩ trực tuyến, hỗ trợ tìm kiếm theo tên và lọc theo chuyên khoa (Tim mạch, Nhi khoa, Da liễu...).
*   **Đặt lịch hẹn thông minh**: 
    *   Chọn ngày và khung giờ khám linh hoạt.
    *   **Validation**: Tự động kiểm tra trùng lịch, kiểm tra lịch làm việc của bác sĩ.
    *   Ngăn chặn đặt lịch trong quá khứ.
*   **Lịch hẹn của tôi**:
    *   Theo dõi danh sách lịch hẹn cá nhân.
    *   Phân loại màu sắc theo trạng thái (Đã đặt, Đã xác nhận, Hoàn thành, Đã hủy).
    *   Xem kết quả chẩn đoán và đơn thuốc sau khi khám xong.
*   **Dữ liệu mẫu (Seed Data)**: Tích hợp công cụ tạo tự động 10 bác sĩ và bệnh nhân mẫu để kiểm thử nhanh.

## 📁 Cấu Trúc Thư Mục (Kiến Trúc Repository)

```text
lib/
├── models/         # Định nghĩa các lớp dữ liệu (Patient, Doctor, Appointment)
├── repositories/   # Xử lý logic nghiệp vụ và tương tác Firestore (CRUD, Validation)
├── services/       # Lớp Service Class quản lý tài nguyên Firebase tập trung
├── screens/        # Giao diện người dùng (Login, Register, Booking, List...)
├── utils/          # Công cụ hỗ trợ (Faker Data để tạo dữ liệu mẫu)
└── main.dart       # Điểm khởi đầu ứng dụng & Cấu hình Firebase
```

## 🛠 Công Nghệ Sử Dụng

*   **Framework**: Flutter
*   **Database**: Firebase Firestore (Real-time DB)
*   **Thư viện chính**:
    *   `firebase_core`, `cloud_firestore`: Kết nối Firebase.
    *   `intl`: Định dạng ngày tháng & Tiếng Việt.
    *   `faker`: Tạo dữ liệu kiểm thử ngẫu nhiên.
    *   `shared_preferences`: Lưu trạng thái (nếu có).

## ⚙️ Hướng Dẫn Cài Đặt

1.  **Cài đặt thư viện**:
    ```bash
    flutter pub get
    ```

2.  **Cấu hình Firebase**:
    *   Đặt tệp `google-services.json` vào thư mục `android/app/`.
    *   Đảm bảo `applicationId` trong `android/app/build.gradle.kts` khớp với cấu hình trên Firebase Console.

3.  **Tạo Chỉ mục (Index) Firestore**:
    *   Khi chạy ứng dụng lần đầu, nếu gặp lỗi `failed-precondition`, hãy nhấn vào liên kết trong log console để tạo **Composite Index** trên Firebase (cần thiết cho chức năng lọc lịch hẹn).

## 📖 Hướng Dẫn Sử Dụng

1.  **Đăng nhập**: Sử dụng Email để đăng nhập (Hệ thống sẽ lấy email này làm mã định danh người dùng).
2.  **Tạo dữ liệu mẫu**: 
    *   Trên màn hình danh sách bác sĩ, nhấn vào biểu tượng **(+)** ở góc trên bên phải.
    *   Hệ thống sẽ tự động tạo 10 bác sĩ, bệnh nhân và lịch hẹn mẫu.
3.  **Đặt lịch**: Chọn một bác sĩ -> Nhấn "Đặt lịch hẹn ngay" -> Chọn ngày/giờ -> Nhập lý do -> Xác nhận.
4.  **Xem lịch sử**: Nhấn vào biểu tượng **Đồng hồ (History)** trên màn hình chính để theo dõi các lịch đã đặt và kết quả khám.

## 📝 Yêu Cầu Kỹ Thuật Đã Đạt Được

- [x] Tổ chức code theo cấu trúc Repository & Service Class chuẩn.
- [x] Quản lý trạng thái bằng StreamBuilder (Reactive UI).
- [x] Xử lý lỗi (Error Handling) và thông báo Tiếng Việt 100%.
- [x] UI/UX hiện đại, mượt mà, hỗ trợ tốt trải nghiệm người dùng.

---
**MSSV**: 2251172275  
**Project**: Clinic Management System Demo
