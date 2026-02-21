import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rolab_crm/features/students/domain/entities/student.dart';
import 'package:rolab_crm/features/students/presentation/notifiers/students_notifier.dart';

// Этот виджет будет принимать schoolId, чтобы знать, к какой школе привязать студента
class AddStudentDialog extends ConsumerStatefulWidget {
  final String schoolId;
  const AddStudentDialog({super.key, required this.schoolId});

  @override
  ConsumerState<AddStudentDialog> createState() => _AddStudentDialogState();
}

class _AddStudentDialogState extends ConsumerState<AddStudentDialog> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _parentNameController = TextEditingController();
  final _parentPhoneController = TextEditingController();
  DateTime? _dateOfBirth;

  @override
  void dispose() {
    _fullNameController.dispose();
    _parentNameController.dispose();
    _parentPhoneController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dateOfBirth ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _dateOfBirth) {
      setState(() {
        _dateOfBirth = picked;
      });
    }
  }
  
  void _submit() {
     if (_formKey.currentState!.validate()) {
        if(_dateOfBirth == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Пожалуйста, выберите дату рождения')),
          );
          return;
        }

       // Создаем объект студента
       final newStudent = Student(
          id: '', // Будет сгенерирован Firestore
          schoolId: widget.schoolId,
          fullName: _fullNameController.text.trim(),
          dateOfBirth: _dateOfBirth!,
          parentFullName: _parentNameController.text.trim(),
          parentPhoneNumber: _parentPhoneController.text.trim(),
          createdAt: DateTime.now(),
       );
       
       // Вызываем метод из notifier'а для добавления
       ref.read(studentsNotifierProvider(widget.schoolId).notifier).addStudent(newStudent);
       
       Navigator.of(context).pop();
     }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Новый студент'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView( // Для маленьких экранов
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _fullNameController,
                decoration: const InputDecoration(labelText: 'ФИО студента'),
                validator: (v) => v!.trim().isEmpty ? 'Обязательное поле' : null,
              ),
              TextFormField(
                controller: _parentNameController,
                decoration: const InputDecoration(labelText: 'ФИО родителя'),
                validator: (v) => v!.trim().isEmpty ? 'Обязательное поле' : null,
              ),
              TextFormField(
                controller: _parentPhoneController,
                decoration: const InputDecoration(labelText: 'Телефон родителя'),
                validator: (v) => v!.trim().isEmpty ? 'Обязательное поле' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(_dateOfBirth == null
                        ? 'Дата рождения не выбрана'
                        : 'Дата рождения: ${_dateOfBirth!.toLocal().toString().split(' ')[0]}'),
                  ),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Отмена')),
        ElevatedButton(onPressed: _submit, child: const Text('Сохранить')),
      ],
    );
  }
}
