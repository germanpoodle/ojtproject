import 'package:flutter/material.dart';

class DisbursementCheque extends StatelessWidget {
  const DisbursementCheque({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 62, 151, 185),
        toolbarHeight: 77,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            SizedBox(width: 15, height: 45,),
            Text(
              'Disbursement',
              style: TextStyle(
                fontSize: 25,
                color: Color.fromARGB(255, 109, 33, 33),
              ),
            ),
            SizedBox(
              width: 220,
            ),
            Icon(
              size: 25,
              Icons.notifications,
              color: const Color.fromARGB(255, 54, 27, 25),
            ),
            SizedBox(
              width: 25,
            ),
            Icon(
              size: 25,
              Icons.person,
              color: const Color.fromARGB(255, 54, 27, 25),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(50),
            child: Container(
              width: 338,
              height: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22.0),
                border: Border.all(
                  color: Colors.grey,
                  width: 1,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(right: 225),
                child: Column(
                  children: [
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Filter by',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 36),
                    Text(
                      'Doc Type',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    Container(
                      color: const Color.fromARGB(0, 237, 237, 237),
                      child: DropdownButtonFormField(
                        items: const [
                          DropdownMenuItem(
                            child: Text(' '),
                            value: ' ',
                          ),
                        ],
                        onChanged: (ValueChanged) => Text,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
