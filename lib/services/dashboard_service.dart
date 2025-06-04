class DashboardService {
  // CHANGE: Add username parameter to method
  Future<List<Map<String, dynamic>>> fetchDashboardItemsForUser(String username) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // ADD: Username-based filtering (mock implementation)
    if (username == 'jsmith') {
      return [
        {
          'title': 'Allergies',
          'icon': 'assets/images/logo.png',
          'count': 3,
        },
        {
          'title': 'Immunizations',
          'icon': 'assets/images/logo.png',
          'count': 3,
        },
        {
          'title': 'Medication',
          'icon': 'assets/images/logo.png',
          'count': 3,
        },
        {
          'title': 'Problem List',
          'icon': 'assets/images/logo.png',
          'count': 3,
        },
        {
          'title': 'Procedures',
          'icon': 'assets/images/logo.png',
          'count': 3,
        },
        {
          'title': 'Demographics',
          'icon': 'assets/images/logo.png',
          'count': 1,
        },
      ];
    } else {
      // Return different counts for other users
      return [
        {
          'title': 'Allergies',
          'icon': 'assets/images/logo.png',
          'count': 1,
        },
        {
          'title': 'Immunizations',
          'icon': 'assets/images/logo.png',
          'count': 1,
        },
        {
          'title': 'Medication',
          'icon': 'assets/images/logo.png',
          'count': 1,
        },
        {
          'title': 'Problem List',
          'icon': 'assets/images/logo.png',
          'count': 1,
        },
        {
          'title': 'Procedures',
          'icon': 'assets/images/logo.png',
          'count': 1,
        },
        {
          'title': 'Demographics',
          'icon': 'assets/images/logo.png',
          'count': 1,
        },
      ];
    }
  }
}