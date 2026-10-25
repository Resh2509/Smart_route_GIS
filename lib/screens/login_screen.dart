import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'citizen_hazard_selection_screen.dart';
import 'municipal_operations_screen.dart';

class LoginScreen extends StatefulWidget {
  final String role; // 'citizen' or 'municipal'

  const LoginScreen({super.key, required this.role});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isSignUp = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  @override
  void initState() {
    super.initState();
    if (widget.role == 'municipal') {
      _emailController.text = "rajesh.officer@gcc.gov.in";
      _passwordController.text = "admin123";
    } else {
      _emailController.text = "arun.citizen@gmail.com";
      _passwordController.text = "user123";
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleAuth() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    final isMunicipal = widget.role == 'municipal';

    try {
      if (_isSignUp) {
        final res = await http.post(
          Uri.parse("http://127.0.0.1:8000/api/auth/register-citizen"),
          headers: {"Content-Type": "application/json"},
          body: json.encode({
            "name": _nameController.text.trim(),
            "email": _emailController.text.trim(),
            "password": _passwordController.text.trim(),
            "phone": _phoneController.text.trim(),
            "ward": "Ward 178 - Velachery South",
          }),
        );
        final data = json.decode(res.body);
        if (res.statusCode == 200) {
          setState(() {
            _isSignUp = false;
            _successMessage = "Account created successfully! Please log in.";
          });
        } else {
          setState(() => _errorMessage = data['detail'] ?? "Registration failed.");
        }
      } else {
        final res = await http.post(
          Uri.parse("http://127.0.0.1:8000/api/auth/login"),
          headers: {"Content-Type": "application/json"},
          body: json.encode({
            "email": _emailController.text.trim(),
            "password": _passwordController.text.trim(),
            "portal_type": widget.role,
          }),
        );
        final data = json.decode(res.body);

        if (res.statusCode == 200 && data['status'] == 'success') {
          final user = data['user'];
          if (!mounted) return;

          if (isMunicipal) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MunicipalOperationsScreen()),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => CitizenHazardSelectionScreen(citizenName: user['name']),
              ),
            );
          }
        } else {
          setState(() => _errorMessage = data['detail'] ?? "Authentication failed.");
        }
      }
    } catch (e) {
      setState(() => _errorMessage = "Cannot connect to server (http://127.0.0.1:8000). Python server start pannirukkangala nu paarunga.");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMunicipal = widget.role == 'municipal';

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, foregroundColor: Colors.white),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 440),
            padding: const EdgeInsets.all(28.0),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.08)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isMunicipal ? Icons.shield_outlined : Icons.person_pin_circle_outlined,
                  color: isMunicipal ? Colors.amberAccent : Colors.cyanAccent,
                  size: 40,
                ),
                const SizedBox(height: 14),
                Text(
                  isMunicipal ? "Municipal Command Login" : (_isSignUp ? "Citizen Sign Up" : "Citizen Emergency Login"),
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 6),
                Text(
                  isMunicipal
                      ? "Restricted to @gcc.gov.in or @tn.gov.in official government credentials."
                      : "Use personal email to log in and report drainage waterlogging.",
                  style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 13),
                ),
                const SizedBox(height: 20),

                if (_errorMessage != null)
                  Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(bottom: 14),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.redAccent.withOpacity(0.4)),
                    ),
                    child: Text(_errorMessage!, style: const TextStyle(color: Colors.redAccent, fontSize: 12)),
                  ),

                if (_successMessage != null)
                  Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(bottom: 14),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.greenAccent.withOpacity(0.4)),
                    ),
                    child: Text(_successMessage!, style: const TextStyle(color: Colors.greenAccent, fontSize: 12)),
                  ),

                if (_isSignUp) ...[
                  const Text("Full Name", style: TextStyle(color: Colors.white70, fontSize: 12)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _nameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputDeco(Icons.person_outline),
                  ),
                  const SizedBox(height: 14),
                  const Text("Mobile Number", style: TextStyle(color: Colors.white70, fontSize: 12)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _phoneController,
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputDeco(Icons.phone_outlined),
                  ),
                  const SizedBox(height: 14),
                ],

                Text(
                  isMunicipal ? "Official Government Email" : "Personal Email",
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: _emailController,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDeco(Icons.email_outlined),
                ),
                const SizedBox(height: 14),

                const Text("Password", style: TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 6),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDeco(Icons.lock_outline),
                ),
                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isMunicipal ? Colors.amber[700] : Colors.blueAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: _isLoading ? null : _handleAuth,
                    child: _isLoading
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : Text(_isSignUp ? "Register Account" : "Authenticate & Enter", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  ),
                ),

                if (!isMunicipal) ...[
                  const SizedBox(height: 16),
                  Center(
                    child: TextButton(
                      onPressed: () => setState(() => _isSignUp = !_isSignUp),
                      child: Text(
                        _isSignUp ? "Already registered? Log In" : "Don't have an account? Sign Up with Email",
                        style: const TextStyle(color: Colors.cyanAccent, fontSize: 13),
                      ),
                    ),
                  )
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDeco(IconData icon) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: Colors.white38, size: 20),
      filled: true,
      fillColor: const Color(0xFF0F172A),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
    );
  }
}