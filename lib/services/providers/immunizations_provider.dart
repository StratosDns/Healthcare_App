import 'package:flutter/foundation.dart';
import '../../models/immunization_model.dart';
import '../immunizations_service.dart';

class ImmunizationsProvider with ChangeNotifier {
  List<ImmunizationModel> _immunizations = [];
  bool _isLoading = false;
  String? _error;
  String? _username;

  List<ImmunizationModel> get immunizations => _immunizations;
  bool get isLoading => _isLoading;
  String? get error => _error;

  final ImmunizationsService _immunizationsService = ImmunizationsService();

  void setUsername(String username) {
    _username = username;
  }

  Future<void> fetchImmunizations() async {
    if (_username == null) return;

    try {
      _isLoading = true;
      notifyListeners();

      _immunizations = await _immunizationsService.fetchImmunizationsForUser(_username!);
      _isLoading = false;
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
}