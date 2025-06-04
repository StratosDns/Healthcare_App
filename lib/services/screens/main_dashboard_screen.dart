// Import necessary Flutter and package dependencies
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../providers/dashboard_provider.dart';
import '../providers/user_provider.dart';
import '../providers/allergies_provider.dart';
import '../providers/demographics_provider.dart';
import '../providers/immunizations_provider.dart';
import '../providers/medication_provider.dart';
import '../providers/problem_list_provider.dart';
import '../providers/procedures_provider.dart';

import '../api_service.dart';
import '../auth_service.dart';
import '../health_record_service.dart';

import '../widgets/dashboard_item_tile.dart';
import '../widgets/user_info_card.dart';

import '../utils/menu_items.dart';

import 'demographics_screen.dart';
import 'allergies_screen.dart';
import 'immunizations_screen.dart';
import 'medication_screen.dart';
import 'problem_list_screen.dart';
import 'procedures_screen.dart';
import 'login_screen.dart';
import 'view_records_screen.dart';

class MainDashboardScreen extends StatefulWidget {
  final String username;

  const MainDashboardScreen({super.key, required this.username});

  @override
  _MainDashboardScreenState createState() => _MainDashboardScreenState();
}

class _MainDashboardScreenState extends State<MainDashboardScreen> {
  String quote = 'Loading...';
  File? _image;
  String selectedCategory = 'Allergies';
  final ImagePicker _picker = ImagePicker();

  final List<String> categories = [
    'Allergies',
    'Immunizations',
    'Medication',
    'Problem List',
    'Procedures'
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
      _setUsernameInProviders();
    });
    _loadQuote();
  }

  void _setUsernameInProviders() {
    Provider.of<AllergiesProvider>(context, listen: false).setUsername(widget.username);
    Provider.of<DemographicsProvider>(context, listen: false).setUsername(widget.username);
    Provider.of<ImmunizationsProvider>(context, listen: false).setUsername(widget.username);
    Provider.of<MedicationProvider>(context, listen: false).setUsername(widget.username);
    Provider.of<ProblemListProvider>(context, listen: false).setUsername(widget.username);
    Provider.of<ProceduresProvider>(context, listen: false).setUsername(widget.username);
    Provider.of<UserProvider>(context, listen: false).setLoggedInUser(widget.username);
  }

  Future<void> _loadQuote() async {
    try {
      final newQuote = await ApiService.getRandomQuote();
      setState(() {
        quote = newQuote;
      });
    } catch (e) {
      setState(() {
        quote = 'Be healthy, be happy!';
      });
    }
  }

  void _loadInitialData() {
    Provider.of<UserProvider>(context, listen: false).fetchUserInfo();
    Provider.of<DashboardProvider>(context, listen: false).fetchDashboardItems(context, widget.username);
  }

  void _navigateToScreen(MenuItems item) {
    Widget screen;
    switch (item) {
      case MenuItems.demographics:
        screen = DemographicsScreen(username: widget.username);
        break;
      case MenuItems.allergies:
        screen = AllergiesScreen(username: widget.username);
        break;
      case MenuItems.immunizations:
        screen = ImmunizationsScreen(username: widget.username);
        break;
      case MenuItems.medication:
        screen = MedicationScreen(username: widget.username);
        break;
      case MenuItems.problemList:
        screen = ProblemListScreen(username: widget.username);
        break;
      case MenuItems.procedures:
        screen = ProceduresScreen(username: widget.username);
        break;
      default:
        return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    final welcomeBlue = const Color(0xFF10c9b7);

    return Scaffold(
      appBar: AppBar(
        title: Container(
          decoration: BoxDecoration(
            color: welcomeBlue.withOpacity(0.1),
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
                const TextSpan(
                  text: 'Health Dashboard',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
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
                    // UPDATED: Use AuthService.logout instead of clearCredentials
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
      body: RefreshIndicator(
        onRefresh: _loadQuote,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Card(
                margin: const EdgeInsets.all(16.0),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        'Daily Quote',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        quote,
                        style: const TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      TextButton.icon(
                        onPressed: _loadQuote,
                        icon: const Icon(Icons.refresh),
                        label: const Text('New Quote'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Selector<UserProvider, String>(
                selector: (context, userProvider) =>
                userProvider.currentUser?.firstName ?? widget.username,
                builder: (context, firstName, child) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Welcome, $firstName',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: welcomeBlue,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              ),
            ),
            const SliverToBoxAdapter(
              child: UserInfoCard(),
            ),
            Consumer<DashboardProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (provider.error != null) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Text('Error: ${provider.error}'),
                    ),
                  );
                }
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      final item = provider.dashboardItems[index];
                      return DashboardItemTile(
                        item: item,
                        username: widget.username,
                      );
                    },
                    childCount: provider.dashboardItems.length,
                  ),
                );
              },
            ),
          ],
        ),
      ),
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
                    'Logged in as: ${widget.username}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            _buildDrawerItem(
                icon: Icons.person,
                title: 'Demographics',
                item: MenuItems.demographics),
            _buildDrawerItem(
                icon: Icons.warning,
                title: 'Allergies',
                item: MenuItems.allergies),
            _buildDrawerItem(
                icon: Icons.medical_services,
                title: 'Immunizations',
                item: MenuItems.immunizations),
            _buildDrawerItem(
                icon: Icons.medication,
                title: 'Medication',
                item: MenuItems.medication),
            _buildDrawerItem(
                icon: Icons.list,
                title: 'Problem List',
                item: MenuItems.problemList),
            _buildDrawerItem(
                icon: Icons.medical_information,
                title: 'Procedures',
                item: MenuItems.procedures),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('View Health Records'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewRecordsScreen(username: widget.username),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ViewRecordsScreen(username: widget.username),
            ),
          );
        },
        child: const Icon(Icons.photo_library),
        tooltip: 'View Health Records',
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required MenuItems item,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.of(context).pop();
        _navigateToScreen(item);
      },
    );
  }
}