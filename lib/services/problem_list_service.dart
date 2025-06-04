import '../models/problem_list_model.dart';

class ProblemListService {
  // CHANGE: Rename method and add username parameter
  Future<List<ProblemListModel>> fetchProblemListForUser(String username) async {
    await Future.delayed(const Duration(seconds: 1));

    // ADD: Username-based filtering (mock implementation)
    if (username == 'jsmith') {
      return [
        ProblemListModel(
          observation: 'Ankle Sprain',
          status: 'Active',
          date: 'March 28, 2005',
          comments: 'Slipped on ice and fell.',
        ),
        ProblemListModel(
          observation: 'Cholecystitis',
          status: 'Resolved',
          date: 'September 28, 2002',
          comments: 'Surgery postponed until after delivery',
        ),
        ProblemListModel(
          observation: 'Hypertension',
          status: 'Active',
          date: 'January 15, 2020',
          comments: 'Controlled with medication',
        ),
      ];
    } else {
      // Return different data for other users
      return [
        ProblemListModel(
          observation: 'Migraine',
          status: 'Active',
          date: 'June 10, 2023',
          comments: 'Occasional episodes',
        ),
      ];
    }
  }
}