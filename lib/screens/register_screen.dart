import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/patient_model.dart';
import '../repositories/patient_repository.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _patientRepo = PatientRepository();

  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _emergencyController = TextEditingController();
  
  DateTime? _dob;
  String _gender = 'male';
  String? _bloodType;
  final List<String> _selectedAllergies = [];

  final List<String> _allergyOptions = ['Đậu phộng', 'Bụi', 'Phấn hoa', 'Penicillin', 'Hải sản'];
  final List<String> _bloodTypes = ['A', 'B', 'AB', 'O'];

  void _submit() async {
    if (_formKey.currentState!.validate() && _dob != null) {
      final patient = PatientModel(
        patientId: _emailController.text.trim(),
        email: _emailController.text.trim(),
        fullName: _nameController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        dateOfBirth: _dob!,
        gender: _gender,
        address: _addressController.text.trim(),
        bloodType: _bloodType,
        allergies: _selectedAllergies,
        emergencyContact: _emergencyController.text.trim(),
        createdAt: DateTime.now(),
      );

      try {
        await _patientRepo.addPatient(patient);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đăng ký thành công!')));
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } else if (_dob == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vui lòng chọn ngày sinh')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đăng ký - 2251172275')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(controller: _emailController, decoration: const InputDecoration(labelText: 'Email'), validator: (v) => v!.isEmpty ? 'Bắt buộc' : null),
              TextFormField(controller: _nameController, decoration: const InputDecoration(labelText: 'Họ và tên'), validator: (v) => v!.isEmpty ? 'Bắt buộc' : null),
              TextFormField(controller: _phoneController, decoration: const InputDecoration(labelText: 'Số điện thoại'), validator: (v) => v!.isEmpty ? 'Bắt buộc' : null),
              
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(_dob == null ? 'Chọn ngày sinh' : 'Ngày sinh: ${DateFormat('dd/MM/yyyy').format(_dob!)}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final picked = await showDatePicker(context: context, initialDate: DateTime(2000), firstDate: DateTime(1900), lastDate: DateTime.now());
                  if (picked != null) setState(() => _dob = picked);
                },
              ),
              
              DropdownButtonFormField<String>(
                value: _gender,
                decoration: const InputDecoration(labelText: 'Giới tính'),
                items: [
                  {'val': 'male', 'text': 'Nam'},
                  {'val': 'female', 'text': 'Nữ'},
                  {'val': 'other', 'text': 'Khác'}
                ].map((g) => DropdownMenuItem(value: g['val'], child: Text(g['text']!))).toList(),
                onChanged: (v) => setState(() => _gender = v!),
              ),
              
              TextFormField(controller: _addressController, decoration: const InputDecoration(labelText: 'Địa chỉ')),
              
              DropdownButtonFormField<String>(
                hint: const Text('Chọn nhóm máu'),
                items: _bloodTypes.map((b) => DropdownMenuItem(value: b, child: Text(b))).toList(),
                onChanged: (v) => setState(() => _bloodType = v),
              ),
              
              const SizedBox(height: 15),
              const Text('Dị ứng (Chọn nhiều):', style: TextStyle(fontWeight: FontWeight.bold)),
              Wrap(
                spacing: 8,
                children: _allergyOptions.map((allergy) {
                  return FilterChip(
                    label: Text(allergy),
                    selected: _selectedAllergies.contains(allergy),
                    onSelected: (selected) {
                      setState(() {
                        selected ? _selectedAllergies.add(allergy) : _selectedAllergies.remove(allergy);
                      });
                    },
                  );
                }).toList(),
              ),
              
              TextFormField(controller: _emergencyController, decoration: const InputDecoration(labelText: 'Liên hệ khẩn cấp')),
              
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(onPressed: _submit, child: const Text('Đăng ký tài khoản')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
