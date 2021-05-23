import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:points_application/admin/sendMoney.dart';
import 'package:points_application/constants/constants.dart';
import 'package:points_application/model/user.dart';

class RedeemedUsers extends StatefulWidget {
  final String email;
  const RedeemedUsers({Key? key, required this.email}) : super(key: key);

  @override
  _RedeemedUsersState createState() => _RedeemedUsersState();
}

class _RedeemedUsersState extends State<RedeemedUsers> {

  late List<RedeemedUsersData> users;

  bool isPresent = false;
  
  Future<void> getRedeemedUsers() async{
    var email = {"email": widget.email};
    var response = await http.post(Uri.parse(Constants().REDEEMEDUSER_URL), body: email);
    if(response.statusCode == 200){
      var res = jsonDecode(response.body);
      var data = Message.fromJson(res);
      if(data.message == "Successful"){
        users = (res['data'] as List)
            .map((e) => RedeemedUsersData.fromJson(e))
            .toList();

        Fluttertoast.showToast(
            msg: users.length.toString()
        );
        setState(() {
          isPresent = true;
        });
      }
    }
  }


  @override
  void initState() {
    getRedeemedUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Redeemed Users"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: isPresent ? users.length : null,
          itemBuilder: (context, index){
            return GestureDetector(
              onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) => SendMoney(lst: users[index], email: widget.email,)));},
              child: ListTile(
                title: isPresent ?  Text(users[index].EMAIL) : null,
                subtitle: isPresent ? Text(users[index].POINTS): null,
              ),
            );
          }
      ),
    );
  }
}
