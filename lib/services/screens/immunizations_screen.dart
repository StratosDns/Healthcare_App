import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart'; // ADD: image picker
import 'dart:io'; // ADD: for File
import '../health_record_service.dart';
import '../providers/immunizations_provider.dart';
import '../widgets/base_screen.dart';

class ImmunizationsScreen extends StatefulWidget {
  final String username; // ADD: username parameter

  // CHANGE: Constructor to require username
  const ImmunizationsScreen({super.key, required this.username});

  @override
  _ImmunizationsScreenState createState() => _ImmunizationsScreenState();
}

class _ImmunizationsScreenState extends State<ImmunizationsScreen> {
  final ImagePicker _picker = ImagePicker(); // ADD: image picker instance

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ADD: Set username before fetching data
      Provider.of<ImmunizationsProvider>(context, listen: false).setUsername(widget.username);
      Provider.of<ImmunizationsProvider>(context, listen: false).fetchImmunizations();
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
          'Immunizations',
          widget.username,
        );

        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Photo saved to Immunizations'),
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
        title: 'Immunizations',
        username: widget.username, // ADD: pass username to BaseScreen

        // ADD: Floating action button for camera
        floatingActionButton: FloatingActionButton(
          onPressed: _addPhotoRecord,
          child: const Icon(Icons.camera_alt),
          tooltip: 'Add Photo',
        ),

        body: Consumer<ImmunizationsProvider>(
        builder: (context, provider, child) {
      if (provider.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      if (provider.error != null) {
        return Center(
          child: Text('Error: ${provider.error}'),
        );
      }

      if (provider.immunizations.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.medical_services, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'No immunizations found',
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
        itemCount: provider.immunizations.length,
        itemBuilder: (context, index) {
          final immunization = provider.immunizations[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Date: ${immunization.date}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('Immunization: ${immunization.immunizationName}'),
                  Text('Type: ${immunization.type}'),
                  Text('Dose: ${immunization.doseQuantityValue} ${immunization.doseQuantityUnit}'),
                  Text('Instructions: ${immunization.educationInstructions}'),
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