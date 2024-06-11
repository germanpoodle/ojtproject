import 'package:flutter/material.dart';

class DisbursementCheque extends StatelessWidget {
  const DisbursementCheque({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        backgroundColor: Color.fromARGB(255, 9, 41, 145),
        toolbarHeight: 77,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            SizedBox(width: 15, height: 45,),
            Text(
              'Disbursement',
              style: TextStyle(
                fontSize: 25,
                color: Color.fromARGB(255, 233, 227, 227),
              ),
            ),
            SizedBox(
              width: 260,
            ),
            Icon(
              size: 25,
              Icons.notifications,
              color: Color.fromARGB(255, 233, 227, 227),
            ),
            SizedBox(
              width: 25,
            ),
            Icon(
              size: 25,
              Icons.person,
              color: Color.fromARGB(255, 233, 227, 227),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(50),
          ),
        ],
      ),
    );
  }
}
