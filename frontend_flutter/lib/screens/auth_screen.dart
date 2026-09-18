import 'package:flutter/material.dart';
import '../app_state.dart';
import 'signup_screen.dart';

class AuthScreen extends StatefulWidget {
  final String requiredRole;

  const AuthScreen({super.key, this.requiredRole = ''});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isCreateAccount = false;
  late String _currentRole;

  @override
  void initState() {
    super.initState();
    _currentRole = widget.requiredRole.isNotEmpty ? widget.requiredRole : 'Patient';
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    final state = AppState.instance;
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter your email and password.')));
      return;
    }

    final roleToUse = _currentRole;

    if (_isCreateAccount) {
      final created = state.registerUser(
        name: _emailController.text.split('@').first,
        email: email,
        password: password,
        role: roleToUse,
      );
      if (!created) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.lastError ?? 'Unable to create account.')));
        return;
      }
    } else {
      final loggedIn = state.loginUser(email: email, password: password);
      if (!loggedIn) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.lastError ?? 'Login failed.')));
        return;
      }
      if (state.currentUser?.role != roleToUse) {
        state.logout();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please sign in with $roleToUse credentials.')),
        );
        return;
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_isCreateAccount ? 'Created your account' : 'Signed in successfully')),
    );

    final destination = state.currentUser?.role == 'Admin' ? '/admin' : '/main';
    Navigator.of(context).pushReplacementNamed(destination);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 520,
                    minHeight: constraints.maxHeight - 48,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
              const SizedBox(height: 40),
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE9F7F2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.health_and_safety, color: Color(0xFF0F766E), size: 48),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'HealthAge MVP',
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Secure home care and emergency response',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black54, fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              const Text('Select Role', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ['Patient', 'Practitioner', 'Caregiver', 'Admin'].map((role) {
                    final isSelected = _currentRole == role;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(role),
                        selected: isSelected,
                        onSelected: (val) {
                          if (val) setState(() => _currentRole = role);
                        },
                        selectedColor: const Color(0xFF0F766E),
                        labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.info_outline, color: Color(0xFF475569), size: 20),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Demo Credentials',
                            style: TextStyle(color: Color(0xFF475569), fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _currentRole == 'Admin'
                          ? 'Admin: maya@healthage.com / demo123'
                          : _currentRole == 'Practitioner'
                              ? 'Practitioner: ada@healthage.com / demo123'
                              : _currentRole == 'Caregiver'
                                  ? 'Caregiver: tolu@healthage.com / demo123'
                                  : 'Patient: daniel@healthage.com / demo123',
                      style: const TextStyle(color: Color(0xFF0F766E), fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text('Email Address', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'name@example.com',
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 20),
              const Text('Password', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: '••••••••',
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F766E),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: _submit,
                  child: Text(
                    _isCreateAccount ? 'Create Account' : 'Sign In',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(_isCreateAccount ? 'Already have an account?' : 'Don\'t have an account?'),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isCreateAccount = !_isCreateAccount;
                      });
                    },
                    child: Text(_isCreateAccount ? 'Sign In' : 'Sign Up'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
                    Center(
                      child: TextButton(
                        onPressed: () => Navigator.pushNamed(context, '/invites'),
                        child: const Text('Check for invites'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            );
          },
        ),
      ),
    );
  }
}
