import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'edit_insurance_screen.dart';

class InsuranceCover extends StatefulWidget {
  const InsuranceCover({super.key});

  @override
  State<InsuranceCover> createState() => _InsuranceCoverState();
}

class _InsuranceCoverState extends State<InsuranceCover> {
  final TextEditingController insuranceNameController = TextEditingController();
  final TextEditingController insuranceCountryController = TextEditingController();
  final TextEditingController hospitalsCoveredController = TextEditingController();
  final TextEditingController insurancePriceController = TextEditingController();

  List<Map<String, dynamic>> insuranceCovers = [];
  bool isLoading = false; // Track loading state

  @override
  void initState() {
    super.initState();
    _fetchInsuranceCovers();
  }

  Future<void> _fetchInsuranceCovers() async {
    final snapshot = await FirebaseFirestore.instance.collection('insuranceCovers').get();
    setState(() {
      insuranceCovers = snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  Future<void> _addInsuranceCover() async {
    setState(() {
      isLoading = true; // Set loading state
    });

    final insuranceName = insuranceNameController.text.trim();
    final insuranceCountry = insuranceCountryController.text.trim();
    final hospitalsCovered = hospitalsCoveredController.text.split(',').map((e) => e.trim()).toList();
    final insurancePrice = double.tryParse(insurancePriceController.text.trim());

    if (insuranceName.isNotEmpty && insuranceCountry.isNotEmpty && hospitalsCovered.isNotEmpty && insurancePrice != null) {
      try {
        await FirebaseFirestore.instance.collection('insuranceCovers').add({
          'insuranceName': insuranceName,
          'insuranceCountry': insuranceCountry,
          'hospitalsCovered': hospitalsCovered,
          'insurancePrice': insurancePrice,
        });

        // Clear the text fields
        insuranceNameController.clear();
        insuranceCountryController.clear();
        hospitalsCoveredController.clear();
        insurancePriceController.clear();

        _fetchInsuranceCovers();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Insurance cover added successfully.')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add insurance cover: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields with valid data.')),
      );
    }

    setState(() {
      isLoading = false; // Reset loading state
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    double widthScale = screenWidth / 414;
    double heightScale = screenHeight / 896;

    return Scaffold(
      appBar: AppBar(
        title: Text('Health Insurance Covers'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16 * widthScale),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Insurance Cover',
                style: TextStyle(
                  fontFamily: 'Lexend',
                  fontSize: 24 * widthScale,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 20 * heightScale),

              _buildTextField(
                controller: insuranceNameController,
                label: 'Insurance Name',
                widthScale: widthScale,
                heightScale: heightScale,
              ),
              SizedBox(height: 16 * heightScale),

              _buildTextField(
                controller: insuranceCountryController,
                label: 'Insurance Country',
                widthScale: widthScale,
                heightScale: heightScale,
              ),
              SizedBox(height: 16 * heightScale),

              _buildTextField(
                controller: hospitalsCoveredController,
                label: 'Hospitals Covered (comma separated)',
                widthScale: widthScale,
                heightScale: heightScale,
              ),
              SizedBox(height: 16 * heightScale),

              _buildTextField(
                controller: insurancePriceController,
                label: 'Insurance Price (annually)',
                keyboardType: TextInputType.number,
                widthScale: widthScale,
                heightScale: heightScale,
              ),
              SizedBox(height: 24 * heightScale),

              Container(
                width: 378 * widthScale,
                height: 60 * heightScale,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _addInsuranceCover, // Disable button if loading
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF16AD4D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14 * widthScale),
                    ),
                  ),
                  child: isLoading // Show loading indicator if loading
                      ? CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  )
                      : Text(
                    'Add Insurance Cover',
                    style: TextStyle(
                      fontFamily: 'Lexend',
                      fontSize: 16 * widthScale,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 24 * heightScale),

              // Insurance Covers List
              Text(
                'Available Insurance Covers',
                style: TextStyle(
                  fontFamily: 'Lexend',
                  fontSize: 20 * widthScale,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 16 * heightScale),

              // Ensure proper height constraint for the list
              insuranceCovers.isEmpty
                  ? Center(
                child: Text(
                  'No insurance covers available.',
                  style: TextStyle(
                    fontFamily: 'Lexend',
                    fontSize: 16 * widthScale,
                    color: Color(0xFF445668),
                  ),
                ),
              )
                  : ListView.builder(
                shrinkWrap: true, // Important for scroll within scroll
                physics: NeverScrollableScrollPhysics(),
                itemCount: insuranceCovers.length,
                itemBuilder: (context, index) {
                  final cover = insuranceCovers[index];
                  return GestureDetector(
                    onTap: (){
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => EditInsuranceScreen(
                      //       documentId: cover['id'], // Assuming you've stored the document id
                      //       insuranceName: cover['insuranceName'],
                      //       insuranceCountry: cover['insuranceCountry'],
                      //       hospitalsCovered: cover['hospitalsCovered'].join(', '),
                      //       insurancePrice: cover['insurancePrice'],
                      //     ),
                      //   ),
                      // );
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 16 * heightScale),
                      padding: EdgeInsets.all(12 * widthScale),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10 * widthScale),
                        border: Border.all(
                          color: Color(0xFF30BEB6),
                          width: 1 * widthScale,
                        ),
                      ),
                      child: ListTile(
                        title: Text(
                          cover['insuranceName'] ?? '',
                          style: TextStyle(
                            fontFamily: 'Lexend',
                            fontSize: 18 * widthScale,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Text(
                          'Country: ${cover['insuranceCountry'] ?? ''}\n'
                              'Hospitals: ${cover['hospitalsCovered']?.join(', ') ?? ''}\n'
                              'Price: \$${cover['insurancePrice']?.toStringAsFixed(2) ?? ''}',
                          style: TextStyle(
                            fontFamily: 'Lexend',
                            fontSize: 14 * widthScale,
                            color: Color(0xFF445668),
                          ),
                        ),
                      ),
                    ),
                  );
                },
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
    double? widthScale,
    double? heightScale,
    TextInputType? keyboardType,
  }) {
    return Container(
      width: 378 * (widthScale ?? 1.0),
      height: 60 * (heightScale ?? 1.0),
      padding: EdgeInsets.symmetric(horizontal: 16 * (widthScale ?? 1.0)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10 * (widthScale ?? 1.0)),
        border: Border.all(
          color: Color(0xFF30BEB6),
          width: 1 * (widthScale ?? 1.0),
        ),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType ?? TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
          labelStyle: TextStyle(
            fontFamily: 'Lexend',
            fontSize: 16 * (widthScale ?? 1.0),
            color: Color(0xFF445668),
          ),
        ),
      ),
    );
  }
}
