import 'package:flutter/material.dart';
import '../auth_service.dart';
import 'login_screen.dart';
import 'main_dashboard_screen.dart'; // Change from MainDashboardScreen

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () async {
      bool loggedIn = await AuthService.isLoggedIn();
      String? username = await AuthService.getCurrentUser();
      if (loggedIn && username != null && username.isNotEmpty) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => MainDashboardScreen(username: username),
        ));
      } else {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 20),
            Text(
              'Personal Health Record',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}