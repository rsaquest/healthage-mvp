import 'package:flutter/material.dart';
import '../app_state.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  String _role = 'Patient';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const Text('Create your HealthAge account', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Join as a patient, caregiver, or practitioner and start accessing care services.', style: TextStyle(color: Colors.black54)),
            const SizedBox(height: 20),
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Full name', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: _emailController, decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: _phoneController, decoration: const InputDecoration(labelText: 'Phone number', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: _passwordController, obscureText: true, decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _role,
              decoration: const InputDecoration(labelText: 'Account role', border: OutlineInputBorder()),
              items: const [
                DropdownMenuItem(value: 'Patient', child: Text('Patient')),
                DropdownMenuItem(value: 'Family', child: Text('Family')),
                DropdownMenuItem(value: 'Practitioner', child: Text('Practitioner')),
              ],
              onChanged: (value) => setState(() => _role = value ?? 'Patient'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F766E), padding: const EdgeInsets.symmetric(vertical: 14)),
              onPressed: () {
                final success = AppState.instance.registerUser(
                  name: _nameController.text.trim(),
                  email: _emailController.text.trim(),
                  password: _passwordController.text.trim(),
                  role: _role,
                );

                if (!success) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppState.instance.lastError ?? 'Unable to create account.')));
                  return;
                }

                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Account created for $_role')));
                Navigator.of(context).pushReplacementNamed('/main');
              },
              child: const Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
