import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workspace/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:workspace/core/utils/app_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:workspace/features/thesis/auth/cubit/auth_cubit.dart';
import 'package:workspace/features/thesis/home/cubit/home_cubit.dart';
import 'package:workspace/features/thesis/landing/splash_screen.dart';
import 'package:workspace/features/thesis/dashboard/cubit/leave_cubit.dart';
import 'package:workspace/features/thesis/history/cubit/attendance_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en', 'US'), Locale('zh', 'HK')],
      fallbackLocale: const Locale('en', 'US'),
      startLocale: const Locale('en', 'US'),
      path: 'assets/language',
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (_) => AuthCubit()),
        BlocProvider<HomeCubit>(create: (_) => HomeCubit()),
        BlocProvider<LeaveCubit>(create: (_) => LeaveCubit()),
        BlocProvider<AttendanceCubit>(create: (_) => AttendanceCubit()),
      ],
      child: MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.themeDataLight,
        home: SplashScreen(),
      ),
    );
  }
}
