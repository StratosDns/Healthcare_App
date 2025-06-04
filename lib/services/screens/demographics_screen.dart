import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart'; // ADD: image picker
import 'dart:io'; // ADD: for File
import '../health_record_service.dart';
import '../providers/demographics_provider.dart';
import '../widgets/base_screen.dart';

class DemographicsScreen extends StatefulWidget {
  final String username; // ADD: username parameter

  // CHANGE: Constructor to require username
  const DemographicsScreen({super.key, required this.username});

  @override
  _DemographicsScreenState createState() => _DemographicsScreenState();
}

class _DemographicsScreenState extends State<DemographicsScreen> {
  final ImagePicker _picker = ImagePicker(); // ADD: image picker instance

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ADD: Set username before fetching data
      Provider.of<DemographicsProvider>(context, listen: false).setUsername(widget.username);
      Provider.of<DemographicsProvider>(context, listen: false).fetchDemographics();
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
          'Demographics',
          widget.username,
        );

        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Photo saved to Demographics'),
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

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value.isNotEmpty ? value : 'Not Specified',
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Demographics',
      username: widget.username, // ADD: pass username to BaseScreen

      // ADD: Floating action button for camera
      floatingActionButton: FloatingActionButton(
        onPressed: _addPhotoRecord,
        child: const Icon(Icons.camera_alt),
        tooltip: 'Add Photo',
      ),

      body: Consumer<DemographicsProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(
              child: Text('Error: ${provider.error}'),
            );
          }

          final demographics = provider.demographics;
          if (demographics == null) {
            return const Center(
              child: Text('No demographics information available'),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow('First Name', demographics.firstName),
                _buildInfoRow('Last Name', demographics.lastName),
                _buildInfoRow('Gender', demographics.gender),
                _buildInfoRow('Marital Status', demographics.maritalStatus),
                _buildInfoRow('Religious Affiliation', demographics.religiousAffiliation),
                _buildInfoRow('Ethnicity', demographics.ethnicity),
                _buildInfoRow('Language Spoken', demographics.languageSpoken),
                _buildInfoRow('Address', demographics.address),
                _buildInfoRow('Telephone', demographics.telephone),
                _buildInfoRow('Birthday', demographics.birthday),
              ],
            ),
          );
        },
      ),
    );
  }
}