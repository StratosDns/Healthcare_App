import '../models/medication_model.dart';

class MedicationService {
  // CHANGE: Rename method and add username parameter
  Future<List<MedicationModel>> fetchMedicationsForUser(String username) async {
    await Future.delayed(const Duration(seconds: 1));

    // ADD: Username-based filtering (mock implementation)
    if (username == 'jsmith') {
      return [
        MedicationModel(
          date: 'March 28, 2005',
          type: 'Liquid',
          medicationName: 'Acetaminophen with codeine',
          instructions: '2 puffs once a day',
          doseQuantityValue: '2',
          doseQuantityUnit: 'puffs',
          rateQuantityValue: '1',
          rateQuantityUnit: 'day',
          prescriber: 'Ashby Medical Center',
        ),
        MedicationModel(
          date: 'December 10, 2003',
          type: 'Tablet',
          medicationName: 'Indomethacin',
          instructions: '50mg bid with food',
          doseQuantityValue: '50',
          doseQuantityUnit: 'mg',
          rateQuantityValue: '2',
          rateQuantityUnit: 'day',
          prescriber: 'Ashby Medical Center',
        ),
        MedicationModel(
          date: 'Current',
          type: 'Tablet',
          medicationName: 'Lisinopril',
          instructions: '10mg once daily',
          doseQuantityValue: '10',
          doseQuantityUnit: 'mg',
          rateQuantityValue: '1',
          rateQuantityUnit: 'day',
          prescriber: 'Dr. Johnson',
        ),
      ];
    } else {
      // Return different data for other users
      return [
        MedicationModel(
          date: 'Current',
          type: 'Tablet',
          medicationName: 'Aspirin',
          instructions: '81mg once daily',
          doseQuantityValue: '81',
          doseQuantityUnit: 'mg',
          rateQuantityValue: '1',
          rateQuantityUnit: 'day',
          prescriber: 'General Practitioner',
        ),
      ];
    }
  }
}