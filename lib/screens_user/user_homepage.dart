import 'package:ojtproject/admin_screens/transactions_history.dart';
import 'package:ojtproject/screens_user/user_upload.dart';

import 'disbursement_details.dart';

import 'package:flutter/material.dart';

class UserHomePage extends StatelessWidget {
  const UserHomePage({Key? key}) : super(key: key);

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
                  MaterialPageRoute(builder: (context) => const UserUpload()));
            },
            child: Container(
              height: 76,
              width: 357,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 59, 184, 47), 
                borderRadius: BorderRadius.circular(30),
                
                border: Border.all(color: Colors.white),
              ),
              child: const Center(child: Text('For Uploading',style: TextStyle(
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
                   MaterialPageRoute(builder: (context) => const TransactionsScreen()));
             },
            child: Container(
              height: 76,
              width: 357,
              decoration: BoxDecoration(
                color: Colors.blue,
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
