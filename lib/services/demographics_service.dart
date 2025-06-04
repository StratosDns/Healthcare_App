import '../models/demographics_model.dart';

class DemographicsService {
  // CHANGE: Rename method and add username parameter
  Future<DemographicsModel> fetchDemographicsForUser(String username) async {
    await Future.delayed(const Duration(seconds: 1));

    // ADD: Username-based data (mock implementation)
    if (username == 'jsmith') {
      return DemographicsModel(
        firstName: 'John',
        lastName: 'Smith',
        gender: 'Male',
        maritalStatus: 'Married',
        religiousAffiliation: 'Christian',
        ethnicity: 'Caucasian',
        languageSpoken: 'English',
        address: '123 Main St, New York, NY 10001',
        telephone: '555-123-4567',
        birthday: 'January 15, 1980',
      );
    } else {
      // Return the original default data for other users
      return DemographicsModel(
        firstName: 'Efstratios',
        lastName: 'Demertzoglou',
        gender: 'Male',
        maritalStatus: '-',
        religiousAffiliation: '-',
        ethnicity: 'Greek',
        languageSpoken: 'English/Greek',
        address: 'Agiou Mina 13, Irakleio, GR 71201',
        telephone: '6980869076',
        birthday: 'May 16, 2003',
      );
    }
  }
}