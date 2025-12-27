import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../models/appointment_model.dart';
import '../repositories/appointment_repository.dart';

class MyAppointmentsScreen extends StatelessWidget {
  final String patientId;
  const MyAppointmentsScreen({super.key, required this.patientId});

  Color _getStatusColor(String status) {
    switch (status) {
      case 'scheduled': return Colors.blue;
      case 'confirmed': return Colors.green;
      case 'completed': return Colors.grey;
      case 'cancelled': return Colors.red;
      default: return Colors.black;
    }
  }

  String _translateStatus(String status) {
    switch (status) {
      case 'scheduled': return 'Đã đặt lịch';
      case 'confirmed': return 'Đã xác nhận';
      case 'completed': return 'Đã hoàn thành';
      case 'cancelled': return 'Đã hủy';
      default: return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final appointmentRepo = AppointmentRepository();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lịch hẹn của tôi - 2251172275'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('appointments')
            .where('patientId', isEqualTo: patientId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Center(child: Text('Lỗi tải dữ liệu'));
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          var appointments = snapshot.data!.docs.map((doc) {
            return AppointmentModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
          }).toList();

          if (appointments.isEmpty) {
            return const Center(child: Text('Bạn chưa có lịch hẹn nào.'));
          }

          return ListView.builder(
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final appt = appointments[index];
              return Card(
                margin: const EdgeInsets.all(10),
                child: ExpansionTile(
                  leading: CircleAvatar(
                    backgroundColor: _getStatusColor(appt.status),
                    child: const Icon(Icons.event, color: Colors.white),
                  ),
                  title: Text('Bác sĩ: ${appt.doctorName}'), // Đã sửa từ doctorId sang doctorName
                  subtitle: Text('Ngày: ${DateFormat('dd/MM/yyyy').format(appt.appointmentDate)} - Giờ: ${appt.appointmentTime}'),
                  trailing: Text(
                    _translateStatus(appt.status),
                    style: TextStyle(color: _getStatusColor(appt.status), fontWeight: FontWeight.bold),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Lý do khám: ${appt.reason}'),
                          if (appt.diagnosis != null) ...[
                            const Divider(),
                            Text('Chẩn đoán: ${appt.diagnosis}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                            Text('Đơn thuốc: ${appt.prescription}'),
                          ],
                          if (appt.status == 'scheduled' || appt.status == 'confirmed')
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton.icon(
                                icon: const Icon(Icons.cancel, color: Colors.red),
                                label: const Text('Hủy lịch', style: TextStyle(color: Colors.red)),
                                onPressed: () async {
                                  await appointmentRepo.cancelAppointment(appt.appointmentId);
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã hủy lịch hẹn')));
                                },
                              ),
                            ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
