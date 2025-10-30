import 'package:flutter/material.dart';
import 'package:s/pages/edit_akun_page.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';
import 'pages/reminder_page.dart';
import 'pages/akun_page.dart';
import 'pages/booking_page.dart';
import 'pages/kategori_page.dart';





void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     
      debugShowCheckedModeBanner: false,
      initialRoute: '/home',//Lewati login
      routes: {
        '/': (context) => LoginPage(),
        '/home': (context) => CASMainPage(),
        '/reminder': (context) => ReminderPage(),
        '/akun': (context) => AkunPage(),
        '/edit-akun':  (context) => EditAkunPage(),
        '/booking':  (context) => BookingPage(),
        '/kategori': (context) => CategoryPage(),
        
      },
    );
  }
}
