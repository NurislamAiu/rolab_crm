import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rolab_crm/features/schools/domain/entities/school.dart';
import '../notifiers/schools_notifier.dart';
import '../notifiers/schools_state.dart';
import '../widgets/add_edit_school_dialog.dart';

import '../../../dashboard/presentation/widgets/dashboard_colors.dart';

class SchoolsDashboardPage extends ConsumerWidget {
  const SchoolsDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final schoolsState = ref.watch(schoolsNotifierProvider);

    Widget buildContent(List<Widget> slivers) {
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
                'Школы',
                style: TextStyle(fontWeight: FontWeight.bold, color: textPrimary),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: TextButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => const AddEditSchoolDialog(),
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

    return switch (schoolsState) {
      SchoolsInitial() || SchoolsLoading() => buildContent([
          const SliverFillRemaining(child: Center(child: CupertinoActivityIndicator(radius: 16))),
        ]),
      SchoolsError(message: final msg) => buildContent([
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
      SchoolsStreamLoaded(schoolsStream: final stream) => StreamBuilder<List<School>>(
          stream: stream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
              return buildContent([
                const SliverFillRemaining(child: Center(child: CupertinoActivityIndicator(radius: 16))),
              ]);
            }

            if (snapshot.hasError) {
              return buildContent([
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
                          child: Text('Поиск школы...', style: TextStyle(color: textSecondary, fontSize: 16)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return buildContent([
                searchBarSliver,
                const SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(CupertinoIcons.building_2_fill, size: 80, color: textSecondary),
                        SizedBox(height: 16),
                        Text('Нет добавленных школ', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: textPrimary)),
                        SizedBox(height: 8),
                        Text(
                          'Нажмите «Добавить» в правом верхнем\nуглу, чтобы создать новую школу.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 15, color: textSecondary),
                        ),
                      ],
                    ),
                  ),
                ),
              ]);
            }

            final schools = snapshot.data!;
            
            return buildContent([
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
                          mainAxisExtent: 100, // Высота карточки школы в сетке
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => _PremiumSchoolCard(school: schools[index]),
                          childCount: schools.length,
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
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _PremiumSchoolCard(school: schools[index]),
                            );
                          },
                          childCount: schools.length,
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

// Премиум-карточка школы
class _PremiumSchoolCard extends StatelessWidget {
  final School school;

  const _PremiumSchoolCard({required this.school});

  // Генерация красивого градиента на основе названия школы
  Color _getSchoolColor(String name) {
    final colors = [
      CupertinoColors.systemIndigo,
      CupertinoColors.activeBlue,
      CupertinoColors.systemPurple,
      CupertinoColors.systemTeal,
      CupertinoColors.systemPink,
      CupertinoColors.systemOrange,
    ];
    return colors[name.hashCode.abs() % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final isNameEmpty = school.name.trim().isEmpty;
    final name = isNameEmpty ? 'Без названия' : school.name;
    final primaryAvatarColor = _getSchoolColor(name);

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            // Переходим на страницу деталей школы (к списку студентов)
            context.go('/schools/${school.id}');
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Иконка / Аватарка школы (Squircle)
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [primaryAvatarColor.withOpacity(0.6), primaryAvatarColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    isNameEmpty ? '?' : name.substring(0, 1).toUpperCase(),
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 16),
                
                // Название и адрес
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 18, 
                          fontWeight: FontWeight.w700, 
                          color: textPrimary
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(CupertinoIcons.location_solid, size: 14, color: textSecondary),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              school.address.isNotEmpty ? school.address : 'Адрес не указан',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14, 
                                fontWeight: FontWeight.w500, 
                                color: textSecondary
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(width: 12),
                
                // Иконка стрелочки "вперед"
                const Icon(CupertinoIcons.chevron_right, size: 20, color: textSecondary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
