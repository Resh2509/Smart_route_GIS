import 'package:flutter/material.dart';
import 'digital_twin_map_screen.dart';

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
              _incidentCard(
                context,
                ticket: "#AF-4091",
                location: "100 Feet Road, Velachery (Near MRTS)",
                depth: "0.45m",
                status: "Pending Deployment",
                assignedTo: "K. Rajesh, AE",
                urgency: Colors.redAccent,
              ),
              const SizedBox(height: 12),
              _incidentCard(
                context,
                ticket: "#AF-4088",
                location: "Taramani Link Road Junction",
                depth: "0.28m",
                status: "Pumping In Progress",
                assignedTo: "S. Murugan (Unit 4)",
                urgency: Colors.amberAccent,
              ),
              const SizedBox(height: 12),
              _incidentCard(
                context,
                ticket: "#AF-4085",
                location: "Vijaya Nagar Bus Terminus",
                depth: "0.12m",
                status: "Drain Cleared",
                assignedTo: "M. Kumar (Unit 2)",
                urgency: Colors.greenAccent,
              ),
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

  Widget _incidentCard(
      BuildContext context, {
        required String ticket,
        required String location,
        required String depth,
        required String status,
        required String assignedTo,
        required Color urgency,
      }) {
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