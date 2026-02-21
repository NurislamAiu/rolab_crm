import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rolab_crm/features/students/domain/entities/student.dart';
import 'package:rolab_crm/features/students/presentation/notifiers/students_notifier.dart';
import 'package:rolab_crm/features/students/presentation/notifiers/students_state.dart';
import 'package:rolab_crm/features/students/presentation/widgets/add_student_dialog.dart'; // <-- Импортируем диалог

class SchoolDetailsPage extends ConsumerWidget {
  final String schoolId;
  const SchoolDetailsPage({super.key, required this.schoolId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentsState = ref.watch(studentsNotifierProvider(schoolId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Детали школы'), // TODO: Показать имя школы
        actions: [
          IconButton(
            // --- ОБНОВЛЯЕМ ДЕЙСТВИЕ ---
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AddStudentDialog(schoolId: schoolId), // Передаем schoolId
              );
            },
            icon: const Icon(Icons.person_add),
          )
        ],
      ),
      body: Center(
        child: switch (studentsState) {
          StudentsLoading() || StudentsInitial() => const CircularProgressIndicator(),
          StudentsError(message: final msg) => Text(msg),
          StudentsStreamLoaded(studentsStream: final stream) => StreamBuilder<List<Student>>(
              stream: stream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
                  return const CircularProgressIndicator();
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('В этой школе еще нет студентов.'));
                }
                final students = snapshot.data!;
                return ListView.builder(
                  itemCount: students.length,
                  itemBuilder: (context, index) {
                    final student = students[index];
                    return ListTile(
                      title: Text(student.fullName),
                      subtitle: Text('Родитель: ${student.parentFullName}, ДР: ${student.dateOfBirth.toLocal().toString().split(' ')[0]}'),
                    );
                  },
                );
              },
            ),
        },
      ),
    );
  }
}
