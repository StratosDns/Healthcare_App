// Import necessary Flutter and package dependencies
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart'; // ADD: image picker
import 'dart:io'; // ADD: for File

// Import the allergies provider for state management
import '../health_record_service.dart';
import '../providers/allergies_provider.dart';

// Import the base screen widget for consistent screen layout
import '../widgets/base_screen.dart';

// AllergiesScreen is a stateful widget to manage screen-specific state
class AllergiesScreen extends StatefulWidget {
  final String username; // ADD: username parameter

  // CHANGE: Constructor to require username
  const AllergiesScreen({super.key, required this.username});

  @override
  _AllergiesScreenState createState() => _AllergiesScreenState();
}

// State class for AllergiesScreen
class _AllergiesScreenState extends State<AllergiesScreen> {
  final ImagePicker _picker = ImagePicker(); // ADD: image picker instance

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ADD: Set username before fetching data
      Provider.of<AllergiesProvider>(context, listen: false).setUsername(widget.username);
      Provider.of<AllergiesProvider>(context, listen: false).fetchAllergies();
    });
  }

  // ADD: Method to handle photo capture
  Future<void> _addPhotoRecord() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        final file = File(pickedFile.path);

        // Show loading dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => Center(child: CircularProgressIndicator()),
        );

        await HealthRecordService.saveHealthRecord(
          file,
          'Allergies',
          widget.username,
        );

        // Close loading dialog
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Photo saved to Allergies'),
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
    // Use BaseScreen for consistent screen layout
    return BaseScreen(
      title: 'Allergies',
      username: widget.username, // ADD: pass username to BaseScreen

      // ADD: Floating action button for camera
      floatingActionButton: FloatingActionButton(
        onPressed: _addPhotoRecord,
        child: const Icon(Icons.camera_alt),
        tooltip: 'Add Photo',
      ),

      body: Consumer<AllergiesProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(
              child: Text('Error: ${provider.error}'),
            );
          }

          if (provider.allergies.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.warning_amber_rounded, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No allergies found',
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
            itemCount: provider.allergies.length,
            itemBuilder: (context, index) {
              final allergy = provider.allergies[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Allergy Name: ${allergy.allergyName}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('Reaction: ${allergy.reaction}'),
                      Text('Severity: ${allergy.severity}'),
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