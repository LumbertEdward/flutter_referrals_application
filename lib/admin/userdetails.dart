import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:points_application/admin/adminpage.dart';
import 'package:points_application/constants/constants.dart';
import 'package:points_application/model/user.dart';
import 'package:http/http.dart' as http;

class UserDetails extends StatefulWidget {
  final String admin;
  final String email;
  final List<User> all;
  const UserDetails({Key? key, required this.email, required this.all, required this.admin}) : super(key: key);

  @override
  _UserDetailsState createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {

  String selectItem = "none";
  List<String> det = ["none"];

  void setEmails(){
    for(int i = 0; i < widget.all.length; i++){
      det.add(widget.all[i].EMAIL);
    }
  }

  Future<void> sendData() async{
    String notification = "Congratulations, you have earned a point after referring ${widget.email}";
    DateTime date = DateTime.now();
    DateTime t = DateTime(date.year, date.month, date.day);
    var dat = {"referredEmail": widget.email, "referrerEmail": selectItem, "notification": notification, "date": t.toString()};
    var response = await http.post(Uri.parse(Constants().REFERREDUSER_URL), body: dat);
    if(response.statusCode == 200){
      var res = jsonDecode(response.body);
      var data = Message.fromJson(res);
      if(data.message == "Successful"){
        Navigator.push(context, MaterialPageRoute(builder: (context) => AdminHome(email: widget.admin)));
      }
    }
  }


  @override
  void initState() {
    setEmails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Referrals"),
        centerTitle: true,
      ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    )
                  ]
                ),
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Text(widget.email, style: TextStyle(fontSize: 17),),
                ),
              ),
              SizedBox(height: 20,),
              Padding(
                  padding: EdgeInsets.only(top: 10),
                child: Text("Referred By"),
              ),
              SizedBox(height: 10,),
              Container(
                width: 150,
                child: DropdownButton(
                  value: selectItem,
                  icon: Icon(Icons.arrow_downward_outlined),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(color: Colors.deepPurple),
                  onChanged: (String? newValue){
                    setState(() {
                      selectItem = newValue!;
                    });
                  },
                  items: det
                      .map<DropdownMenuItem<String>>((String value){
                    return DropdownMenuItem<String>(
                      child: Text(value),
                      value: value,
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 20,),
              SizedBox(
                height: 40,
                width: 350,
                child: ElevatedButton(
                  onPressed: sendData,
                  child: Text("Submit"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
