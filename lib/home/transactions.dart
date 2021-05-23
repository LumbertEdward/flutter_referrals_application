import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:points_application/constants/constants.dart';
import 'package:points_application/model/user.dart';

class Transactions extends StatefulWidget {
  final String email;
  const Transactions({Key? key, required this.email}) : super(key: key);

  @override
  _TransactionsState createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  late List<AllTransactions> transaction;
  bool isPresent = false;

  Future<void> getTransactions() async{
    var email = {"email": widget.email};
    var response = await http.post(Uri.parse(Constants().READTRANSACTIONS_URL), body: email);

    if(response.statusCode == 200){
      var res = jsonDecode(response.body);
      var mes = Message.fromJson(res);
      if(mes.message == "Successful"){
        transaction = (res['data'] as List)
            .map((e) => AllTransactions.fromJson(e))
            .toList();

        setState(() {
          isPresent = true;
        });
      }
    }
  }


  @override
  void initState() {
    getTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Transactions"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: isPresent ? transaction.length : null,
          itemBuilder: (context, index){
            return ListTile(
              title: isPresent ? Text(transaction[index].MESSAGE) : null
            );
          }
      ),
    );
  }
}
