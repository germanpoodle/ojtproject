// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:flutter/services.dart';
// import '/models/disbursement_data_model.dart';
// import 'user_add_attachment.dart';


// void navigateToNotifications(BuildContext context) {
//   Navigator.pushNamed(context, '/notifications');
// }

// Future<List<TransactionDataScreen>> fetchTransactionData() async {
//   final String response = await rootBundle.loadString('assets/data.json');
//   final data = await json.decode(response);

//   List<TransactionDataScreen> details = [];
//   for (var item in data[2]['data']) {
//     details.add(TransactionDataScreen.fromJson(item));
//   }
//   return details;
// }

// class TransactionDataScreen extends StatelessWidget {

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color.fromARGB(255, 9, 41, 145),
//         toolbarHeight: 77,
//         automaticallyImplyLeading: false,
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             const Padding(
//               padding: EdgeInsets.only(left: 16.0),
//               child: Text(
//                 'View Disbursement Details',
//                 style: TextStyle(
//                   fontSize: 25,
//                   color: Color.fromARGB(255, 233, 227, 227),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(right: 16.0),
//               child: Row(
//                 children: [
//                   IconButton(
//                     onPressed: () {
//                       navigateToNotifications(context);
//                     },
//                     icon: const Icon(
//                       Icons.notifications,
//                       size: 25,
//                       color: Color.fromARGB(255, 126, 124, 124),
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   ElevatedButton(
//                     onPressed: () {},
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color.fromARGB(125, 68, 65, 65),
//                       padding: const EdgeInsets.all(5),
//                       shape: const CircleBorder(),
//                     ),
//                     child: const Icon(
//                       Icons.person,
//                       size: 25,
//                       color: Color.fromARGB(255, 233, 227, 227),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: FutureBuilder<List<TransactionData>>(
//           future: fetchTransactionData(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             } else if (snapshot.hasError) {
//               return Center(child: Text('Error: ${snapshot.error}'));
//             } else if (snapshot.hasData) {
//               final details = snapshot.data!;
//               return ListView.builder(
//                 itemCount: details.length,
//                 itemBuilder: (context, index) {
//                   final detail = details[index];
//                   return Card(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(15),
//                     ),
//                     elevation: 4,
//                     child: Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           TextFormField(
//                             initialValue: detail.transactingParty,
//                             decoration: const InputDecoration(
//                               hintText: 'Enter company name',
//                               contentPadding:
//                                   EdgeInsets.symmetric(horizontal: 10),
//                               border: OutlineInputBorder(),
//                             ),
//                             enabled: false, // Non-editable field
//                           ),
//                           const SizedBox(height: 20),
//                           Table(
//                             columnWidths: {
//                               0: const FlexColumnWidth(
//                                   1), // Adjust column 0 (labels) width
//                               1: const FlexColumnWidth(
//                                   2), // Adjust column 1 (text fields) width
//                             },
//                             border: TableBorder.all(
//                                 width: 1.0, color: Colors.black),
//                             children: [
//                               _buildTableRow('Doc Type', detail.docType),
//                               _buildTableRow('Doc No', detail.docNo),
//                               _buildTableRow(
//                                   'Transacting Party', detail.transactingParty),
//                               _buildTableRow('Transaction Status',
//                                   detail.transactionStatus),
//                               _buildTableRow(
//                                   'Check Amount', detail.checkAmount.toString()),
//                               _buildEditableTableRow('Remarks', detail.remarks),
//                             ],
//                           ),
//                           const SizedBox(height: 20),
//                           Center(
//                               child: TextButton(
//                             onPressed: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) => const UserAddAttachment()),
//                               );
//                             },
//                             child: const Text('Add Attachment'),
//                             style: TextButton.styleFrom(
//                               foregroundColor: Colors.white,
//                               backgroundColor: Colors.blue,
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 16, vertical: 8),
//                             ),
//                           )),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               );
//             } else {
//               return const Center(child: Text('No data found'));
//             }
//           },
//         ),
//       ),
//     );
//   }

//   TableRow _buildTableRow(String label, String value) {
//     return TableRow(
//       children: [
//         TableCell(
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text(
//               label,
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//           ),
//         ),
//         TableCell(
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextFormField(
//               initialValue: value,
//               decoration: const InputDecoration(
//                 hintText: 'Enter value',
//                 contentPadding: EdgeInsets.symmetric(horizontal: 10),
//                 border: OutlineInputBorder(),
//               ),
//               enabled: false, // Non-editable field
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   TableRow _buildEditableTableRow(String label, String value) {
//     return TableRow(
//       children: [
//         TableCell(
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text(
//               label,
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//           ),
//         ),
//         TableCell(
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextFormField(
//               initialValue: value,
//               decoration: const InputDecoration(
//                 hintText: 'Enter remarks',
//                 contentPadding: EdgeInsets.symmetric(horizontal: 10),
//                 border: OutlineInputBorder(),
//               ),
//               enabled: true, // Editable field
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
