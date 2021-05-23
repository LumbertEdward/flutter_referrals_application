import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:points_application/admin/adminpage.dart';
import 'package:points_application/constants/constants.dart';
import 'package:points_application/model/user.dart';
import 'package:http/http.dart' as http;

class SendMoney extends StatefulWidget {
  final String email;
  final RedeemedUsersData lst;
  const SendMoney({Key? key, required this.lst, required this.email}) : super(key: key);

  @override
  _SendMoneyState createState() => _SendMoneyState();
}

class _SendMoneyState extends State<SendMoney> {

  Future<void> sendTransactionToUser() async{
    String transaction = "Ksh ${(int.parse(widget.lst.POINTS) * 500).toString()} has been sent to your mpesa account";
    DateTime date = DateTime.now();
    DateTime t = DateTime(date.year, date.month, date.day);
    var email = {"email": widget.lst.EMAIL, "transaction": transaction, "date": t.toString()};
    var response = await http.post(Uri.parse(Constants().SENTTRANSACTIONS_URL), body: email);
    if(response.statusCode == 200){
      var res = jsonDecode(response.body);
      var data = Message.fromJson(res);
      if(data.message == "Successful"){
        sendTransactionToAdmin();
      }
    }

  }

  Future<void> sendTransactionToAdmin() async{
    String transaction = "Ksh ${(int.parse(widget.lst.POINTS) * 500).toString()} has been sent to ${widget.lst.EMAIL}";
    DateTime date = DateTime.now();
    DateTime t = DateTime(date.year, date.month, date.day);
    var email = {"email": widget.email, "transaction": transaction, "date": t.toString()};
    var response = await http.post(Uri.parse(Constants().SENTTRANSACTIONS_URL), body: email);
    if(response.statusCode == 200){
      var res = jsonDecode(response.body);
      var data = Message.fromJson(res);
      if(data.message == "Successful"){
        deleteRedeemedUser();
      }
    }

  }

  Future<void> deleteRedeemedUser() async{
    var email = {"email": widget.lst.EMAIL};
    var response = await http.post(Uri.parse(Constants().DELETEUSER_URL), body: email);
    if(response.statusCode == 200){
      var res = jsonDecode(response.body);
      var data = Message.fromJson(res);
      if(data.message == "Successful"){
        Navigator.push(context, MaterialPageRoute(builder: (context) => AdminHome(email: widget.email)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Payment"),
        centerTitle: true,
      ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 50,
                  width: 350,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepPurple,
                        offset: Offset(0.0, 1.0),
                        blurRadius: 4.0
                      ),
                    ]
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Text(widget.lst.EMAIL, style: TextStyle(fontSize: 17),),
                  ),
                ),
                SizedBox(height: 20,),
                Container(
                  height: 50,
                  width: 350,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.deepPurple,
                            offset: Offset(0.0, 1.0),
                            blurRadius: 4.0
                        ),
                      ]
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Text((int.parse(widget.lst.POINTS) * 500).toString(), style: TextStyle(fontSize: 17),),
                  ),
                ),
                SizedBox(height: 20,),
                SizedBox(
                  height: 50,
                  width: 350,
                  child: ElevatedButton(
                    onPressed: sendTransactionToUser,
                    child: Text("Pay"),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
