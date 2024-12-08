import 'package:flutter/material.dart';
import 'package:menu_ussd/scren/homePage.dart';
import 'package:menu_ussd/themeNotifier.dart';
import 'package:provider/provider.dart';

void main() {

  runApp(
      ChangeNotifierProvider(create: (context) => ThemeNotifier(),
          child: const MyApp() )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(builder: (context, value, child) =>

        MaterialApp(
            title: 'Flutter Demo',
            theme:value.lightTheme,
            darkTheme: value.darkTheme,
            themeMode: value.themeMode,
            debugShowCheckedModeBanner: false,
            home: InterestsScreen()
        ),
    );


  }
}

