import 'package:flutter/material.dart';

class VaccineCard extends StatefulWidget {
  final String name, type, administered, expires, vetName, vetPhone;
  final double weight;
  final Color statusColor;

  const VaccineCard({
    super.key,
    required this.name,
    required this.type,
    required this.administered,
    required this.expires,
    required this.weight,
    required this.vetName,
    required this.vetPhone,
    required this.statusColor,
  });

  @override
  State<VaccineCard> createState() => _VaccineCardState();
}

class _VaccineCardState extends State<VaccineCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      shadowColor: Colors.black26,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundColor: widget.statusColor.withOpacity(0.2),
                child: Icon(Icons.vaccines, color: widget.statusColor),
              ),
              title: Text(
                widget.name,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal.shade900,
                ),
              ),
              subtitle: Text(
                "Administered: ${widget.administered}\nExpires: ${widget.expires}",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
              trailing: IconButton(
                icon: Icon(
                  _expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: Colors.teal.shade700,
                ),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
            
            AnimatedCrossFade(
              firstChild: SizedBox.shrink(),
              secondChild: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(color: Colors.teal.shade300, thickness: 0.8),
                    _buildDetailRow(Icons.category, "Type:", widget.type),
                    _buildDetailRow(Icons.scale, "Weight:", "${widget.weight} kg"),
                    _buildDetailRow(Icons.person, "Veterinarian:", widget.vetName),
                    _buildDetailRow(Icons.phone, "Phone:", widget.vetPhone),
                    SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.check_circle,
                        color: widget.statusColor,
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),
              crossFadeState:
                  _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
              duration: Duration(milliseconds: 300),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: Colors.teal.shade700, size: 20),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              "$label $value",
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }
}