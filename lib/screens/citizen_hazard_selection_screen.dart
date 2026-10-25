import 'package:flutter/material.dart';
import 'citizen_hazard_detail_screen.dart';

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

              // Others select aana mattum display aagura dynamic box
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