import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/date_symbol_data_local.dart'; // Инициализация дат
import 'package:rolab_crm/core/config/router/app_router.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Инициализация Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Инициализация локалей для пакета intl (чтобы даты на русском работали)
  await initializeDateFormatting('ru', null);

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // В вашем проекте провайдер называется routerProvider
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'RoLab CRM',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF007AFF), // Apple Blue
          surface: const Color(0xFFF2F2F7),
        ),
        useMaterial3: true,
        fontFamily: '.SF Pro Display', // Системный шрифт Apple (работает на iOS/Mac)
      ),
    );
  }
}
