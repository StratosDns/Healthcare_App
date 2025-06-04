import 'package:flutter/foundation.dart';
import '../../models/problem_list_model.dart';
import '../problem_list_service.dart';

class ProblemListProvider with ChangeNotifier {
  List<ProblemListModel> _problemList = [];
  bool _isLoading = false;
  String? _error;
  String? _username; // ADD: username field

  List<ProblemListModel> get problemList => _problemList;
  bool get isLoading => _isLoading;
  String? get error => _error;

  final ProblemListService _problemListService = ProblemListService();

  // ADD: setUsername method
  void setUsername(String username) {
    _username = username;
  }

  Future<void> fetchProblemList() async {
    if (_username == null) return; // ADD: username check

    try {
      _isLoading = true;
      notifyListeners();

      // CHANGE: Call new method with username
      _problemList = await _problemListService.fetchProblemListForUser(_username!);
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