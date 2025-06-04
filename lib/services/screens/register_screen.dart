// screens/register_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../auth_service.dart'; // Updated: multi-user AuthService

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  String name = '';
  String surname = '';
  DateTime? birthdate;
  String gender = 'Male';
  double? weight;
  String username = '';
  String password = '';
  String email = '';

  final List<String> genderOptions = ['Male', 'Female', 'Do not want to declare'];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        birthdate = picked;
      });
    }
  }

  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate() && birthdate != null) {
      try {
        // New multi-user registration
        await AuthService.registerUser(username, password);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration successful! You can now login.'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context);
      } catch (e) {
        print('Error during registration: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration failed. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Name'),
                        validator: (value) => value!.isEmpty ? 'Please enter name' : null,
                        onChanged: (value) => name = value,
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Surname'),
                        validator: (value) => value!.isEmpty ? 'Please enter surname' : null,
                        onChanged: (value) => surname = value,
                      ),
                      const SizedBox(height: 16),

                      ListTile(
                        title: Text('Birthdate: ${birthdate != null ? DateFormat('yyyy-MM-dd').format(birthdate!) : 'Not selected'}'),
                        trailing: const Icon(Icons.calendar_today),
                        onTap: () => _selectDate(context),
                      ),
                      const SizedBox(height: 16),

                      DropdownButtonFormField<String>(
                        value: gender,
                        decoration: const InputDecoration(labelText: 'Gender'),
                        items: genderOptions.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            gender = newValue!;
                          });
                        },
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Weight (kg)'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) return 'Please enter weight';
                          if (double.tryParse(value) == null) return 'Please enter a valid number';
                          return null;
                        },
                        onChanged: (value) => weight = double.tryParse(value),
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Username'),
                        validator: (value) => value!.isEmpty ? 'Please enter username' : null,
                        onChanged: (value) => username = value,
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Password'),
                        obscureText: true,
                        validator: (value) {
                          if (value!.isEmpty) return 'Please enter password';
                          if (value.length < 8) return 'Password must be at least 8 characters';
                          return null;
                        },
                        onChanged: (value) => password = value,
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Email'),
                        validator: (value) {
                          if (value!.isEmpty) return 'Please enter email';
                          if (!isValidEmail(value)) return 'Please enter a valid email';
                          return null;
                        },
                        onChanged: (value) => email = value,
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                // (Only the relevant button logic shown here)
                onPressed: () async {
                  if (_formKey.currentState!.validate() && birthdate != null) {
                    try {
                      await AuthService.registerUser(username, password);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Registration successful! You can now login.'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      Navigator.pop(context);
                    } catch (e) {
                      print('Error during registration: $e');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Registration failed. Please try again.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: const Text('Register'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}