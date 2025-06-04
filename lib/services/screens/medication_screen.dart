import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart'; // ADD: image picker
import 'dart:io'; // ADD: for File
import '../health_record_service.dart';
import '../providers/medication_provider.dart';
import '../widgets/base_screen.dart';

class MedicationScreen extends StatefulWidget {
  final String username; // ADD: username parameter

  // CHANGE: Constructor to require username
  const MedicationScreen({super.key, required this.username});

  @override
  _MedicationScreenState createState() => _MedicationScreenState();
}

class _MedicationScreenState extends State<MedicationScreen> {
  final ImagePicker _picker = ImagePicker(); // ADD: image picker instance

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ADD: Set username before fetching data
      Provider.of<MedicationProvider>(context, listen: false).setUsername(widget.username);
      Provider.of<MedicationProvider>(context, listen: false).fetchMedications();
    });
  }

  // ADD: Method to handle photo capture
  Future<void> _addPhotoRecord() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        final file = File(pickedFile.path);

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => Center(child: CircularProgressIndicator()),
        );

        await HealthRecordService.saveHealthRecord(
          file,
          'Medication',
          widget.username,
        );

        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Photo saved to Medication'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save photo: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Medication',
      username: widget.username, // ADD: pass username to BaseScreen

      // ADD: Floating action button for camera
      floatingActionButton: FloatingActionButton(
        onPressed: _addPhotoRecord,
        child: const Icon(Icons.camera_alt),
        tooltip: 'Add Photo',
      ),

      body: Consumer<MedicationProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(
              child: Text('Error: ${provider.error}'),
            );
          }

          if (provider.medications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.medication, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No medications found',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Tap the camera button to add a photo',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: provider.medications.length,
            itemBuilder: (context, index) {
              final medication = provider.medications[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Date: ${medication.date}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('Type: ${medication.type}'),
                      Text('Name of Medication: ${medication.medicationName}'),
                      Text('Instructions: ${medication.instructions}'),
                      Text('Dose Quantity: ${medication.doseQuantityValue} ${medication.doseQuantityUnit}'),
                      Text('Rate Quantity: ${medication.rateQuantityValue} ${medication.rateQuantityUnit}'),
                      Text('Name of Prescriber: ${medication.prescriber}'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}