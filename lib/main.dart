import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/config/app_constants.dart';
import 'core/localization/app_localizations.dart';
import 'core/navigation/app_router.dart';
import 'core/theme/app_theme.dart';
import 'data/services/firebase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Prevent google_fonts async mid-frame microtask updates on Flutter Web
  GoogleFonts.config.allowRuntimeFetching = true;

  // Initialize Firebase gracefully (falls back to mock/offline if unconfigured)
  await FirebaseService.initialize();

  runApp(
    const ProviderScope(
      child: KrmAlteenApp(),
    ),
  );
}

class KrmAlteenApp extends ConsumerWidget {
  const KrmAlteenApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeNotifierProvider);

    return MaterialApp.router(
      title: AppConstants.restaurantNameAr,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      locale: currentLocale,
      supportedLocales: const [
        Locale('ar'),
        Locale('en'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: appRouter,
    );
  }
}
