import '../models/allergy_model.dart';

class AllergiesService {
  // CHANGE: Rename method and add username parameter
  Future<List<AllergyModel>> fetchAllergiesForUser(String username) async {
    await Future.delayed(const Duration(seconds: 1));

    // ADD: Username-based filtering (mock implementation)
    if (username == 'jsmith') {
      return [
        AllergyModel(
          allergyName: 'Penicillin',
          reaction: 'Hives',
          severity: 'Moderate to severe',
        ),
        AllergyModel(
          allergyName: 'Codeine',
          reaction: 'Shortness of Breath',
          severity: 'Moderate',
        ),
        AllergyModel(
          allergyName: 'Bee Stings',
          reaction: 'Anaphylactic Shock',
          severity: 'Severe',
        ),
      ];
    } else {
      // Return different data for other users
      return [
        AllergyModel(
          allergyName: 'Peanuts',
          reaction: 'Swelling',
          severity: 'Severe',
        ),
      ];
    }
  }
}