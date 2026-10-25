// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:convert';
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AegisFlowApp());
}

class AegisFlowApp extends StatelessWidget {
  const AegisFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AegisFlow — Topological Digital Twin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Segoe UI',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0F172A),
          primary: const Color(0xFF1E293B),
          secondary: Colors.blueAccent,
        ),
        useMaterial3: true,
      ),
      home: const WelcomeScreen(),
    );
  }
}

/* ==========================================================================
   1. WELCOME SCREEN
   ========================================================================== */
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B132B),
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 480),
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.withOpacity(0.12),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.blueAccent.withOpacity(0.3), width: 2),
                  ),
                  child: const Icon(Icons.waves, size: 76, color: Colors.blueAccent),
                ),
                const SizedBox(height: 28),
                const Text(
                  "AEGISFLOW",
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 3.0,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "AI-Powered Urban Flood Digital Twin & Emergency Dispatch",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                    letterSpacing: 0.5,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 48),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RoleSelectionScreen()),
                      );
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Get Started", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward, size: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/* ==========================================================================
   2. ROLE SELECTION SCREEN
   ========================================================================== */
class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, foregroundColor: Colors.white),
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 480),
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Select Portal",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 6),
                const Text("Choose your domain access to authenticate.", style: TextStyle(color: Colors.white70, fontSize: 14)),
                const SizedBox(height: 32),
                _buildRoleCard(
                  context,
                  title: "Citizen Emergency Portal",
                  subtitle: "Log in with personal email to report localized drainage issues and track assigned engineers.",
                  icon: Icons.person_pin_circle_outlined,
                  color: Colors.cyanAccent,
                  targetScreen: const LoginScreen(role: 'citizen'),
                ),
                const SizedBox(height: 18),
                _buildRoleCard(
                  context,
                  title: "Municipal Operations Command",
                  subtitle: "Log in with @gcc.gov.in credentials to monitor live surcharge telemetry and field teams.",
                  icon: Icons.shield_outlined,
                  color: Colors.amberAccent,
                  targetScreen: const LoginScreen(role: 'municipal'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard(
      BuildContext context, {
        required String title,
        required String subtitle,
        required IconData icon,
        required Color color,
        required Widget targetScreen,
      }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => targetScreen));
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: color.withOpacity(0.12), shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 6),
                  Text(subtitle, style: const TextStyle(fontSize: 13, color: Colors.white60, height: 1.4)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.white38),
          ],
        ),
      ),
    );
  }
}

/* ==========================================================================
   3. LOGIN & SIGN-UP SCREEN
   ========================================================================== */
class LoginScreen extends StatefulWidget {
  final String role;

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
            _successMessage = "Account registered! Please log in.";
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
      // Offline fallback: allow local entry for frontend demonstration if server is not yet running
      if (mounted) {
        if (isMunicipal) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MunicipalOperationsScreen()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => CitizenHazardSelectionScreen(citizenName: _nameController.text.isEmpty ? "Citizen" : _nameController.text),
            ),
          );
        }
      }
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
                      ? "Restricted to official @gcc.gov.in government credentials."
                      : "Use personal email to report localized drainage issues.",
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
                  TextField(controller: _nameController, style: const TextStyle(color: Colors.white), decoration: _inputDeco(Icons.person_outline)),
                  const SizedBox(height: 14),
                  const Text("Mobile Number", style: TextStyle(color: Colors.white70, fontSize: 12)),
                  const SizedBox(height: 6),
                  TextField(controller: _phoneController, style: const TextStyle(color: Colors.white), decoration: _inputDeco(Icons.phone_outlined)),
                  const SizedBox(height: 14),
                ],

                Text(isMunicipal ? "Official Government Email" : "Personal Email", style: const TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 6),
                TextField(controller: _emailController, style: const TextStyle(color: Colors.white), decoration: _inputDeco(Icons.email_outlined)),
                const SizedBox(height: 14),

                const Text("Password", style: TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 6),
                TextField(controller: _passwordController, obscureText: true, style: const TextStyle(color: Colors.white), decoration: _inputDeco(Icons.lock_outline)),
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

/* ==========================================================================
   4. STEP 1: HAZARD & LOCALITY SELECTION SCREEN (WITH "OTHERS" FIELD)
   ========================================================================== */
class CitizenHazardSelectionScreen extends StatefulWidget {
  final String citizenName;

  const CitizenHazardSelectionScreen({super.key, required this.citizenName});

  @override
  State<CitizenHazardSelectionScreen> createState() => _CitizenHazardSelectionScreenState();
}

class _CitizenHazardSelectionScreenState extends State<CitizenHazardSelectionScreen> {
  final List<String> localities = [
    "Velachery South (Ward 178)",
    "Velachery North (Ward 177)",
    "Madipakkam Lake Basin (Ward 188)",
    "Taramani IT Corridor (Ward 179)",
    "Adyar River Canal Bank (Ward 173)",
    "Pallikaranai Marshland Fringe (Ward 190)",
  ];

  final List<Map<String, dynamic>> hazardTypes = [
    {
      "id": "culvert_blockage",
      "title": "Subterranean Culvert Blockage / Heavy Silt",
      "desc": "Garbage, plastics, or construction debris choking inlet.",
      "icon": Icons.block,
      "color": Colors.orangeAccent,
    },
    {
      "id": "surface_inundation",
      "title": "Severe Street Inundation (>0.3m Depth)",
      "desc": "Water stagnation blocking vehicles & emergency access.",
      "icon": Icons.flood,
      "color": Colors.redAccent,
    },
    {
      "id": "manhole_surcharge",
      "title": "Manhole Surcharge / Gushing Backflow",
      "desc": "Backpressure inside pipes ejecting foul water upwards.",
      "icon": Icons.warning_amber_rounded,
      "color": Colors.purpleAccent,
    },
    {
      "id": "drain_collapse",
      "title": "Broken Drain Slab / Retaining Wall Collapse",
      "desc": "Open caved-in culvert posing fatal pedestrian risk.",
      "icon": Icons.dangerous,
      "color": Colors.deepOrangeAccent,
    },
    {
      "id": "others",
      "title": "Others (Specify Custom Issue)",
      "desc": "Any unique localized hazard not listed above.",
      "icon": Icons.edit_note,
      "color": Colors.cyanAccent,
    },
  ];

  String? selectedLocality;
  String? selectedHazardId;
  final TextEditingController _customIssueController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedLocality = localities.first;
    selectedHazardId = hazardTypes.first['id'] as String;
  }

  @override
  void dispose() {
    _customIssueController.dispose();
    super.dispose();
  }

  void _proceedToDetails() {
    if (selectedHazardId == "others" && _customIssueController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please describe your custom problem before proceeding."),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final selectedObj = hazardTypes.firstWhere((h) => h['id'] == selectedHazardId);
    final String resolvedTitle = selectedHazardId == "others"
        ? "Other: ${_customIssueController.text.trim()}"
        : selectedObj['title'] as String;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CitizenHazardDetailScreen(
          citizenName: widget.citizenName,
          locality: selectedLocality!,
          hazardId: selectedHazardId!,
          hazardTitle: resolvedTitle,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text("Step 1: Incident Classification", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          child: ListView(
            padding: const EdgeInsets.all(22.0),
            children: [
              Text(
                "Welcome, ${widget.citizenName}",
                style: const TextStyle(fontSize: 18, color: Colors.cyanAccent, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text("Select your zone and identify the primary drainage hazard.", style: TextStyle(color: Colors.white70, fontSize: 13)),
              const SizedBox(height: 22),

              const Text("Select Ward / Municipal Locality", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.08)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    dropdownColor: const Color(0xFF1E293B),
                    value: selectedLocality,
                    isExpanded: true,
                    icon: const Icon(Icons.arrow_drop_down, color: Colors.blueAccent),
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    items: localities.map((loc) => DropdownMenuItem(value: loc, child: Text(loc))).toList(),
                    onChanged: (val) => setState(() => selectedLocality = val),
                  ),
                ),
              ),

              const SizedBox(height: 24),
              const Text("Observed Drainage Hazard", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),

              ...hazardTypes.map((hazard) {
                final isSelected = selectedHazardId == hazard['id'];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => setState(() => selectedHazardId = hazard['id']),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF1E293B) : const Color(0xFF161F30),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? (hazard['color'] as Color) : Colors.white.withOpacity(0.06),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(hazard['icon'] as IconData, color: hazard['color'] as Color, size: 28),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  hazard['title'] as String,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(hazard['desc'] as String, style: const TextStyle(color: Colors.white54, fontSize: 12)),
                              ],
                            ),
                          ),
                          Radio<String>(
                            value: hazard['id'] as String,
                            groupValue: selectedHazardId,
                            activeColor: hazard['color'] as Color,
                            onChanged: (val) => setState(() => selectedHazardId = val),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),

              if (selectedHazardId == "others") ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.cyanAccent.withOpacity(0.5)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.edit, color: Colors.cyanAccent, size: 18),
                          SizedBox(width: 8),
                          Text("Describe Specific Problem", style: TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold, fontSize: 13)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _customIssueController,
                        maxLines: 3,
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                        decoration: InputDecoration(
                          hintText: "E.g., Water reverse flowing from domestic pipe into house compound wall.",
                          hintStyle: const TextStyle(color: Colors.white38, fontSize: 13),
                          filled: true,
                          fillColor: const Color(0xFF0F172A),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 24),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _proceedToDetails,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Proceed to Specific Details", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, size: 18),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* ==========================================================================
   5. STEP 2: HAZARD DETAIL & WARD OFFICER ROUTING SCREEN
   ========================================================================== */
class CitizenHazardDetailScreen extends StatefulWidget {
  final String citizenName;
  final String locality;
  final String hazardId;
  final String hazardTitle;

  const CitizenHazardDetailScreen({
    super.key,
    required this.citizenName,
    required this.locality,
    required this.hazardId,
    required this.hazardTitle,
  });

  @override
  State<CitizenHazardDetailScreen> createState() => _CitizenHazardDetailScreenState();
}

class _CitizenHazardDetailScreenState extends State<CitizenHazardDetailScreen> {
  final _streetController = TextEditingController();
  final _landmarkController = TextEditingController();
  final _dynamicNoteController = TextEditingController();

  bool _isSubmitting = false;
  bool _isLoadingOfficer = true;
  Map<String, dynamic>? assignedOfficer;

  @override
  void initState() {
    super.initState();
    _fetchAssignedOfficer();
  }

  @override
  void dispose() {
    _streetController.dispose();
    _landmarkController.dispose();
    _dynamicNoteController.dispose();
    super.dispose();
  }

  Future<void> _fetchAssignedOfficer() async {
    try {
      final url = Uri.parse("http://127.0.0.1:8000/api/officers/by-ward?ward=${Uri.encodeComponent(widget.locality)}");
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          assignedOfficer = json.decode(response.body);
          _isLoadingOfficer = false;
        });
        return;
      }
    } catch (_) {}

    // Fallback officer profile if offline
    if (mounted) {
      setState(() {
        assignedOfficer = {
          "name": "K. Rajesh, AE",
          "role": "Zonal Hydraulic Engineer",
          "ward": widget.locality,
          "phone": "+91 94440 12345",
          "status": "Available (On Field Patrol)",
        };
        _isLoadingOfficer = false;
      });
    }
  }

  Widget _buildDynamicQuestions() {
    switch (widget.hazardId) {
      case "culvert_blockage":
        return _questionField("What material is clogging the drain?", "E.g., Plastic bags, construction debris, solid silt.");
      case "surface_inundation":
        return _questionField("Water Stagnation Height:", "E.g., Ankle-deep (~15cm) or Knee-deep (~45cm).");
      case "manhole_surcharge":
        return _questionField("Gushing Pressure & Odor:", "E.g., High upward fountain pressure with septic smell.");
      case "drain_collapse":
        return _questionField("Slab Damage Details:", "E.g., Approx 2-meter retaining wall collapsed.");
      default:
        return _questionField("Specific Notes for Municipal Crew:", "E.g., Power junction box near waterlogged area.");
    }
  }

  Widget _questionField(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 13)),
        const SizedBox(height: 6),
        TextField(
          controller: _dynamicNoteController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white38, fontSize: 13),
            filled: true,
            fillColor: const Color(0xFF1E293B),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }

  Future<void> _submitReport() async {
    if (_streetController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter street address / door number.")),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    final url = Uri.parse("http://127.0.0.1:8000/api/incidents");

    try {
      final res = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "citizen_name": widget.citizenName,
          "locality": widget.locality,
          "hazard_type": widget.hazardTitle,
          "street_address": _streetController.text.trim(),
          "landmark": _landmarkController.text.trim(),
          "specific_details": _dynamicNoteController.text.trim(),
          "assigned_officer_id": assignedOfficer?['id'] ?? 1,
        }),
      );

      final data = json.decode(res.body);
      if (!mounted) return;

      _showSuccessDialog(data['ticket_id'] ?? 'AF-9102');
    } catch (_) {
      // Local fallback dialog if backend server is offline
      if (mounted) _showSuccessDialog('AF-9102');
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _showSuccessDialog(String ticketId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text("Alert Dispatched Successfully", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: Text(
          "Ticket #$ticketId generated.\n\nAssigned Officer: ${assignedOfficer?['name']}\nPhone: ${assignedOfficer?['phone']}\n\nCrew dispatched with safe corridor navigation avoiding flooded junctions.",
          style: const TextStyle(color: Colors.white70, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text("OK", style: TextStyle(color: Colors.cyanAccent)),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text("Step 2: Emergency Dispatch Details", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          child: ListView(
            padding: const EdgeInsets.all(22.0),
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.blueGrey.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Zone: ${widget.locality}", style: const TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text("Issue: ${widget.hazardTitle}", style: const TextStyle(color: Colors.white, fontSize: 13)),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              const Text("Exact Street / Door No. *", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              TextField(
                controller: _streetController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "E.g., Door 14, 2nd Main Road, AGS Colony",
                  hintStyle: const TextStyle(color: Colors.white38, fontSize: 13),
                  filled: true,
                  fillColor: const Color(0xFF1E293B),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                ),
              ),

              const SizedBox(height: 16),
              const Text("Prominent Landmark", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              TextField(
                controller: _landmarkController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "E.g., Near Velachery MRTS / Opposite Indian Oil Bunk",
                  hintStyle: const TextStyle(color: Colors.white38, fontSize: 13),
                  filled: true,
                  fillColor: const Color(0xFF1E293B),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                ),
              ),

              const SizedBox(height: 16),
              _buildDynamicQuestions(),

              const SizedBox(height: 24),
              const Text("Assigned Ward Drainage Official", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),

              _isLoadingOfficer
                  ? const Center(child: CircularProgressIndicator())
                  : Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.greenAccent.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.blueGrey,
                      child: Icon(Icons.engineering, color: Colors.white),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(assignedOfficer?['name'] ?? "Assigned Engineer", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          Text(assignedOfficer?['role'] ?? "Hydraulic Field Officer", style: const TextStyle(color: Colors.white70, fontSize: 12)),
                          const SizedBox(height: 4),
                          Text("• ${assignedOfficer?['status'] ?? 'Available'}", style: const TextStyle(color: Colors.greenAccent, fontSize: 12)),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.phone, color: Colors.greenAccent),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Calling ${assignedOfficer?['name']} at ${assignedOfficer?['phone']}...")),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),
              SizedBox(
                height: 50,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.broadcast_on_personal),
                  label: _isSubmitting
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text("Broadcast Alert to Municipal Operations", style: TextStyle(fontWeight: FontWeight.bold)),
                  onPressed: _isSubmitting ? null : _submitReport,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* ==========================================================================
   6. MUNICIPAL OPERATIONS SCREEN
   ========================================================================== */
class MunicipalOperationsScreen extends StatelessWidget {
  const MunicipalOperationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text("Municipal Command & Field Dispatch", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.map, color: Colors.cyanAccent),
            tooltip: "Open Digital Twin Map",
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const DigitalTwinMapScreen()));
            },
          ),
        ],
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 700),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Row(
                children: [
                  _metricTile("Active Surcharges", "3 Nodes", Colors.redAccent),
                  const SizedBox(width: 12),
                  _metricTile("Crews Deployed", "5 Units", Colors.amberAccent),
                  const SizedBox(width: 12),
                  _metricTile("Safe Corridors", "Optimal", Colors.greenAccent),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Incoming Civic Alerts Queue", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  TextButton.icon(
                    icon: const Icon(Icons.open_in_new, size: 16, color: Colors.blueAccent),
                    label: const Text("Launch Map View", style: TextStyle(color: Colors.blueAccent)),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const DigitalTwinMapScreen()));
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _incidentCard("AF-4091", "100 Feet Road, Velachery (Near MRTS)", "0.45m", "Pending Deployment", "K. Rajesh, AE", Colors.redAccent),
              const SizedBox(height: 12),
              _incidentCard("AF-4088", "Taramani Link Road Junction", "0.28m", "Pumping In Progress", "S. Murugan (Unit 4)", Colors.amberAccent),
              const SizedBox(height: 12),
              _incidentCard("AF-4085", "Vijaya Nagar Bus Terminus", "0.12m", "Drain Cleared", "M. Kumar (Unit 2)", Colors.greenAccent),
            ],
          ),
        ),
      ),
    );
  }

  Widget _metricTile(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            Text(value, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(color: Colors.white60, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _incidentCard(String ticket, String location, String depth, String status, String assignedTo, Color urgency) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(ticket, style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: urgency.withOpacity(0.15), borderRadius: BorderRadius.circular(6)),
                child: Text(status, style: TextStyle(color: urgency, fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(location, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 4),
          Text("Predicted Inundation: $depth • Assigned: $assignedTo", style: const TextStyle(color: Colors.white60, fontSize: 12)),
        ],
      ),
    );
  }
}

/* ==========================================================================
   7. DIGITAL TWIN MAP SCREEN (Chrome Web Iframe)
   ========================================================================== */
class DigitalTwinMapScreen extends StatefulWidget {
  const DigitalTwinMapScreen({super.key});

  @override
  State<DigitalTwinMapScreen> createState() => _DigitalTwinMapScreenState();
}

class _DigitalTwinMapScreenState extends State<DigitalTwinMapScreen> {
  final String mapUrl = "https://hedgier-depressingly-manual.ngrok-free.dev/";
  final String _viewTypeId = 'ngrok-digital-twin-map-frame';

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      ui_web.platformViewRegistry.registerViewFactory(
        _viewTypeId,
            (int viewId) {
          final iframe = html.IFrameElement()
            ..src = mapUrl
            ..style.border = 'none'
            ..style.width = '100%'
            ..style.height = '100%';
          return iframe;
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AegisFlow — Topological Digital Twin", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        foregroundColor: Colors.white,
      ),
      body: SizedBox.expand(
        child: HtmlElementView(viewType: _viewTypeId),
      ),
    );
  }
}