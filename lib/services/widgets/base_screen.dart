// Import necessary Flutter and app-specific dependencies
import 'package:flutter/material.dart';

// Import menu items enum for navigation
import '../utils/menu_items.dart';

// Import all screens for navigation
import '../screens/main_dashboard_screen.dart';
import '../screens/demographics_screen.dart';
import '../screens/allergies_screen.dart';
import '../screens/immunizations_screen.dart';
import '../screens/medication_screen.dart';
import '../screens/problem_list_screen.dart';
import '../screens/procedures_screen.dart';
import '../screens/login_screen.dart';
import '../auth_service.dart';

// BaseScreen is a stateless widget that provides a consistent layout
// and navigation structure for all screens in the application
class BaseScreen extends StatelessWidget {
  // Title of the current screen
  final String title;

  // Main content of the screen
  final Widget body;

  // Optional floating action button
  final Widget? floatingActionButton;

  // Username for the current user
  final String username;

  // Constructor with named parameters
  const BaseScreen({
    super.key,
    required this.title,
    required this.body,
    required this.username,
    this.floatingActionButton,
  });

  // Method to handle navigation between screens
  void _navigateToScreen(BuildContext context, MenuItems item) {
    // Close the drawer before navigation
    Navigator.of(context).pop();

    // Select the appropriate screen based on the menu item
    Widget screen;
    switch (item) {
      case MenuItems.home:
      // Special handling for home screen
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

    // Navigate to the selected screen
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
    // Define the primary color for the app
    final welcomeBlue = Color(0xFF10c9b7);

    return Scaffold(
      // App bar with custom title design
      appBar: AppBar(
        // Removes the default back button
        automaticallyImplyLeading: false,

        // Custom title with a pill-shaped container
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

        // Actions including sign out button
        actions: [
          // Sign out button
          if (title != 'Login') // Don't show on login screen
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
                      await AuthService.clearCredentials();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
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
          // Menu button
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
      ),

      // Main content of the screen
      body: body,

      // Optional floating action button
      floatingActionButton: floatingActionButton,

      // End drawer for navigation
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Drawer header
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

            // Drawer menu items
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

  // Helper method to build drawer menu items
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