import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:rolab_crm/features/students/domain/entities/student.dart';
import 'package:rolab_crm/features/students/presentation/notifiers/students_notifier.dart';
import 'package:rolab_crm/features/students/presentation/notifiers/students_state.dart';
import 'package:rolab_crm/features/students/presentation/widgets/add_student_dialog.dart';

import '../../../dashboard/presentation/widgets/dashboard_colors.dart';

class SchoolDetailsPage extends ConsumerWidget {
  final String schoolId;
  const SchoolDetailsPage({super.key, required this.schoolId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentsState = ref.watch(studentsNotifierProvider(schoolId));
    
    Widget buildScaffold(List<Widget> slivers) {
      return Container(
        color: bgColor,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            SliverAppBar.large(
              backgroundColor: bgColor,
              surfaceTintColor: Colors.transparent,
              stretch: true,
              title: const Text(
                'Студенты',
                style: TextStyle(fontWeight: FontWeight.bold, color: textPrimary),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: TextButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AddStudentDialog(schoolId: schoolId),
                      );
                    },
                    icon: const Icon(CupertinoIcons.add_circled_solid, size: 20, color: primaryColor),
                    label: const Text('Добавить', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: primaryColor)),
                  ),
                )
              ],
            ),
            ...slivers,
          ],
        ),
      );
    }

    return switch (studentsState) {
      StudentsLoading() || StudentsInitial() => buildScaffold([
          const SliverFillRemaining(child: Center(child: CupertinoActivityIndicator(radius: 16))),
        ]),
      StudentsError(message: final msg) => buildScaffold([
          SliverFillRemaining(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(CupertinoIcons.exclamationmark_circle, size: 64, color: redColor),
                    const SizedBox(height: 16),
                    const Text('Ошибка', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: textPrimary)),
                    const SizedBox(height: 8),
                    Text(msg, textAlign: TextAlign.center, style: const TextStyle(color: textSecondary)),
                  ],
                ),
              ),
            ),
          ),
        ]),
      StudentsStreamLoaded(studentsStream: final stream) => StreamBuilder<List<Student>>(
          stream: stream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
              return buildScaffold([
                const SliverFillRemaining(child: Center(child: CupertinoActivityIndicator(radius: 16))),
              ]);
            }

            if (snapshot.hasError) {
              return buildScaffold([
                SliverFillRemaining(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(CupertinoIcons.wifi_exclamationmark, size: 64, color: redColor),
                          const SizedBox(height: 16),
                          const Text('Ошибка соединения', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: textPrimary)),
                          const SizedBox(height: 8),
                          Text('${snapshot.error}', textAlign: TextAlign.center, style: const TextStyle(color: textSecondary)),
                        ],
                      ),
                    ),
                  ),
                ),
              ]);
            }

            final searchBarSliver = SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF13151F),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: borderColor),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        Icon(CupertinoIcons.search, color: textSecondary, size: 18),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text('Поиск ученика...', style: TextStyle(color: textSecondary, fontSize: 16)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return buildScaffold([
                searchBarSliver,
                const SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(CupertinoIcons.person_2_alt, size: 80, color: textSecondary),
                        SizedBox(height: 16),
                        Text('Нет студентов', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: textPrimary)),
                        SizedBox(height: 8),
                        Text(
                          'Нажмите «Добавить» в правом верхнем\nуглу, чтобы создать карточку.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 15, color: textSecondary),
                        ),
                      ],
                    ),
                  ),
                ),
              ]);
            }

            final students = snapshot.data!;
            
            return buildScaffold([
              searchBarSliver,
              SliverLayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount = 1;
                  if (constraints.crossAxisExtent >= 1100) {
                    crossAxisCount = 3;
                  } else if (constraints.crossAxisExtent >= 650) {
                    crossAxisCount = 2;
                  }

                  if (crossAxisCount > 1) {
                    return SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
                      sliver: SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          mainAxisExtent: 285, // Вернул высоту для красивого размещения списка
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => _PremiumStudentCard(student: students[index]),
                          childCount: students.length,
                        ),
                      ),
                    );
                  } else {
                    return SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: _PremiumStudentCard(student: students[index]),
                            );
                          },
                          childCount: students.length,
                        ),
                      ),
                    );
                  }
                },
              ),
            ]);
          },
        ),
    };
  }
}

class _PremiumStudentCard extends StatelessWidget {
  final Student student;

  const _PremiumStudentCard({required this.student});

  Color _getAvatarColor(String name) {
    final colors = [
      CupertinoColors.systemBlue,
      CupertinoColors.systemOrange,
      CupertinoColors.systemPink,
      CupertinoColors.systemPurple,
      CupertinoColors.systemTeal,
      CupertinoColors.systemIndigo,
    ];
    return colors[name.hashCode.abs() % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final isNameEmpty = student.fullName.trim().isEmpty;
    final name = isNameEmpty ? 'Без имени' : student.fullName;
    final formattedDob = DateFormat('dd.MM.yyyy').format(student.dateOfBirth.toLocal());
    final avatarColor = _getAvatarColor(name);

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            // TODO: Детальная страница
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // --- ШАПКА КАРТОЧКИ ---
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Аватар (Цветной с градиентом)
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [avatarColor.withOpacity(0.6), avatarColor],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        isNameEmpty ? '?' : name.substring(0, 1).toUpperCase(),
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 14),
                    
                    // Имя и Класс
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, letterSpacing: -0.4, color: textPrimary),
                          ),
                          if (student.className?.isNotEmpty == true) ...[
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFF13151F),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'Класс ${student.className}',
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textSecondary),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    
                    // Кнопка меню
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: const Icon(CupertinoIcons.ellipsis_vertical, size: 20, color: textSecondary),
                      onPressed: () {},
                    )
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // --- ИНФОРМАЦИЯ: ДЕНЬ РОЖДЕНИЯ И ИИН ---
                // Заменили бейджи на аккуратные строки с текстом
                _InfoRow(
                  icon: CupertinoIcons.gift_fill,
                  label: 'День рождения',
                  value: formattedDob,
                ),
                const SizedBox(height: 8),
                if (student.iin?.isNotEmpty == true)
                  _InfoRow(
                    icon: CupertinoIcons.doc_text_fill,
                    label: 'ИИН',
                    value: student.iin!,
                  ),

                const Spacer(), // Отталкивает блок родителя вниз (в Grid режиме)
                const SizedBox(height: 16),

                // --- БЛОК РОДИТЕЛЯ (Apple Nested Box) ---
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF13151F), // Красивый серый фон
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: borderColor),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      // Иконка родителя в белом круге
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(color: cardColor, shape: BoxShape.circle),
                        child: const Icon(CupertinoIcons.person_2_fill, size: 18, color: textSecondary),
                      ),
                      const SizedBox(width: 12),
                      
                      // Данные родителя
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              student.parentFullName.isNotEmpty ? student.parentFullName : 'Не указан',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textPrimary),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              student.parentPhoneNumber,
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: textSecondary),
                            ),
                          ],
                        ),
                      ),
                      
                      // Кнопка позвонить (Зеленая)
                      if (student.parentPhoneNumber.isNotEmpty)
                        Material(
                          color: greenColor.withOpacity(0.15),
                          shape: const CircleBorder(),
                          clipBehavior: Clip.antiAlias,
                          child: InkWell(
                            onTap: () {},
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(CupertinoIcons.phone_fill, size: 18, color: greenColor),
                            ),
                          ),
                        )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Элегантная строка для отображения данных (Иконка + Лейбл + Значение)
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: textSecondary),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: textSecondary, fontWeight: FontWeight.w500),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textPrimary),
        ),
      ],
    );
  }
}
