import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import '/models/disbursement_data_model.dart';
import 'view_files.dart';



Future<List<DisbursementDetails>> fetchDisbursementDetails() async {
  final String response = await rootBundle.loadString('assets/data.json');
  final data = await json.decode(response);

  List<DisbursementDetails> details = [];
  for (var item in data[2]['data']) {
    details.add(DisbursementDetails.fromJson(item));
  }
  return details;
}

class UserSendAttachment extends StatefulWidget {
  const UserSendAttachment({Key? key}) : super(key: key);

  @override
  State<UserSendAttachment> createState() => _UserSendAttachmentState();
}

class _UserSendAttachmentState extends State<UserSendAttachment> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 9, 41, 145),
        toolbarHeight: 77,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'View Disbursement Details',
              style: TextStyle(
                fontSize: 25,
                color: Color.fromARGB(255, 233, 227, 227),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: EdgeInsets.only(right: screenWidth * 0.02),
                  child: IconButton(
                    onPressed: () {
                      // Handle notification button press
                    },
                    icon: Icon(
                      Icons.notifications,
                      size: 25,
                      color: Color.fromARGB(255, 126, 124, 124),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle profile button press
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(125, 68, 65, 65),
                    padding: EdgeInsets.all(5),
                    shape: CircleBorder(),
                  ),
                  child: Icon(
                    Icons.person,
                    size: 25,
                    color: Color.fromARGB(255, 233, 227, 227),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<DisbursementDetails>>(
          future: fetchDisbursementDetails(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final details = snapshot.data!;
              return ListView.builder(
                itemCount: details.length,
                itemBuilder: (context, index) {
                  final detail = details[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            initialValue: detail.transactingParty,
                            decoration: InputDecoration(
                              hintText: 'Enter company name',
                              contentPadding: EdgeInsets.symmetric(horizontal: 10),
                              border: OutlineInputBorder(),
                            ),
                            enabled: false, // Non-editable field
                          ),
                          SizedBox(height: 20),
                          Table(
                            columnWidths: {
                              0: FlexColumnWidth(1), // Adjust column 0 (labels) width
                              1: FlexColumnWidth(2), // Adjust column 1 (text fields) width
                            },
                            border: TableBorder.all(width: 1.0, color: Colors.black),
                            children: [
                              _buildTableRow('Doc Type', detail.docType),
                              _buildTableRow('Doc No', detail.docNo),
                              _buildTableRow('Transacting Party', detail.transactingParty),
                              _buildTableRow('Transaction Status', detail.transactionStatus),
                              _buildTableRow('Check Amount', detail.checkAmount),
                              _buildEditableTableRow('Remarks', detail.remarks),
                            ],
                          ),
                          SizedBox(height: 20),
                          _buildButtons(context),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(child: Text('No data found'));
            }
          },
        ),
      ),
    );
  }

  TableRow _buildTableRow(String label, String value) {
    return TableRow(
      children: [
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              initialValue: value,
              decoration: InputDecoration(
                hintText: 'Enter value',
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                border: OutlineInputBorder(),
              ),
              enabled: false, // Non-editable field
            ),
          ),
        ),
      ],
    );
  }

  TableRow _buildEditableTableRow(String label, String value) {
    return TableRow(
      children: [
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              initialValue: value,
              decoration: InputDecoration(
                hintText: 'Enter remarks',
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                border: OutlineInputBorder(),
              ),
              enabled: true, // Editable field
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ViewFilesPage()),
            );
          },
          icon: Icon(Icons.folder_open),
          label: Text('View Files'),
          style: ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity, 50),
            backgroundColor: Colors.grey[400],
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Text('File uploaded successfully.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Close'),
                    ),
                  ],
                );
              },
            );
          },
          icon: Icon(Icons.send),
          label: Text('Send'),
          style: ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity, 50),
            backgroundColor: Colors.grey[400],
          ),
        ),
      ],
    );
  }
}

