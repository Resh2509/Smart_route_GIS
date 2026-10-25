import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
      }
    } catch (e) {
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

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          backgroundColor: const Color(0xFF1E293B),
          title: const Text("Alert Dispatched Successfully", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          content: Text(
            "Ticket #${data['ticket_id'] ?? 'AF-9102'} generated.\n\nAssigned Officer: ${assignedOfficer?['name']}\nPhone: ${assignedOfficer?['phone']}\n\nCrew dispatched with safe corridor navigation avoiding flooded junctions.",
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
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error submitting alert. Check backend connection.")),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
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