import 'package:flutter/material.dart';
import 'package:project_one/models/madical_records.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MedicalRecordsScreen extends StatefulWidget {
  const MedicalRecordsScreen({super.key});

  @override
  State<MedicalRecordsScreen> createState() => _MedicalRecordsScreenState();
}




class _MedicalRecordsScreenState extends State<MedicalRecordsScreen> {
  List<bool> expandedStates = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Medical Records",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF4CAF50), // Green color from the image
        centerTitle: true,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle_outline, color: Colors.white),
            onPressed: _showAddRecordForm,
          ),
          SizedBox(width: 8), // Add a bit of padding
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Medical History",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<List<MedicalRecord>>(
                stream: MedicalRecordController().getUserMedicalRecords(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No records found.'));
                  }

                  final records = snapshot.data!;

                  // Initialize expandedStates to be the same size as the number of records
                  if (expandedStates.length != records.length) {
                    expandedStates = List<bool>.filled(records.length, false);
                  }

                  return ListView.builder(
                    itemCount: records.length,
                    itemBuilder: (context, index) {
                      final record = records[index];
                      return Card(
                        elevation: 2,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            ListTile(
                              leading: Icon(Icons.healing, color: Colors.teal),
                              title: Text(
                                record.virus,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Text(
                                "${record.date.day}/${record.date.month}/${record.date.year}",
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red[400],
                                      size: 22,
                                    ),
                                    onPressed: () async {
                                      bool confirmDelete =
                                          await showDeleteConfirmationDialog(
                                            record,
                                            context,
                                          );
                                      if (confirmDelete) {
                                        MedicalRecordController().deleteRecord(
                                          record.id,
                                        );
                                        Fluttertoast.showToast(
                                          msg: "Record deleted successfully",
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                        );
                                      }
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      expandedStates[index]
                                          ? Icons.expand_less
                                          : Icons.expand_more,
                                      color: Colors.teal,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        expandedStates[index] =
                                            !expandedStates[index];
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            if (expandedStates[index])
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: 8.0,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Divider(),
                                    _buildDetailRow(
                                      "Veterinarian",
                                      record.vetName,
                                    ),
                                    _buildDetailRow("Type", record.type),
                                    _buildDetailRow(
                                      "Date",
                                      "${record.date.day}/${record.date.month}/${record.date.year}",
                                    ),
                                    _buildDetailRow("Purpose", record.purpose),
                                    _buildDetailRow("Comment", record.comment),
                                    _buildDetailRow(
                                      "Expires",
                                      "${record.expires.day}/${record.expires.month}/${record.expires.year}",
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _showAddRecordForm,
      //   backgroundColor: Color(0xFF4CAF50),
      //   child: Icon(Icons.add, color: Colors.white),
      // ),
    );
  }

  void _showAddRecordForm() {
    String virus = "", vetName = "", type = "", purpose = "", comment = "";
    DateTime? date, expires;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          title: Text(
            "Add Medical Record",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
              fontSize: 20.0,
            ),
          ),
          content: Container(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8.0),
                  _buildTextField(
                    "Virus Name",
                    (value) => virus = value,
                    prefixIcon: Icons.medical_services,
                  ),
                  SizedBox(height: 16.0),
                  _buildTextField(
                    "Veterinarian Name",
                    (value) => vetName = value,
                    prefixIcon: Icons.person,
                  ),
                  SizedBox(height: 16.0),
                  _buildTextField(
                    "Type of Treatment",
                    (value) => type = value,
                    prefixIcon: Icons.local_hospital,
                  ),
                  SizedBox(height: 16.0),
                  _buildDateField(
                    "Treatment Date",
                    (value) => date = value,
                    prefixIcon: Icons.calendar_today,
                  ),
                  SizedBox(height: 16.0),
                  _buildTextField(
                    "Purpose",
                    (value) => purpose = value,
                    prefixIcon: Icons.description,
                  ),
                  SizedBox(height: 16.0),
                  _buildTextField(
                    "Veterinarian Comment",
                    (value) => comment = value,
                    prefixIcon: Icons.comment,
                    maxLines: 3,
                  ),
                  SizedBox(height: 16.0),
                  _buildDateField(
                    "Expiry Date",
                    (value) => expires = value,
                    prefixIcon: Icons.event_busy,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.red[700], // Red background color
                padding: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 20,
                ), // Padding for better touch target
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // Rounded corners
                ),
              ),
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text(
                "Add Record",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              onPressed: () {
                if (virus.isEmpty || vetName.isEmpty || type.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Please fill in all required fields"),
                      backgroundColor: Colors.red[400],
                    ),
                  );
                  return;
                }

                if (date != null && expires != null) {
                  MedicalRecordController().addRecord(
                    MedicalRecord(
                      virus: virus,
                      vetName: vetName,
                      type: type,
                      date: date!,
                      purpose: purpose,
                      comment: comment,
                      expires: expires!,
                    ),
                  );
                  Navigator.pop(context);
                  Fluttertoast.showToast(
                    msg: "Record added successfully",
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Please select treatment and expiry dates"),
                      backgroundColor: Colors.red[400],
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(
    String label,
    Function(String) onChanged, {
    IconData? prefixIcon,
    int maxLines = 1,
  }) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[700]),
        prefixIcon:
            prefixIcon != null
                ? Icon(prefixIcon, color: Theme.of(context).primaryColor)
                : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2.0,
          ),
        ),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      ),
      style: TextStyle(fontSize: 16.0),
      maxLines: maxLines,
      onChanged: onChanged,
    );
  }

  Widget _buildDateField(
    String label,
    Function(DateTime) onChanged, {
    IconData? prefixIcon,
  }) {
    TextEditingController controller = TextEditingController();

    return GestureDetector(
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
                  primary: Theme.of(context).primaryColor,
                  onPrimary: Colors.white,
                  surface: Colors.white,
                  onSurface: Colors.black,
                ),
                dialogBackgroundColor: Colors.white,
              ),
              child: child!,
            );
          },
        );
        if (selectedDate != null) {
          onChanged(selectedDate);
          controller.text =
              "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
        }
      },
      child: TextField(
        controller: controller,
        enabled: false,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey[700]),
          hintText: 'Select Date',
          prefixIcon:
              prefixIcon != null
                  ? Icon(prefixIcon, color: Theme.of(context).primaryColor)
                  : null,
          suffixIcon: Icon(
            Icons.calendar_today,
            color: Theme.of(context).primaryColor,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          filled: true,
          fillColor: Colors.grey[50],
          contentPadding: EdgeInsets.symmetric(
            vertical: 12.0,
            horizontal: 16.0,
          ),
        ),
        style: TextStyle(fontSize: 16.0, color: Colors.black87),
      ),
    );
  }

  Future<bool> showDeleteConfirmationDialog(
    MedicalRecord record,
    BuildContext context,
  ) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              title: Text(
                "Delete Record",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red[700],
                  fontSize: 20.0,
                ),
              ),

              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Are you sure you want to delete this medical record?",
                    style: TextStyle(fontSize: 16.0),
                  ),
                  SizedBox(height: 12.0),
                  Container(
                    padding: EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Record Details:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          "Treatment: ${record.virus} (${record.type})",
                          style: TextStyle(color: Colors.grey[800]),
                        ),
                        Text(
                          "Date: ${record.date.day}/${record.date.month}/${record.date.year}",
                          style: TextStyle(color: Colors.grey[800]),
                        ),
                        Text(
                          "Veterinarian: ${record.vetName}",
                          style: TextStyle(color: Colors.grey[800]),
                        ),
                      ],
                    ),
                  ),
                ],
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

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[700], // Red background color
                    padding: EdgeInsets.symmetric(
                      vertical:
                          12.0, // Increase vertical padding for a bigger button
                      horizontal: 20.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        8.0,
                      ), // Rounded corners
                    ),
                    elevation: 5, // Slight elevation to give it a 3D effect
                  ),
                  onPressed: () => Navigator.pop(context, true),
                  child: Text(
                    "Delete",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 16, // Slightly larger text size for emphasis
                    ),
                  ),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label: ",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.teal[800],
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? "N/A" : value,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
            ),
          ),
        ],
      ),
    );
  }
}
