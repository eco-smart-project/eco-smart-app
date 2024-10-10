import 'package:eco_smart/core/router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  _setupLogging();
  Logger('main').info('App started');

  GoRouter.optionURLReflectsImperativeAPIs = true;

  runApp(const FazendaApp());
}

void _setupLogging() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    // ignore: avoid_print
    print('${rec.level.name}: ${rec.time}: ${rec.message}');

    if (rec.level.value >= Level.SEVERE.value && rec.error != null) {
      // ignore: avoid_print
      print('${rec.error}');
      // ignore: avoid_print
      print('${rec.stackTrace}');
    }
  });
}

class FazendaApp extends StatefulWidget {
  const FazendaApp({super.key});

  @override
  State<FazendaApp> createState() => _FazendaAppState();
}

class _FazendaAppState extends State<FazendaApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.blue,
        primaryColorLight: Colors.blue[100],
        dialogBackgroundColor: Colors.blue[200],
        drawerTheme: DrawerThemeData(
          backgroundColor: Colors.blue[100],
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue,
          titleTextStyle: TextStyle(color: Colors.blue[100], fontSize: 20),
          iconTheme: IconThemeData(color: Colors.blue[100]),
          actionsIconTheme: IconThemeData(color: Colors.blue[100]),
        ),
        scaffoldBackgroundColor: Colors.blue[100],
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 18, color: Colors.blue),
          bodySmall: TextStyle(fontSize: 14, color: Colors.blue),
          bodyMedium: TextStyle(fontSize: 16, color: Colors.blue),
        ),
        buttonTheme: const ButtonThemeData(
          buttonColor: Colors.blue,
          textTheme: ButtonTextTheme.primary,
        ),
        dialogTheme: DialogTheme(
          backgroundColor: Colors.blue[100],
          titleTextStyle: const TextStyle(color: Colors.blue, fontSize: 20),
          contentTextStyle: const TextStyle(color: Colors.blue, fontSize: 16),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.blue),
          border: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
          errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
          focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.blue),
            foregroundColor: MaterialStateProperty.all(Colors.blue[100]),
            textStyle: MaterialStateProperty.all(
              const TextStyle(fontSize: 16),
            ),
          ),
        ),
        dropdownMenuTheme: const DropdownMenuThemeData(
          textStyle: TextStyle(color: Colors.blue),
          inputDecorationTheme: InputDecorationTheme(
            labelStyle: TextStyle(color: Colors.blue),
            border: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
            errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
            focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
          ),
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: Colors.blue,
          contentTextStyle: TextStyle(color: Colors.blue[100], fontSize: 16),
        ),
        dividerColor: Colors.blue,
        dividerTheme: DividerThemeData(
          color: Colors.blue[200],
          thickness: 1,
        ),
        bottomSheetTheme: BottomSheetThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
        ),
        toggleButtonsTheme: ToggleButtonsThemeData(
          color: Colors.blue,
          selectedColor: Colors.blue[100],
          fillColor: Colors.blue,
          selectedBorderColor: Colors.blue,
          borderRadius: BorderRadius.circular(8),
        ),
        switchTheme: SwitchThemeData(
          thumbColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
            if (states.contains(MaterialState.selected)) {
              return Colors.blue;
            }
            return Colors.grey;
          }),
          trackColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
            if (states.contains(MaterialState.selected)) {
              return Colors.blue[200];
            }
            return Colors.grey[300];
          }),
          trackOutlineWidth: MaterialStateProperty.all(0),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.blue[100],
        ),
        progressIndicatorTheme: ProgressIndicatorThemeData(
          circularTrackColor: Colors.blue,
          color: Colors.blue[100],
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
            if (states.contains(MaterialState.selected)) {
              return Colors.blue;
            }
            return Colors.grey;
          }),
          side: const BorderSide(color: Colors.blue),
        ),
        tabBarTheme: TabBarTheme(
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey[800],
          indicator: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.blue, width: 2),
            ),
          ),
          overlayColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
            if (states.contains(MaterialState.hovered)) {
              return Colors.blue[150];
            }
            if (states.contains(MaterialState.pressed)) {
              return Colors.blue[300];
            }
            return Colors.transparent;
          }),
        ),
        useMaterial3: true,
      ),
    );
  }
}
