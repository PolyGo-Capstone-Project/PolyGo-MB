import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'core/localization/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:device_preview/device_preview.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/size_config.dart';
import 'routes/app_routes.dart';

void main() {
  runApp(
    DevicePreview(
    enabled: true,
    builder: (context) => const MyApp(),
  ),);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en');
  ThemeMode _themeMode = ThemeMode.system;

  void _setLocale(Locale locale) {
    setState(() => _locale = locale);
  }

  void _setThemeMode(ThemeMode mode) {
    setState(() => _themeMode = mode);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return MaterialApp(
      title: 'PolyGo App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: _themeMode,
      initialRoute: AppRoutes.login,
      onGenerateRoute: AppRoutes.generateRoute,
      locale: _locale,
      supportedLocales: const [
        Locale('en'),
        Locale('vi'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) {
        return InheritedLocale(
          locale: _locale,
          setLocale: _setLocale,
          child: InheritedThemeMode(
            themeMode: _themeMode,
            setThemeMode: _setThemeMode,
            child: child!,
          ),
        );
      },
    );
  }
}

class InheritedLocale extends InheritedWidget {
  final Locale locale;
  final void Function(Locale) setLocale;

  const InheritedLocale({
    super.key,
    required super.child,
    required this.locale,
    required this.setLocale,
  });

  static InheritedLocale of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedLocale>()!;
  }

  @override
  bool updateShouldNotify(InheritedLocale oldWidget) =>
      locale != oldWidget.locale;
}

class InheritedThemeMode extends InheritedWidget {
  final ThemeMode themeMode;
  final void Function(ThemeMode) setThemeMode;

  const InheritedThemeMode({
    super.key,
    required super.child,
    required this.themeMode,
    required this.setThemeMode,
  });

  static InheritedThemeMode of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedThemeMode>()!;
  }

  @override
  bool updateShouldNotify(InheritedThemeMode oldWidget) =>
      themeMode != oldWidget.themeMode;
}
