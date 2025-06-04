import 'package:flutter/material.dart';

import '../utils/menu_items.dart';
import '../screens/main_dashboard_screen.dart';
import '../screens/demographics_screen.dart';
import '../screens/allergies_screen.dart';
import '../screens/immunizations_screen.dart';
import '../screens/medication_screen.dart';
import '../screens/problem_list_screen.dart';
import '../screens/procedures_screen.dart';
import '../screens/login_screen.dart';
import '../auth_service.dart';

class BaseScreen extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget? floatingActionButton;
  final String username;

  const BaseScreen({
    super.key,
    required this.title,
    required this.body,
    required this.username,
    this.floatingActionButton,
  });

  void _navigateToScreen(BuildContext context, MenuItems item) {
    Navigator.of(context).pop();

    Widget screen;
    switch (item) {
      case MenuItems.home:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => MainDashboardScreen(username: username),
            settings: RouteSettings(name: '/', arguments: {'username': username}),
          ),
              (route) => false,
        );
        return;
      case MenuItems.demographics:
        screen = DemographicsScreen(username: username);
        break;
      case MenuItems.allergies:
        screen = AllergiesScreen(username: username);
        break;
      case MenuItems.immunizations:
        screen = ImmunizationsScreen(username: username);
        break;
      case MenuItems.medication:
        screen = MedicationScreen(username: username);
        break;
      case MenuItems.problemList:
        screen = ProblemListScreen(username: username);
        break;
      case MenuItems.procedures:
        screen = ProceduresScreen(username: username);
        break;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => screen,
        settings: RouteSettings(arguments: {'username': username}),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final welcomeBlue = const Color(0xFF10c9b7);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Container(
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              children: [
                TextSpan(
                  text: 'My ',
                  style: TextStyle(
                    color: welcomeBlue,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text: title,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          if (title != 'Login')
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.red[400],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextButton(
                  onPressed: () async {
                    final bool? confirm = await showDialog<bool>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Sign Out'),
                          content: const Text('Are you sure you want to sign out?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text('Sign Out'),
                            ),
                          ],
                        );
                      },
                    );

                    if (confirm == true) {
                      // UPDATED: Use AuthService.logout for multi-user support
                      await AuthService.logout();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                            (route) => false,
                      );
                    }
                  },
                  child: const Text(
                    'Sign Out',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
      ),
      body: body,
      floatingActionButton: floatingActionButton,
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: welcomeBlue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    'Health Dashboard Menu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Logged in as: $username',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            _buildDrawerItem(
              context,
              icon: Icons.home,
              title: 'Home',
              item: MenuItems.home,
            ),
            _buildDrawerItem(
              context,
              icon: Icons.person,
              title: 'Demographics',
              item: MenuItems.demographics,
            ),
            _buildDrawerItem(
              context,
              icon: Icons.warning,
              title: 'Allergies',
              item: MenuItems.allergies,
            ),
            _buildDrawerItem(
              context,
              icon: Icons.medical_services,
              title: 'Immunizations',
              item: MenuItems.immunizations,
            ),
            _buildDrawerItem(
              context,
              icon: Icons.medication,
              title: 'Medication',
              item: MenuItems.medication,
            ),
            _buildDrawerItem(
              context,
              icon: Icons.list,
              title: 'Problem List',
              item: MenuItems.problemList,
            ),
            _buildDrawerItem(
              context,
              icon: Icons.medical_information,
              title: 'Procedures',
              item: MenuItems.procedures,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
      BuildContext context, {
        required IconData icon,
        required String title,
        required MenuItems item,
      }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () => _navigateToScreen(context, item),
    );
  }
}