import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditInsuranceScreen extends StatefulWidget {
  final String documentId;
  final String insuranceName;
  final String insuranceCountry;
  final String hospitalsCovered;
  final double insurancePrice;

  const EditInsuranceScreen({
    required this.documentId,
    required this.insuranceName,
    required this.insuranceCountry,
    required this.hospitalsCovered,
    required this.insurancePrice,
    Key? key,
  }) : super(key: key);

  @override
  _EditInsuranceScreenState createState() => _EditInsuranceScreenState();
}

class _EditInsuranceScreenState extends State<EditInsuranceScreen> {
  late TextEditingController insuranceNameController;
  late TextEditingController insuranceCountryController;
  late TextEditingController hospitalsCoveredController;
  late TextEditingController insurancePriceController;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize the text controllers with the passed data
    insuranceNameController = TextEditingController(text: widget.insuranceName);
    insuranceCountryController = TextEditingController(text: widget.insuranceCountry);
    hospitalsCoveredController = TextEditingController(text: widget.hospitalsCovered);
    insurancePriceController = TextEditingController(text: widget.insurancePrice.toString());
  }

  Future<void> _updateInsuranceCover() async {
    setState(() {
      isLoading = true;
    });

    final insuranceName = insuranceNameController.text.trim();
    final insuranceCountry = insuranceCountryController.text.trim();
    final hospitalsCovered = hospitalsCoveredController.text.split(',').map((e) => e.trim()).toList();
    final insurancePrice = double.tryParse(insurancePriceController.text.trim());

    if (insuranceName.isNotEmpty && insuranceCountry.isNotEmpty && hospitalsCovered.isNotEmpty && insurancePrice != null) {
      try {
        // Update the Firestore document with the new data
        await FirebaseFirestore.instance.collection('insuranceCovers').doc(widget.documentId).update({
          'insuranceName': insuranceName,
          'insuranceCountry': insuranceCountry,
          'hospitalsCovered': hospitalsCovered,
          'insurancePrice': insurancePrice,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Insurance cover updated successfully.')),
        );

        // Go back to the previous screen after successful update
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update insurance cover: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields with valid data.')),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Insurance Cover'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField(
              controller: insuranceNameController,
              label: 'Insurance Name',
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: insuranceCountryController,
              label: 'Insurance Country',
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: hospitalsCoveredController,
              label: 'Hospitals Covered (comma separated)',
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: insurancePriceController,
              label: 'Insurance Price (annually)',
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: isLoading ? null : _updateInsuranceCover,
              child: isLoading
                  ? CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              )
                  : Text('Update Insurance Cover'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType ?? TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
    );
  }
}
