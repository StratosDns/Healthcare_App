import '../models/procedures_model.dart';

class ProceduresService {
  // CHANGE: Rename method and add username parameter
  Future<List<ProceduresModel>> fetchProceduresForUser(String username) async {
    await Future.delayed(const Duration(seconds: 1));

    // ADD: Username-based filtering (mock implementation)
    if (username == 'jsmith') {
      return [
        ProceduresModel(
          procedure: 'Laparoscopic Cholecystectomy',
          date: 'September 28, 2002',
          provider: 'Dr. Antonios Papageorgiou',
          location: 'Ashby Medical Center',
        ),
        ProceduresModel(
          procedure: 'Cesarian Section',
          date: 'March 22, 2002',
          provider: 'Dr. Georgios Papantoniou',
          location: 'Ashby Medical Center',
        ),
        ProceduresModel(
          procedure: 'Colonoscopy',
          date: 'July 15, 2021',
          provider: 'Dr. Sarah Chen',
          location: 'General Hospital',
        ),
      ];
    } else {
      // Return different data for other users
      return [
        ProceduresModel(
          procedure: 'MRI Scan',
          date: 'February 20, 2023',
          provider: 'Radiology Department',
          location: 'City Medical Center',
        ),
      ];
    }
  }
}