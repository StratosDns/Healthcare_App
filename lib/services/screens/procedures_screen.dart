import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart'; // ADD: image picker
import 'dart:io'; // ADD: for File
import '../health_record_service.dart';
import '../providers/procedures_provider.dart';
import '../widgets/base_screen.dart';

class ProceduresScreen extends StatefulWidget {
  final String username; // ADD: username parameter

  // CHANGE: Constructor to require username
  const ProceduresScreen({super.key, required this.username});

  @override
  _ProceduresScreenState createState() => _ProceduresScreenState();
}

class _ProceduresScreenState extends State<ProceduresScreen> {
  final ImagePicker _picker = ImagePicker(); // ADD: image picker instance

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ADD: Set username before fetching data
      Provider.of<ProceduresProvider>(context, listen: false).setUsername(widget.username);
      Provider.of<ProceduresProvider>(context, listen: false).fetchProcedures();
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
          'Procedures',
          widget.username,
        );

        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Photo saved to Procedures'),
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
        title: 'Procedures',
        username: widget.username, // ADD: pass username to BaseScreen

        // ADD: Floating action button for camera
        floatingActionButton: FloatingActionButton(
          onPressed: _addPhotoRecord,
          child: const Icon(Icons.camera_alt),
          tooltip: 'Add Photo',
        ),

        body: Consumer<ProceduresProvider>(
        builder: (context, provider, child) {
      if (provider.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      if (provider.error != null) {
        return Center(
          child: Text('Error: ${provider.error}'),
        );
      }

      if (provider.procedures.isEmpty) {
        return Center(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Icon(Icons.medical_information, size: 64, color: Colors.grey),
    SizedBox(height: 16),
    Text(
    'No procedures found',
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
        itemCount: provider.procedures.length,
        itemBuilder: (context, index) {
          final procedure = provider.procedures[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.medical_services, color: Colors.blue),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Procedure: ${procedure.procedure}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                      SizedBox(width: 4),
                      Text('Date: ${procedure.date}'),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.person, size: 16, color: Colors.grey),
                      SizedBox(width: 4),
                      Text('Provider: ${procedure.provider}'),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16, color: Colors.grey),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text('Location: ${procedure.location}'),
                      ),
                    ],
                  ),
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