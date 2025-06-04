import 'package:flutter/foundation.dart';
import '../../models/demographics_model.dart';
import '../demographics_service.dart';

class DemographicsProvider with ChangeNotifier {
  DemographicsModel? _demographics;
  bool _isLoading = false;
  String? _error;
  String? _username;

  DemographicsModel? get demographics => _demographics;
  bool get isLoading => _isLoading;
  String? get error => _error;

  final DemographicsService _demographicsService = DemographicsService();

  void setUsername(String username) {
    _username = username;
  }

  Future<void> fetchDemographics() async {

    if (_username == null) return;
    try {
      _isLoading = true;
      notifyListeners();

      _demographics = await _demographicsService.fetchDemographicsForUser(_username!);
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