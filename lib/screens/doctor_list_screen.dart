import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/doctor_model.dart';
import '../utils/faker_data.dart';
import 'doctor_detail_screen.dart';
import 'my_appointments_screen.dart';
import 'login_screen.dart';

class DoctorListScreen extends StatefulWidget {
  final String patientId;
  const DoctorListScreen({super.key, required this.patientId});

  @override
  State<DoctorListScreen> createState() => _DoctorListScreenState();
}

class _DoctorListScreenState extends State<DoctorListScreen> {
  String _searchQuery = "";
  String _selectedSpecialization = "Tất cả";

  final List<String> _specializations = [
    "Tất cả",
    "Tim mạch",
    "Da liễu",
    "Nhi khoa",
    "Chấn thương chỉnh hình",
    "Tổng quát"
  ];

  final Map<String, String> _specMapping = {
    "Tất cả": "All",
    "Tim mạch": "Cardiology",
    "Da liễu": "Dermatology",
    "Nhi khoa": "Pediatrics",
    "Chấn thương chỉnh hình": "Orthopedics",
    "Tổng quát": "General"
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phòng khám - 2251172275'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'Lịch hẹn của tôi',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyAppointmentsScreen(patientId: widget.patientId),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.data_saver_on),
            tooltip: 'Tạo dữ liệu mẫu',
            onPressed: () async {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const Center(child: CircularProgressIndicator()),
              );
              
              try {
                await FakerData.seedAll();
                
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đã tạo xong dữ liệu mẫu cho cả 3 bảng!')),
                  );
                }
              } catch (e) {
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Lỗi: $e')),
                  );
                }
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Đăng xuất',
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Tìm bác sĩ theo tên',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() => _searchQuery = value);
              },
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _specializations.map((spec) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ChoiceChip(
                    label: Text(spec),
                    selected: _selectedSpecialization == spec,
                    onSelected: (selected) {
                      setState(() => _selectedSpecialization = spec);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('doctors').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) return const Center(child: Text('Đã xảy ra lỗi'));
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                var doctors = snapshot.data!.docs.map((doc) {
                  return DoctorModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
                }).toList();

                var filteredDoctors = doctors.where((doc) {
                  bool matchesSearch = doc.fullName.toLowerCase().contains(_searchQuery.toLowerCase());
                  String targetSpec = _specMapping[_selectedSpecialization]!;
                  bool matchesSpec = targetSpec == "All" || doc.specialization == targetSpec;
                  return matchesSearch && matchesSpec;
                }).toList();

                if (filteredDoctors.isEmpty) {
                  return const Center(child: Text('Không tìm thấy bác sĩ nào.'));
                }

                return ListView.builder(
                  itemCount: filteredDoctors.length,
                  itemBuilder: (context, index) {
                    final doctor = filteredDoctors[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue.shade100,
                          child: const Icon(Icons.person),
                        ),
                        title: Text(doctor.fullName, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(doctor.specialization),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DoctorDetailScreen(doctor: doctor, patientId: widget.patientId),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
