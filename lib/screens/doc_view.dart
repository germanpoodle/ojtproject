import 'package:day13/screens/disbursement_check.dart';
import 'package:day13/screens/transaction_history.dart';
import 'package:flutter/material.dart';

class Disbursement extends StatelessWidget {
  const Disbursement({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
       height: double.infinity,
       width: double.infinity,
       decoration: const BoxDecoration(
         gradient: LinearGradient(
           colors: [
             Color.fromARGB(255, 112, 23, 184),
             Color(0xff281537),
           ]
         )
       ),
       child: Column(
         children: [
           const Padding(
             padding: EdgeInsets.only(top: 400.0),
           ),
          const SizedBox(height: 30,),
          GestureDetector(
            onTap: (){
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const DisbursementCheque()));
            },
            child: Container(
              height: 76,
              width: 357,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                
                border: Border.all(color: Colors.white),
              ),
              child: const Center(child: Text('Check Disbursement',style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
              ),),),
            ),
          ),
          const SizedBox(height: 15,),
          GestureDetector(
            onTap: (){
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const TransactionHistory()));
            },
            child: Container(
              height: 76,
              width: 357,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white),
              ),
              child: const Center(child: Text('Transaction History',style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
              ),),),
            ),
          ),
          ]
       ),
     ),
    );
  }
}
