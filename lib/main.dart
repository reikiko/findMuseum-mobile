import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/hex_color.dart';
import 'package:findMuseum_mobile/screens/auth/login_page.dart';
import 'package:findMuseum_mobile/screens/auth/register_page.dart';
import 'package:findMuseum_mobile/screens/home/home.dart';
import 'package:findMuseum_mobile/screens/main_page.dart';
import 'package:findMuseum_mobile/screens/splash_screen/splash.dart';
import 'package:findMuseum_mobile/services/shared_services.dart';

Widget _defaultHome = const LoginPage();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool _result = await SharedServices.isLoggedIn();
  if (_result) {
    _defaultHome = const MainPage();
  }
  runApp(const MyApp());
}

class extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: "Rubik",
        primaryColor: HexColor('#70DAD3'),
        backgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: HexColor("#EC8C6F"),
          background: HexColor("#DEFDFB"),
        ),
      ),
      // initialRoute: '/splash',
      routes: {
        '/': (context) => _defaultHome,
        '/splash': (context) => const Splash(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage()
      },
    );
  }
}
