import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nfc_project/features/get_started/get_started_screen.dart';
import 'componnents/applocal.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  _MyAppState createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en');

  void _changeLanguage(String languageCode) {
    setState(() {
      _locale = Locale(languageCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'nfc',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              elevation: 0,
            ),
            useMaterial3: true,
          ),
          home: GetStartedScreen(
            changeLanguage: _changeLanguage,
          ),
          localizationsDelegates: [
            AppLocale.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale("en", ""),
            Locale("ar", ""),
          ],
          localeResolutionCallback: (currentLang, supportedLang) {
            if (currentLang != null) {
              for (Locale locale in supportedLang) 
              {
                if (locale.languageCode == currentLang.languageCode) {return currentLang;}
              }
            }
            return supportedLang.first;},
          locale: _locale,
        );
      },
    );
  }}