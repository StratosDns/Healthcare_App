// Import necessary Flutter and package dependencies
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart'; // ADD: image picker
import 'dart:io'; // ADD: for File

// Import providers for state management
import '../providers/dashboard_provider.dart';
import '../providers/user_provider.dart';
import '../providers/allergies_provider.dart'; // ADD: for setting username
import '../providers/demographics_provider.dart'; // ADD: for setting username
import '../providers/immunizations_provider.dart'; // ADD: for setting username
import '../providers/medication_provider.dart'; // ADD: for setting username
import '../providers/problem_list_provider.dart'; // ADD: for setting username
import '../providers/procedures_provider.dart'; // ADD: for setting username

// ADD: Import services
import '../api_service.dart';
import '../auth_service.dart';
import '../health_record_service.dart';

// Import widgets
import '../widgets/dashboard_item_tile.dart';
import '../widgets/user_info_card.dart';

// Import utility enums
import '../utils/menu_items.dart';

// Import screen navigations
import 'demographics_screen.dart';
import 'allergies_screen.dart';
import 'immunizations_screen.dart';
import 'medication_screen.dart';
import 'problem_list_screen.dart';
import 'procedures_screen.dart';
import 'login_screen.dart'; // ADD: login screen
import 'view_records_screen.dart'; // ADD: view records screen

// MainDashboardScreen is a stateful widget to manage screen-specific state
class MainDashboardScreen extends StatefulWidget {
  final String username; // ADD: username parameter

  // CHANGE: Constructor to require username
  const MainDashboardScreen({super.key, required this.username});

  // Create the mutable state for this widget
  @override
  _MainDashboardScreenState createState() => _MainDashboardScreenState();
}

// State class for MainDashboardScreen
class _MainDashboardScreenState extends State<MainDashboardScreen> {
  // ADD: New fields for quote and image functionality
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

  // Lifecycle method called when the state object is inserted into the widget tree
  @override
  void initState() {
    super.initState();

    // Use WidgetsBinding to ensure the widget is built before fetching data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Load initial data for the dashboard
      _loadInitialData();
      _setUsernameInProviders(); // ADD: Set username for all providers
    });
    _loadQuote(); // ADD: Load quote
  }

  // ADD: Method to set username in all providers
  void _setUsernameInProviders() {
    Provider.of<AllergiesProvider>(context, listen: false).setUsername(widget.username);
    Provider.of<DemographicsProvider>(context, listen: false).setUsername(widget.username);
    Provider.of<ImmunizationsProvider>(context, listen: false).setUsername(widget.username);
    Provider.of<MedicationProvider>(context, listen: false).setUsername(widget.username);
    Provider.of<ProblemListProvider>(context, listen: false).setUsername(widget.username);
    Provider.of<ProceduresProvider>(context, listen: false).setUsername(widget.username);
    Provider.of<UserProvider>(context, listen: false).setLoggedInUser(widget.username);
  }

  // ADD: Method to load quote
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

  // Method to load initial data from providers
  void _loadInitialData() {
    // Fetch user information without listening to changes
    Provider.of<UserProvider>(context, listen: false).fetchUserInfo();

    // CHANGE: Pass username to fetchDashboardItems
    Provider.of<DashboardProvider>(context, listen: false).fetchDashboardItems(context, widget.username);
  }

  // CHANGE: Update navigation to pass username
  void _navigateToScreen(MenuItems item) {
    // Select the appropriate screen based on the menu item
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

    // Navigate to the selected screen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Define the primary color for the app
    final welcomeBlue = Color(0xFF10c9b7);

    return Scaffold(
      // App bar with custom title design
      appBar: AppBar(
        title: Container(
          // Decorative container for the title
          decoration: BoxDecoration(
            color: const Color(0xFF10c9b7).withOpacity(0.1),
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: RichText(
            // Rich text to style different parts of the title
            text: TextSpan(
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              children: [
                // "My" in a distinct color and larger size
                TextSpan(
                  text: 'My ',
                  style: TextStyle(
                    color: welcomeBlue,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                // Rest of the title
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
        // ADD: Sign out button
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
                        title: Text('Sign Out'),
                        content: Text('Are you sure you want to sign out?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: Text('Sign Out'),
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
                child: Text(
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

      // CHANGE: Add RefreshIndicator for quote
      body: RefreshIndicator(
        onRefresh: _loadQuote,
        child: CustomScrollView(
            slivers: [
        // ADD: Quote Card
        SliverToBoxAdapter(
        child: Card(
        margin: EdgeInsets.all(16.0),
        elevation: 4,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                'Daily Quote',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                quote,
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              TextButton.icon(
                onPressed: _loadQuote,
                icon: Icon(Icons.refresh),
                label: Text('New Quote'),
              ),
            ],
          ),
        ),
      ),
    ),

              // Welcome message using Selector for efficient updates
              SliverToBoxAdapter(
                child: Selector<UserProvider, String>(
                  selector: (context, userProvider) =>
                  userProvider.currentUser?.firstName ?? widget.username, // CHANGE: use widget.username as fallback
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

              // User Info Card
              const SliverToBoxAdapter(
                child: UserInfoCard(),
              ),

              // Dashboard Items with loading and error handling
              Consumer<DashboardProvider>(
                builder: (context, provider, child) {
                  // Show loading indicator while fetching data
                  if (provider.isLoading) {
                    return const SliverToBoxAdapter(
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  // Show error message if data fetching fails
                  if (provider.error != null) {
                    return SliverToBoxAdapter(
                      child: Center(
                        child: Text('Error: ${provider.error}'),
                      ),
                    );
                  }

                  // Create a scrollable list of dashboard items
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        final item = provider.dashboardItems[index];
                        return DashboardItemTile(
                          item: item,
                          username: widget.username, // ADD: pass username
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
                    'Logged in as: ${widget.username}', // ADD: show username
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            // Drawer menu items
            _buildDrawerItem(
                icon: Icons.person,
                title: 'Demographics',
                item: MenuItems.demographics
            ),
            _buildDrawerItem(
                icon: Icons.warning,
                title: 'Allergies',
                item: MenuItems.allergies
            ),
            _buildDrawerItem(
                icon: Icons.medical_services,
                title: 'Immunizations',
                item: MenuItems.immunizations
            ),
            _buildDrawerItem(
                icon: Icons.medication,
                title: 'Medication',
                item: MenuItems.medication
            ),
            _buildDrawerItem(
                icon: Icons.list,
                title: 'Problem List',
                item: MenuItems.problemList
            ),
            _buildDrawerItem(
                icon: Icons.medical_information,
                title: 'Procedures',
                item: MenuItems.procedures
            ),
            const Divider(), // ADD: divider
            // ADD: View Health Records
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('View Health Records'),
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

      // ADD: Floating action button for viewing records
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ViewRecordsScreen(username: widget.username),
            ),
          );
        },
        child: Icon(Icons.photo_library),
        tooltip: 'View Health Records',
      ),
    );
  }

  // Helper method to build drawer menu items
  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required MenuItems item,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        // Close the drawer
        Navigator.of(context).pop();
        // Navigate to the selected screen
        _navigateToScreen(item);
      },
    );
  }
}