import 'package:findmotto/infoHandler/app_info.dart';
import 'package:findmotto/screens/admin_dashboard.dart';
import 'package:findmotto/screens/login_screen.dart';
import 'package:findmotto/screens/search_places_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
/*import 'package:findmotto/screens/main_screen.dart';
import 'package:findmotto/screens/register_screen.dart';
import 'package:findmotto/screens/login_screen.dart';*/
import 'package:findmotto/splash_screen/splash_screen.dart';
import 'package:findmotto/themeProvider/themeProvider.dart';
import 'package:provider/provider.dart';

Future<void> main() async {

  runApp(const MyApp());

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
}

//hellooiiiigit


class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppInfo(),
      child: MaterialApp(
      title: 'Flutter Demo',
      themeMode:  ThemeMode.system,
      theme: MyThemes.lightTheme,
      darkTheme: MyThemes.darkTheme,
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),

    ),
      
      );
  }
}
