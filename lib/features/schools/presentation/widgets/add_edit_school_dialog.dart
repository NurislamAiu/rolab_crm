import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rolab_crm/features/auth/presentation/notifiers/auth_state.dart';
import 'package:rolab_crm/features/auth/presentation/notifiers/auth_state_notifier.dart';
import 'package:rolab_crm/features/schools/presentation/notifiers/schools_notifier.dart';

class AddEditSchoolDialog extends ConsumerStatefulWidget {
  const AddEditSchoolDialog({super.key});

  @override
  ConsumerState<AddEditSchoolDialog> createState() => _AddEditSchoolDialogState();
}

class _AddEditSchoolDialogState extends ConsumerState<AddEditSchoolDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final authState = ref.read(authStateNotifierProvider);
      if (authState is Authenticated) {
        // Вызываем метод из notifier'а для добавления школы
        ref.read(schoolsNotifierProvider.notifier).addSchool(
              name: _nameController.text.trim(),
              address: _addressController.text.trim(),
              currentUser: authState.user,
            );
        // Закрываем диалог после отправки
        Navigator.of(context).pop();
      } else {
        // Показываем ошибку, если пользователь как-то разлогинился
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ошибка: пользователь не авторизован.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Новая школа'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Название'),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Пожалуйста, введите название';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: 'Адрес'),
               validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Пожалуйста, введите адрес';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Отмена'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Сохранить'),
        ),
      ],
    );
  }
}
