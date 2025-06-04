import '../models/immunization_model.dart';

class ImmunizationsService {
  // CHANGE: Rename method and add username parameter
  Future<List<ImmunizationModel>> fetchImmunizationsForUser(String username) async {
    await Future.delayed(const Duration(seconds: 1));

    // ADD: Username-based filtering (mock implementation)
    if (username == 'jsmith') {
      return [
        ImmunizationModel(
          date: 'May 2008',
          immunizationName: 'Influenza virus vaccine, IM',
          type: 'Intramuscular injection',
          doseQuantityValue: '50',
          doseQuantityUnit: 'mcg',
          educationInstructions: 'Possible flu-like symptoms for three days',
        ),
        ImmunizationModel(
          date: 'April 2013',
          immunizationName: 'Tetanus and diphtheria toxoids, IM',
          type: 'Intramuscular injection',
          doseQuantityValue: '50',
          doseQuantityUnit: 'mcg',
          educationInstructions: 'Mild pain or soreness in the local area',
        ),
        ImmunizationModel(
          date: 'March 2021',
          immunizationName: 'COVID-19 vaccine',
          type: 'Intramuscular injection',
          doseQuantityValue: '30',
          doseQuantityUnit: 'mcg',
          educationInstructions: 'Possible fatigue and arm soreness',
        ),
      ];
    } else {
      // Return different data for other users
      return [
        ImmunizationModel(
          date: 'January 2022',
          immunizationName: 'Influenza virus vaccine, IM',
          type: 'Intramuscular injection',
          doseQuantityValue: '50',
          doseQuantityUnit: 'mcg',
          educationInstructions: 'Annual flu shot',
        ),
      ];
    }
  }
}