import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_one/models/pet_profile.dart';

class PetEditForm extends StatefulWidget {
  final Function onSave; // Callback function to handle form submission
  final PetProfileModel? initialData; // Added initial data for editing
  
  const PetEditForm({
    Key? key, 
    required this.onSave, 
    this.initialData, // Optional parameter for editing
  }) : super(key: key);
  
  @override
  _PetEditFormState createState() => _PetEditFormState();
}

class _PetEditFormState extends State<PetEditForm> {
  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  
  DateTime? _selectedBirthday;
  int? _age;
  String _selectedPetType = 'Dog'; // Default value
  final List<String> _petTypes = ['Dog', 'Cat', 'Bird', 'Rabbit', 'Fish', 'Other'];
  
  @override
  void initState() {
    super.initState();
    
    // Populate form with initial data if provided (for editing)
    if (widget.initialData != null) {
      _nameController.text = widget.initialData!.name;
      _breedController.text = widget.initialData!.breed;
      _selectedPetType = widget.initialData!.type;
      _typeController.text = widget.initialData!.type;
      _ageController.text = widget.initialData!.age.toString();
      _birthdayController.text = widget.initialData!.birthday;
      _weightController.text = widget.initialData!.weight.toString();
      _heightController.text = widget.initialData!.height.toString();
      
      // Try to parse birthday string to DateTime if possible
      try {
        _selectedBirthday = DateFormat('dd/MM/yyyy').parse(widget.initialData!.birthday);
      } catch (e) {
        // If parsing fails, we'll leave it as null
        print('Could not parse birthday: $e');
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }
  
  Widget contentBox(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: const Offset(0.0, 10.0),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with icon and text (Edit or New depending on initialData)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.pets,
                    color: Theme.of(context).primaryColor,
                    size: 28,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    widget.initialData != null ? "Edit Pet Profile" : "New Pet Profile",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              
              // Name field
              _buildTextField(
                controller: _nameController,
                label: "Pet Name",
                prefixIcon: Icons.pets,
                validator: (value) => value!.isEmpty ? "Enter pet's name" : null,
              ),
              const SizedBox(height: 16),
              
              // Pet type dropdown
              _buildDropdownField(
                label: "Pet Type",
                prefixIcon: Icons.category,
                value: _selectedPetType,
                items: _petTypes,
                onChanged: (newValue) {
                  setState(() {
                    _selectedPetType = newValue!;
                    _typeController.text = newValue;
                  });
                },
              ),
              const SizedBox(height: 16),
              
              // Breed field
              _buildTextField(
                controller: _breedController,
                label: "Breed",
                prefixIcon: Icons.pets_outlined,
                validator: (value) => value!.isEmpty ? "Enter breed" : null,
              ),
              const SizedBox(height: 16),
              
              // Birthday field with date picker
              _buildDateField(
                label: "Birthday", 
                prefixIcon: Icons.cake,
                onChanged: (DateTime date) {
                  setState(() {
                    _selectedBirthday = date;
                    _calculateAge();
                  });
                },
              ),
              const SizedBox(height: 16),
              
              // Age field (calculated automatically)
              _buildTextField(
                controller: _ageController,
                label: "Age (years)",
                prefixIcon: Icons.timeline,
                enabled: false,
                hintText: _age == null ? "Will be calculated from birthday" : null,
              ),
              const SizedBox(height: 16),
              
              // Weight field
              _buildTextField(
                controller: _weightController,
                label: "Weight (kg)",
                prefixIcon: Icons.monitor_weight,
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? "Enter weight" : null,
              ),
              const SizedBox(height: 16),
              
              // Height field
              _buildTextField(
                controller: _heightController,
                label: "Height (cm)",
                prefixIcon: Icons.height,
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? "Enter height" : null,
              ),
              const SizedBox(height: 24),
              
              // Button row for Save and Cancel
              Row(
                children: [
                  // Cancel button
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: BorderSide(color: Theme.of(context).primaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Save button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        elevation: 2,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        widget.initialData != null ? "Update" : "Save",
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    IconData? prefixIcon,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    bool enabled = true,
    String? hintText,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[700]),
        hintText: hintText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: Theme.of(context).primaryColor) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2.0),
        ),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      ),
      style: const TextStyle(fontSize: 16.0, color: Colors.black87),
      keyboardType: keyboardType,
      validator: validator,
    );
  }
  
  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
    IconData? prefixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.grey[300]!),
        color: Colors.grey[50],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        children: [
          if (prefixIcon != null)
            Icon(prefixIcon, color: Theme.of(context).primaryColor),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: label,
                  labelStyle: TextStyle(color: Colors.grey[700]),
                  border: InputBorder.none,
                ),
                value: value,
                items: items.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
                onChanged: onChanged,
                icon: const Icon(Icons.arrow_drop_down),
                isExpanded: true,
                style: const TextStyle(fontSize: 16.0, color: Colors.black87),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDateField({
    required String label,
    required Function(DateTime) onChanged,
    IconData? prefixIcon,
  }) {
    return GestureDetector(
      onTap: () async {
        DateTime? selectedDate = await showDatePicker(
          context: context,
          initialDate: _selectedBirthday ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
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
          setState(() {
            _birthdayController.text = DateFormat('dd/MM/yyyy').format(selectedDate);
          });
        }
      },
      child: AbsorbPointer(
        child: TextFormField(
          controller: _birthdayController,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: Colors.grey[700]),
            hintText: 'Select Date',
            prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: Theme.of(context).primaryColor) : null,
            suffixIcon: Icon(Icons.calendar_today, color: Theme.of(context).primaryColor),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          ),
          style: const TextStyle(fontSize: 16.0, color: Colors.black87),
          validator: (value) => value!.isEmpty ? "Select birthday" : null,
        ),
      ),
    );
  }
  
  void _calculateAge() {
    if (_selectedBirthday != null) {
      final now = DateTime.now();
      final difference = now.difference(_selectedBirthday!);
      final years = difference.inDays ~/ 365;
      setState(() {
        _age = years;
        _ageController.text = years.toString();
      });
    }
  }
  
  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      widget.onSave({
        'name': _nameController.text,
        'type': _typeController.text.isEmpty ? _selectedPetType : _typeController.text,
        'breed': _breedController.text,
        'age': _age ?? int.tryParse(_ageController.text) ?? 0,
        'birthday': _birthdayController.text,
        'weight': double.tryParse(_weightController.text) ?? 0.0,
        'height': double.tryParse(_heightController.text) ?? 0.0,
        'birthdayDateTime': _selectedBirthday,
      });
      
      Navigator.of(context).pop();
    }
  }
}