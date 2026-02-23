import 'package:flutter/cupertino.dart';
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
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _nameController.text.trim();
    final address = _addressController.text.trim();

    // Красивая Apple-валидация
    if (name.isEmpty || address.isEmpty) {
      showCupertinoDialog(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: const Text('Заполните поля'),
          content: const Text('Пожалуйста, укажите название школы и её адрес.'),
          actions: [
            CupertinoDialogAction(
              child: const Text('Понятно'),
              onPressed: () => Navigator.pop(ctx),
            )
          ],
        ),
      );
      return;
    }

    final authState = ref.read(authStateNotifierProvider);
    if (authState is Authenticated) {
      // Сохранение в базу
      ref.read(schoolsNotifierProvider.notifier).addSchool(
            name: name,
            address: address,
            currentUser: authState.user,
          );
      // Закрываем окно
      Navigator.of(context).pop();
    } else {
      // Если сессия слетела
      showCupertinoDialog(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: const Text('Ошибка сессии'),
          content: const Text('Пожалуйста, авторизуйтесь заново.'),
          actions: [
            CupertinoDialogAction(
              child: const Text('ОК'),
              onPressed: () => Navigator.pop(ctx),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
        decoration: BoxDecoration(
          color: const Color(0xFFF2F2F7), // Классический iOS фон
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // --- ШАПКА ДИАЛОГА ---
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CupertinoButton(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Отмена', style: TextStyle(color: CupertinoColors.systemGrey)),
                      ),
                      CupertinoButton(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        onPressed: _submit,
                        child: const Text('Сохранить', style: TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                  const Text(
                    'Новая школа',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                ],
              ),
            ),
            
            const Divider(height: 1, thickness: 0.5, color: Color(0xFFE5E5EA)),

            // --- ТЕЛО ФОРМЫ ---
            Flexible(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 16, bottom: 8),
                      child: Text(
                        'ОСНОВНЫЕ ДАННЫЕ',
                        style: TextStyle(fontSize: 13, color: CupertinoColors.systemGrey, fontWeight: FontWeight.w500),
                      ),
                    ),
                    _AppleFormGroup(
                      children: [
                        _AppleTextField(
                          controller: _nameController,
                          placeholder: 'Название школы (например, High School)',
                          textInputAction: TextInputAction.next,
                        ),
                        const Divider(height: 1, indent: 16, color: Color(0xFFE5E5EA)),
                        _AppleTextField(
                          controller: _addressController,
                          placeholder: 'Адрес',
                          textInputAction: TextInputAction.done,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Виджет-контейнер для группы полей (белый блок со скругленными краями)
class _AppleFormGroup extends StatelessWidget {
  final List<Widget> children;

  const _AppleFormGroup({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: children,
      ),
    );
  }
}

// Виджет текстового поля без рамок (в стиле ячеек iOS)
class _AppleTextField extends StatelessWidget {
  final TextEditingController controller;
  final String placeholder;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  const _AppleTextField({
    required this.controller,
    required this.placeholder,
    this.keyboardType,
    this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoTextField(
      controller: controller,
      placeholder: placeholder,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: const BoxDecoration(color: Colors.transparent), // Убираем дефолтную рамку
      style: const TextStyle(fontSize: 16, color: Colors.black87),
      placeholderStyle: const TextStyle(fontSize: 16, color: CupertinoColors.systemGrey3),
    );
  }
}
