import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:rolab_crm/features/auth/presentation/notifiers/auth_state.dart';
import 'package:rolab_crm/features/auth/presentation/notifiers/auth_state_notifier.dart';
import 'package:rolab_crm/features/students/domain/entities/student.dart';
import 'package:rolab_crm/features/students/presentation/notifiers/students_notifier.dart';

class AddStudentDialog extends ConsumerStatefulWidget {
  final String schoolId;
  const AddStudentDialog({super.key, required this.schoolId});

  @override
  ConsumerState<AddStudentDialog> createState() => _AddStudentDialogState();
}

class _AddStudentDialogState extends ConsumerState<AddStudentDialog> {
  final _fullNameController = TextEditingController();
  final _parentNameController = TextEditingController();
  final _parentPhoneController = TextEditingController();
  final _iinController = TextEditingController();
  final _classNameController = TextEditingController();
  DateTime? _dateOfBirth;

  @override
  void dispose() {
    _fullNameController.dispose();
    _parentNameController.dispose();
    _parentPhoneController.dispose();
    _iinController.dispose();
    _classNameController.dispose();
    super.dispose();
  }

  void _showDatePicker(BuildContext context) {
    FocusScope.of(context).unfocus();
    
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          color: CupertinoColors.systemBackground.resolveFrom(context),
          child: Column(
            children: [
              Container(
                color: CupertinoColors.systemGrey6.resolveFrom(context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CupertinoButton(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: const Text('Готово', style: TextStyle(fontWeight: FontWeight.w600)),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SafeArea(
                  top: false,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: _dateOfBirth ?? DateTime.now(),
                    maximumDate: DateTime.now(),
                    onDateTimeChanged: (DateTime newDate) {
                      setState(() {
                        _dateOfBirth = newDate;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _submit() {
    final fullName = _fullNameController.text.trim();
    final parentName = _parentNameController.text.trim();
    final parentPhone = _parentPhoneController.text.trim();

    if (fullName.isEmpty || parentName.isEmpty || parentPhone.isEmpty || _dateOfBirth == null) {
      showCupertinoDialog(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: const Text('Заполните поля'),
          content: const Text('Пожалуйста, укажите имя ученика, родителя, телефон и выберите дату рождения.'),
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

    // Получаем текущего пользователя для логирования
    final authState = ref.read(authStateNotifierProvider);
    String adminName = "Неизвестно";
    if (authState is Authenticated) {
      adminName = authState.user.fullName;
    }

    final newStudent = Student(
      id: '',
      schoolId: widget.schoolId,
      fullName: fullName,
      dateOfBirth: _dateOfBirth!,
      parentFullName: parentName,
      parentPhoneNumber: parentPhone,
      iin: _iinController.text.trim().isEmpty ? null : _iinController.text.trim(),
      className: _classNameController.text.trim().isEmpty ? null : _classNameController.text.trim(),
      createdAt: DateTime.now(),
    );

    ref.read(studentsNotifierProvider(widget.schoolId).notifier).addStudent(
      student: newStudent,
      adminName: adminName,
    );
    
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 800),
        decoration: BoxDecoration(
          color: const Color(0xFFF2F2F7),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
                    'Новый ученик',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                ],
              ),
            ),
            
            const Divider(height: 1, thickness: 0.5, color: Color(0xFFE5E5EA)),

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
                        'ДАННЫЕ УЧЕНИКА',
                        style: TextStyle(fontSize: 13, color: CupertinoColors.systemGrey, fontWeight: FontWeight.w500),
                      ),
                    ),
                    _AppleFormGroup(
                      children: [
                        _AppleTextField(
                          controller: _fullNameController,
                          placeholder: 'Имя и фамилия ученика',
                          textInputAction: TextInputAction.next,
                        ),
                        const Divider(height: 1, indent: 16, color: Color(0xFFE5E5EA)),
                        GestureDetector(
                          onTap: () => _showDatePicker(context),
                          behavior: HitTestBehavior.opaque,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Дата рождения', style: TextStyle(fontSize: 16, color: Colors.black87)),
                                Row(
                                  children: [
                                    Text(
                                      _dateOfBirth == null
                                          ? 'Не выбрана'
                                          : DateFormat('dd.MM.yyyy').format(_dateOfBirth!),
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: _dateOfBirth == null ? CupertinoColors.systemGrey3 : CupertinoColors.systemGrey,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(CupertinoIcons.chevron_right, size: 16, color: CupertinoColors.systemGrey3),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Divider(height: 1, indent: 16, color: Color(0xFFE5E5EA)),
                        _AppleTextField(
                          controller: _iinController,
                          placeholder: 'ИИН (необязательно)',
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                        ),
                        const Divider(height: 1, indent: 16, color: Color(0xFFE5E5EA)),
                        _AppleTextField(
                          controller: _classNameController,
                          placeholder: 'Класс / Группа (необязательно)',
                          textInputAction: TextInputAction.next,
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    const Padding(
                      padding: EdgeInsets.only(left: 16, bottom: 8),
                      child: Text(
                        'ДАННЫЕ РОДИТЕЛЯ',
                        style: TextStyle(fontSize: 13, color: CupertinoColors.systemGrey, fontWeight: FontWeight.w500),
                      ),
                    ),
                    _AppleFormGroup(
                      children: [
                        _AppleTextField(
                          controller: _parentNameController,
                          placeholder: 'Имя и фамилия родителя',
                          textInputAction: TextInputAction.next,
                        ),
                        const Divider(height: 1, indent: 16, color: Color(0xFFE5E5EA)),
                        _AppleTextField(
                          controller: _parentPhoneController,
                          placeholder: 'Номер телефона',
                          keyboardType: TextInputType.phone,
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
      decoration: const BoxDecoration(color: Colors.transparent),
      style: const TextStyle(fontSize: 16, color: Colors.black87),
      placeholderStyle: const TextStyle(fontSize: 16, color: CupertinoColors.systemGrey3),
    );
  }
}
