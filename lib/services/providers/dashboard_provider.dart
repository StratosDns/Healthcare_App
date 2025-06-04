import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/dashboard_item_model.dart';
import '../screens/allergies_screen.dart';
import '../screens/immunizations_screen.dart';
import '../screens/medication_screen.dart';
import '../screens/problem_list_screen.dart';
import '../screens/procedures_screen.dart';
import '../screens/demographics_screen.dart';
import 'allergies_provider.dart';
import 'immunizations_provider.dart';
import 'medication_provider.dart';
import 'problem_list_provider.dart';
import 'procedures_provider.dart';

class DashboardProvider with ChangeNotifier {
  List<DashboardItemModel> _dashboardItems = [];
  bool _isLoading = false;
  String? _error;
  String? _username; // ADD: username field

  List<DashboardItemModel> get dashboardItems => _dashboardItems;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // ADD: setUsername method
  void setUsername(String username) {
    _username = username;
  }

  // CHANGE: Add username parameter
  Future<void> fetchDashboardItems(BuildContext context, String username) async {
    try {
      _username = username; // Store username
      _isLoading = true;
      notifyListeners();

      // Set username for all providers before fetching
      Provider.of<AllergiesProvider>(context, listen: false).setUsername(username);
      Provider.of<ImmunizationsProvider>(context, listen: false).setUsername(username);
      Provider.of<MedicationProvider>(context, listen: false).setUsername(username);
      Provider.of<ProblemListProvider>(context, listen: false).setUsername(username);
      Provider.of<ProceduresProvider>(context, listen: false).setUsername(username);

      // Ensure providers have fetched their data
      await Future.wait([
        Provider.of<AllergiesProvider>(context, listen: false).fetchAllergies(),
        Provider.of<ImmunizationsProvider>(context, listen: false).fetchImmunizations(),
        Provider.of<MedicationProvider>(context, listen: false).fetchMedications(),
        Provider.of<ProblemListProvider>(context, listen: false).fetchProblemList(),
        Provider.of<ProceduresProvider>(context, listen: false).fetchProcedures(),
      ]);

      // Get counts after fetching
      final allergiesCount = Provider.of<AllergiesProvider>(context, listen: false).allergies.length;
      final immunizationsCount = Provider.of<ImmunizationsProvider>(context, listen: false).immunizations.length;
      final medicationCount = Provider.of<MedicationProvider>(context, listen: false).medications.length;
      final problemListCount = Provider.of<ProblemListProvider>(context, listen: false).problemList.length;
      final proceduresCount = Provider.of<ProceduresProvider>(context, listen: false).proceduresCount;

      // Debug prints
      print('Allergies count: $allergiesCount');
      print('Immunizations count: $immunizationsCount');
      print('Medication count: $medicationCount');
      print('Problem List count: $problemListCount');
      print('Procedures count: $proceduresCount');

      // CHANGE: Update pageBuilder to pass username
      _dashboardItems = [
        DashboardItemModel(
          title: 'Allergies',
          icon: 'assets/images/logo.png',
          count: allergiesCount,
          pageBuilder: (username) => AllergiesScreen(username: username),
        ),
        DashboardItemModel(
          title: 'Immunizations',
          icon: 'assets/images/logo.png',
          count: immunizationsCount,
          pageBuilder: (username) => ImmunizationsScreen(username: username),
        ),
        DashboardItemModel(
          title: 'Medication',
          icon: 'assets/images/logo.png',
          count: medicationCount,
          pageBuilder: (username) => MedicationScreen(username: username),
        ),
        DashboardItemModel(
          title: 'Problem List',
          icon: 'assets/images/logo.png',
          count: problemListCount,
          pageBuilder: (username) => ProblemListScreen(username: username),
        ),
        DashboardItemModel(
          title: 'Procedures',
          icon: 'assets/images/logo.png',
          count: proceduresCount,
          pageBuilder: (username) => ProceduresScreen(username: username),
        ),
        DashboardItemModel(
          title: 'Demographics',
          icon: 'assets/images/logo.png',
          count: 1,
          pageBuilder: (username) => DemographicsScreen(username: username),
        ),
      ];

      _isLoading = false;
      _error = null;
      notifyListeners();
    } catch (e) {
      print('Error in fetchDashboardItems: $e');
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
}