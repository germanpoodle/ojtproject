import 'package:flutter/material.dart';

class CheckDetailsScreen extends StatelessWidget {
  const CheckDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Check Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {},
          ),
          CircleAvatar(
            child: Icon(Icons.person),
          ),
          SizedBox(width: 20,)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('[Transacting Party]',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('[Date of Transaction]',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('[Type of Transaction]',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[200],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Text('[Check Date]', style: TextStyle(fontSize: 16)),
                  ),
                  SizedBox(height: 8),
                  Text('[Check No.]', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  Text('[Check Drawee Bank]', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  Text('[Check Payee]', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  Text('[Check Amount]', style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
            Spacer(),
            ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.attachment),
              label: Text('View Attachment'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
            SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.check),
              label: Text('Approve'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Colors.green,
              ),
            ),
            SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.close),
              label: Text('Decline'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Color.fromARGB(255, 218, 51, 51),
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
              
              },
              child: Container(
                height: 35,
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xffB81736),
                      Color(0xff281537),
                    ],
                  ),
                ),
                child: const Center(
                  child: Text(
                    'View Details',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
