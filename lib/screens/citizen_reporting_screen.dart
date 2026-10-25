import 'package:flutter/material.dart';

class CitizenReportingScreen extends StatefulWidget {
  const CitizenReportingScreen({super.key});

  @override
  State<CitizenReportingScreen> createState() => _CitizenReportingScreenState();
}

class _CitizenReportingScreenState extends State<CitizenReportingScreen> {
  final _addressController = TextEditingController(text: "100 Feet Road, Velachery (Near MRTS Station)");
  final _descController = TextEditingController();
  bool _isLocating = false;
  String _detectedCoords = "12.9815° N, 80.2180° E (Ward 178)";
  String _selectedSeverity = "Severe (>0.4m, Road Inaccessible)";

  final Map<String, String> assignedOfficer = {
    "name": "K. Rajesh, AE",
    "role": "Zonal Hydraulic Engineer",
    "ward": "Ward 178 - Velachery South",
    "phone": "+91 94440 XXXXX",
    "status": "Available (On Field Patrol)",
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text("Citizen Emergency Assistance", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blueAccent.withOpacity(0.3)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blueAccent),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Reports directly link to GCC Zone 13 command center. On-duty crews are auto-routed using safe emergency corridors.",
                        style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.3),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text("Incident Location / Landmark", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: _addressController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF1E293B),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                  prefixIcon: const Icon(Icons.location_on, color: Colors.redAccent),
                  suffixIcon: IconButton(
                    icon: _isLocating
                        ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.my_location, color: Colors.blueAccent),
                    onPressed: () {
                      setState(() => _isLocating = true);
                      Future.delayed(const Duration(seconds: 1), () {
                        setState(() {
                          _isLocating = false;
                          _detectedCoords = "12.9782° N, 80.2215° E (Accurate to 3m)";
                        });
                      });
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 6.0, left: 4.0),
                child: Text("Detected Coordinates: $_detectedCoords", style: const TextStyle(color: Colors.white38, fontSize: 12)),
              ),
              const SizedBox(height: 20),
              const Text("Observed Inundation Level", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(10)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    dropdownColor: const Color(0xFF1E293B),
                    value: _selectedSeverity,
                    isExpanded: true,
                    style: const TextStyle(color: Colors.white),
                    items: [
                      "Minor (<0.15m, Passable)",
                      "Moderate (0.15m - 0.3m, Slow Traffic)",
                      "Severe (>0.4m, Road Inaccessible)",
                      "Drain Surcharge / Manhole Gushing",
                    ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                    onChanged: (val) => setState(() => _selectedSeverity = val!),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text("Description / Specific Issues", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: _descController,
                maxLines: 3,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "E.g., Stromwater drain inlet clogged with trash; water entering apartment basements.",
                  hintStyle: const TextStyle(color: Colors.white38, fontSize: 13),
                  filled: true,
                  fillColor: const Color(0xFF1E293B),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 28),
              const Text("Assigned Ward Official", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Container(
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
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(assignedOfficer['name']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          Text(assignedOfficer['role']!, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                          const SizedBox(height: 4),
                          Text("• ${assignedOfficer['status']!}", style: const TextStyle(color: Colors.greenAccent, fontSize: 12)),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.phone, color: Colors.greenAccent),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Calling ${assignedOfficer['name']} (${assignedOfficer['phone']})...")),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.message, color: Colors.blueAccent),
                      onPressed: () => _openIntercomChat(context),
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
                  icon: const Icon(Icons.send_sharp),
                  label: const Text("Broadcast Emergency Waterlogging Alert", style: TextStyle(fontWeight: FontWeight.bold)),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        backgroundColor: const Color(0xFF1E293B),
                        title: const Text("Alert Broadcasted", style: TextStyle(color: Colors.white)),
                        content: Text(
                          "Incident Ticket #AF-${DateTime.now().millisecondsSinceEpoch % 10000} registered. Field Engineer ${assignedOfficer['name']} has been dispatched with topological routing.",
                          style: const TextStyle(color: Colors.white70),
                        ),
                        actions: [
                          TextButton(
                            child: const Text("OK", style: TextStyle(color: Colors.blueAccent)),
                            onPressed: () => Navigator.pop(ctx),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openIntercomChat(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E293B),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            top: 20,
            left: 20,
            right: 20,
          ),
          child: SizedBox(
            height: 380,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Intercom: ${assignedOfficer['name']}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    const Icon(Icons.verified, color: Colors.blueAccent, size: 20),
                  ],
                ),
                const Divider(color: Colors.white12),
                Expanded(
                  child: ListView(
                    children: const [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Chip(
                          backgroundColor: Color(0xFF0F172A),
                          label: Text("Officer: Heavy inflow detected at culvert C-14. Crew en route.", style: TextStyle(color: Colors.white70, fontSize: 12)),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Type immediate landmark update...",
                          hintStyle: const TextStyle(color: Colors.white38, fontSize: 13),
                          filled: true,
                          fillColor: const Color(0xFF0F172A),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.send, color: Colors.blueAccent),
                      onPressed: () => Navigator.pop(ctx),
                    )
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }
}