import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  List<Map<String, dynamic>> insuranceReports = [];

  @override
  void initState() {
    super.initState();
    _fetchInsuranceReports();
  }

  Future<void> _fetchInsuranceReports() async {
    final snapshot = await FirebaseFirestore.instance.collection('insuranceCovers').get();
    setState(() {
      insuranceReports = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Insurance Reports'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Generated Reports',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 20),

            // Report List
            Expanded(
              child: insuranceReports.isEmpty
                  ? Center(
                child: Text(
                  'No reports available.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
                  : ListView.builder(
                itemCount: insuranceReports.length,
                itemBuilder: (context, index) {
                  final report = insuranceReports[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 16),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Color(0xFF30BEB6)),
                    ),
                    child: ListTile(
                      title: Text(
                        report['insuranceName'] ?? '',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      subtitle: Text(
                        'Country: ${report['insuranceCountry'] ?? ''}\n'
                            'Hospitals: ${report['hospitalsCovered']?.join(', ') ?? ''}\n'
                            'Price: \$${report['insurancePrice']?.toStringAsFixed(2) ?? ''}',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
