import 'package:flutter/foundation.dart';
import '../../models/procedures_model.dart';
import '../procedures_service.dart';

class ProceduresProvider with ChangeNotifier {
  List<ProceduresModel> _procedures = [];
  bool _isLoading = false;
  String? _error;
  String? _username; // ADD: username field

  List<ProceduresModel> get procedures => _procedures;
  int get proceduresCount => _procedures.length;
  bool get isLoading => _isLoading;
  String? get error => _error;

  final ProceduresService _proceduresService = ProceduresService();

  // ADD: setUsername method
  void setUsername(String username) {
    _username = username;
  }

  Future<void> fetchProcedures() async {
    if (_username == null) return; // ADD: username check

    try {
      _isLoading = true;
      notifyListeners();

      // CHANGE: Call new method with username
      _procedures = await _proceduresService.fetchProceduresForUser(_username!);
      print('Procedures count: ${_procedures.length}');
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