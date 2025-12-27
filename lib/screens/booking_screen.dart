import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/doctor_model.dart';
import '../repositories/appointment_repository.dart';

class BookingScreen extends StatefulWidget {
  final DoctorModel doctor;
  final String patientId; // Nhận ID từ màn hình trước

  const BookingScreen({super.key, required this.doctor, required this.patientId});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _appointmentRepo = AppointmentRepository();
  DateTime? _selectedDate;
  String? _selectedTime;
  final _reasonController = TextEditingController();
  bool _isLoading = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _selectedTime = null;
      });
    }
  }

  void _book() async {
    if (_selectedDate == null || _selectedTime == null || _reasonController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vui lòng điền đầy đủ thông tin')));
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _appointmentRepo.createAppointment(
        widget.patientId, // Sử dụng ID động của người dùng đang đăng nhập
        widget.doctor.doctorId,
        _selectedDate!,
        _selectedTime!,
        _reasonController.text,
      );

      if (mounted) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Thành công'),
            content: const Text('Lịch hẹn của bạn đã được đặt thành công!'),
            actions: [
              TextButton(onPressed: () => Navigator.popUntil(context, (route) => route.isFirst), child: const Text('Đồng ý'))
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đặt lịch - 2251172275'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Bác sĩ: ${widget.doctor.fullName}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ListTile(
              title: Text(_selectedDate == null ? 'Chọn ngày khám' : 'Ngày: ${DateFormat('dd/MM/yyyy').format(_selectedDate!)}'),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectDate(context),
              tileColor: Colors.grey.shade100,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            const SizedBox(height: 20),
            const Text('Chọn khung giờ:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: widget.doctor.availableTimeSlots.map((time) {
                return ChoiceChip(
                  label: Text(time),
                  selected: _selectedTime == time,
                  onSelected: (selected) {
                    setState(() => _selectedTime = selected ? time : null);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _reasonController,
              decoration: const InputDecoration(
                labelText: 'Lý do khám bệnh',
                border: OutlineInputBorder(),
                hintText: 'Nhập triệu chứng hoặc lý do...',
              ),
              maxLines: 3,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, foregroundColor: Colors.white),
                onPressed: _isLoading ? null : _book,
                child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Xác nhận đặt lịch', style: TextStyle(fontSize: 16)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
