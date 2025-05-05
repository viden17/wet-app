import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/vaccine.dart';

class VaccinationsScreen extends StatefulWidget {
  const VaccinationsScreen({super.key});

  @override
  State<VaccinationsScreen> createState() => _VaccinationsScreenState();
}

class _VaccinationsScreenState extends State<VaccinationsScreen> {
  final VaccineControllers _vaccineControllers = VaccineControllers();
  final FirebaseAuth _auth = FirebaseAuth.instance;



  // Function to show the Add Vaccine Form Popup with enhanced UI
  void _showAddVaccineForm() {
    String name = "", type = "", vetName = "", vetPhone = "";
    DateTime? administeredDate, expiredDate;
    double weight = 0.0;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.vaccines, color: Colors.teal),
              SizedBox(width: 8),
              Text(
                "Add Vaccination",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(
                  "Vaccine Name",
                  (value) => name = value,
                  Icons.medication,
                ),
                _buildTextField(
                  "Type of Vaccine",
                  (value) => type = value,
                  Icons.category,
                ),
                _buildDateField(
                  "Administered Date",
                  (date) => administeredDate = date,
                  Icons.calendar_today,
                ),
                _buildDateField(
                  "Expiry Date",
                  (date) => expiredDate = date,
                  Icons.event,
                ),
                _buildTextField(
                  "Weight (kg)",
                  (value) => weight = double.tryParse(value) ?? 0.0,
                  Icons.monitor_weight,
                ),
                _buildTextField(
                  "Veterinarian Name",
                  (value) => vetName = value,
                  Icons.person,
                ),
                _buildTextField(
                  "Veterinarian Phone",
                  (value) => vetPhone = value,
                  Icons.phone,
                ),
              ],
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          actions: [
            TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      vertical: 12.0,
                      horizontal: 20.0,
                    ), // Padding for better touch target
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        8.0,
                      ), // Rounded corners
                      side: BorderSide(
                        color:
                            Colors
                                .red[700]!, // Red border color to match the text
                        width: 2.0, // Border width
                      ),
                    ),
                  ),
                  onPressed:
                      () => Navigator.pop(
                        context,
                        false,
                      ), // Indicates canceling the action
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      color:
                          Colors
                              .red[700], // Red color to indicate a cancel action
                      fontWeight: FontWeight.w500,
                      fontSize: 16, // Slightly larger text
                    ),
                  ),
                ),
            ElevatedButton.icon(
              onPressed: () async {
                if (name.isNotEmpty &&
                    type.isNotEmpty &&
                    administeredDate != null &&
                    expiredDate != null &&
                    vetName.isNotEmpty &&
                    vetPhone.isNotEmpty) {
                  Vaccine vaccine = Vaccine(
                    id: '', // Generate random ID
                    name: name,
                    type: type,
                    administeredDate: administeredDate!,
                    expiredDate: expiredDate!,
                    weight: weight,
                    vetName: vetName,
                    vetPhoneNumber: vetPhone,
                    userId: '',
                  );

                  // Add to Firestore using VaccineControllers
                  await _vaccineControllers.addVaccine(vaccine);

                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);

                  // Show success notification
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Vaccination record added successfully!'),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                } else {
                  // Show validation error
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please fill in all required fields'),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                }
              },
              icon: Icon(Icons.check, color: Colors.white),
              label: Text("Add", style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(
    String label,
    Function(String) onChanged,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          prefixIcon: Icon(icon, color: Colors.teal),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.teal, width: 2),
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildDateField(
    String label,
    Function(DateTime) onChanged,
    IconData icon,
  ) {
    TextEditingController controller = TextEditingController();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: () async {
          DateTime? selectedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2101),
            builder: (context, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: ColorScheme.light(
                    primary: Colors.teal,
                    onPrimary: Colors.white,
                    onSurface: Colors.black,
                  ),
                  textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(foregroundColor: Colors.teal),
                  ),
                ),
                child: child!,
              );
            },
          );
          if (selectedDate != null) {
            onChanged(selectedDate);
            controller.text = '${selectedDate.toLocal()}'.split(' ')[0];
          }
        },
        child: TextField(
          controller: controller,
          enabled: false,
          decoration: InputDecoration(
            labelText: label,
            hintText: 'Select Date',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            prefixIcon: Icon(icon, color: Colors.teal),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String userId = _auth.currentUser!.uid;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Vaccine Records",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF4CAF50),
        centerTitle: true,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle_outline, color: Colors.white),
            onPressed: _showAddVaccineForm,
            tooltip: "Add Vaccine Record",
          ),
          SizedBox(width: 8),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: StreamBuilder<List<Vaccine>>(
          stream: _vaccineControllers.getVaccinesByUserId(userId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(color: Colors.teal),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error_outline, color: Colors.red, size: 48),
                    SizedBox(height: 16),
                    Text(
                      'Error: ${snapshot.error}',
                      style: TextStyle(color: Colors.red),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => setState(() {}),
                      child: Text("Retry"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                      ),
                    ),
                  ],
                ),
              );
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.pets, color: Colors.grey, size: 64),
                    SizedBox(height: 16),
                    Text(
                      'No vaccination records available.',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _showAddVaccineForm,
                      icon: Icon(Icons.add ,color: Colors.white,),
                      label: Text("Add First Vaccination" , style: TextStyle(color: Colors.white),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                      ),
                    ),
                  ],
                ),
              );
            }

            List<Widget> vaccineTiles =
                snapshot.data!.map((vaccine) {
                  DateTime administeredDate = vaccine.administeredDate;
                  DateTime expiredDate = vaccine.expiredDate;
                  bool isExpired = expiredDate.isBefore(DateTime.now());
                  Color tileColor =
                      isExpired ? Colors.red.shade50 : Colors.green.shade50;

                  // Calculate days until expiration or days since expiration
                  final difference =
                      expiredDate.difference(DateTime.now()).inDays;
                  String expiryStatus =
                      isExpired
                          ? "Expired ${difference.abs()} days ago"
                          : "Expires in $difference days";

                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: tileColor,
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              vaccine.name,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal.shade700,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: isExpired ? Colors.red : Colors.green,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              isExpired ? "EXPIRED" : "ACTIVE",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 6),
                          Text(
                            "Administered: ${administeredDate.toLocal().toString().split(' ')[0]}",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                          Text(
                            expiryStatus,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color:
                                  isExpired
                                      ? Colors.red
                                      : Colors.green.shade800,
                            ),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.info_outline, color: Colors.teal),
                            onPressed:
                                () => _showVaccineDetails(context, vaccine),
                            tooltip: "View Details",
                          ),
                          IconButton(
                            icon: Icon(Icons.delete_outline, color: Colors.red),
                            onPressed:
                                () => _confirmDeleteVaccine(context, vaccine),
                            tooltip: "Delete",
                          ),
                        ],
                      ),
                      leading: CircleAvatar(
                        backgroundColor: Colors.teal,
                        child: Icon(
                          Icons.medical_services,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  );
                }).toList();

            return ListView(children: vaccineTiles);
          },
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _showAddVaccineForm,
      //   child: Icon(Icons.add, color: Colors.white),
      //   backgroundColor: Colors.teal,
      //   tooltip: "Add New Vaccination",
      // ),
    );
  }

  // Enhanced vaccine details dialog
  void _showVaccineDetails(BuildContext context, Vaccine vaccine) {
    showDialog(
      context: context,
      builder: (context) {
        final bool isExpired = vaccine.expiredDate.isBefore(DateTime.now());

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.teal.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.vaccines, color: Colors.teal, size: 24),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            vaccine.name,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal.shade700,
                            ),
                          ),
                          Text(
                            vaccine.type,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Divider(height: 24),
                _buildDetailCard("Vaccination Information", [
                  _buildInfoRow("Type", vaccine.type, Icons.category),
                  _buildInfoRow(
                    "Administered",
                    vaccine.administeredDate.toLocal().toString().split(' ')[0],
                    Icons.event_available,
                  ),
                  _buildInfoRow(
                    "Expiry",
                    vaccine.expiredDate.toLocal().toString().split(' ')[0],
                    Icons.event,
                    isExpired ? Colors.red : Colors.green,
                  ),
                  _buildInfoRow(
                    "Weight",
                    "${vaccine.weight} kg",
                    Icons.monitor_weight,
                  ),
                ]),
                SizedBox(height: 16),
                _buildDetailCard("Veterinarian Information", [
                  _buildInfoRow("Name", vaccine.vetName, Icons.person),
                  _buildInfoRow("Phone", vaccine.vetPhoneNumber, Icons.phone),
                ]),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  
                  style: ElevatedButton.styleFrom(
                  
                    
                    backgroundColor: Colors.teal,
                    minimumSize: Size(double.infinity, 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text("Close" ,style: TextStyle(fontSize: 18, color: Colors.white),),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Enhanced delete confirmation dialog
  void _confirmDeleteVaccine(BuildContext context, Vaccine vaccine) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
             
              SizedBox(width: 8),
              Text("Delete  Record"),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Are you sure you want to delete this record?",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.teal,
                      radius: 16,
                      child: Icon(
                        Icons.vaccines,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            vaccine.name,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            vaccine.type,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
              Text(
                "This action cannot be undone.",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          actions: [
           TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      vertical: 12.0,
                      horizontal: 20.0,
                    ), // Padding for better touch target
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        8.0,
                      ), // Rounded corners
                      side: BorderSide(
                        color:
                            Colors
                                .red[700]!, // Red border color to match the text
                        width: 2.0, // Border width
                      ),
                    ),
                  ),
                  onPressed:
                      () => Navigator.pop(
                        context,
                        false,
                      ), // Indicates canceling the action
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      color:
                          Colors
                              .red[700], // Red color to indicate a cancel action
                      fontWeight: FontWeight.w500,
                      fontSize: 16, // Slightly larger text
                    ),
                  ),
                ),
            ElevatedButton.icon(
              onPressed: () async {
                await _vaccineControllers.deleteVaccine(vaccine.id);
                Navigator.pop(context);

                // Show success notification
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Vaccination record deleted'),
                    backgroundColor: Colors.red.shade700,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              },
           
              label: Text("Delete", style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailCard(String title, List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.teal.shade700,
            ),
          ),
          Divider(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value,
    IconData icon, [
    Color? iconColor,
  ]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: iconColor ?? Colors.teal),
          SizedBox(width: 12),
          Text(
            "$label:",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w400,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
