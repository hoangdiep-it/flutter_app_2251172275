import 'package:flutter/material.dart';
import '../models/doctor_model.dart';
import 'booking_screen.dart';

class DoctorDetailScreen extends StatelessWidget {
  final DoctorModel doctor;
  final String patientId;

  const DoctorDetailScreen({super.key, required this.doctor, required this.patientId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết - 2251172275'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: CircleAvatar(
                radius: 50,
                child: Icon(Icons.person, size: 50),
              ),
            ),
            const SizedBox(height: 20),
            Text(doctor.fullName, style: Theme.of(context).textTheme.headlineMedium),
            Text(doctor.specialization, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.blue)),
            const Divider(height: 30),
            _infoRow(Icons.work, 'Kinh nghiệm', '${doctor.experience} năm'),
            _infoRow(Icons.school, 'Bằng cấp', doctor.qualification),
            _infoRow(Icons.attach_money, 'Phí khám', '\$${doctor.consultationFee}'),
            _infoRow(Icons.star, 'Đánh giá', '${doctor.rating} / 5.0'),
            const SizedBox(height: 20),
            const Text('Ngày làm việc:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Wrap(
              spacing: 8,
              children: doctor.availableDays.map((day) => Chip(label: Text(_translateDay(day)))).toList(),
            ),
            const SizedBox(height: 10),
            const Text('Giờ làm việc:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Wrap(
              spacing: 8,
              children: doctor.availableTimeSlots.map((time) => Chip(label: Text(time), backgroundColor: Colors.green.shade100)).toList(),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, foregroundColor: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingScreen(doctor: doctor, patientId: patientId),
                    ),
                  );
                },
                child: const Text('Đặt lịch hẹn ngay', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _translateDay(String day) {
    Map<String, String> days = {
      'Monday': 'Thứ 2',
      'Tuesday': 'Thứ 3',
      'Wednesday': 'Thứ 4',
      'Thursday': 'Thứ 5',
      'Friday': 'Thứ 6',
      'Saturday': 'Thứ 7',
      'Sunday': 'Chủ nhật'
    };
    return days[day] ?? day;
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueGrey),
          const SizedBox(width: 10),
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}
