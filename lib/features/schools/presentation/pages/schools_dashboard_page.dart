import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rolab_crm/features/schools/domain/entities/school.dart';
import '../notifiers/schools_notifier.dart';
import '../notifiers/schools_state.dart';
import '../widgets/add_edit_school_dialog.dart';

class SchoolsDashboardPage extends ConsumerWidget {
  const SchoolsDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final schoolsState = ref.watch(schoolsNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Школы'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const AddEditSchoolDialog(),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: switch (schoolsState) {
          SchoolsInitial() ||
          SchoolsLoading() =>
            const CircularProgressIndicator(),
          SchoolsError(message: final msg) => Text('Ошибка: $msg'),
          SchoolsStreamLoaded(schoolsStream: final stream) =>
            StreamBuilder<List<School>>(
              stream: stream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text('Ошибка в стриме: ${snapshot.error}');
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('Школ пока нет. Добавьте первую!');
                }

                final schools = snapshot.data!;
                return ListView.builder(
                  itemCount: schools.length,
                  itemBuilder: (context, index) {
                    final school = schools[index];
                    return ListTile(
                      title: Text(school.name),
                      subtitle: Text(school.address),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      // --- ОБНОВЛЯЕМ ДЕЙСТВИЕ ---
                      onTap: () {
                        // Переходим на страницу деталей, заменяя :id на реальный ID школы
                        context.go('/schools/${school.id}');
                      },
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
