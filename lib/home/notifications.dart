import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:points_application/constants/constants.dart';
import 'package:points_application/model/user.dart';

class Notifications extends StatefulWidget {
  final String email;
  const Notifications({Key? key, required this.email}) : super(key: key);

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {

  late List<AllNotifications> not;

  bool isPresent = false;

  Future<void> getNotifications() async{
    var email = {"email": widget.email};

    var response = await http.post(Uri.parse(Constants().READNOTIFICATIONS_URL), body: email);
    if(response.statusCode == 200){
      var res = jsonDecode(response.body);
      var data = Message.fromJson(res);
      if(data.message == "Successful"){
        not = (res['data'] as List)
            .map((e) => AllNotifications.fromJson(e))
            .toList();

        setState(() {
          isPresent = true;
        });
      }
    }
  }


  @override
  void initState() {
    getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: isPresent ? not.length : 0,
          itemBuilder: (context, index){
            return ListTile(
              title: isPresent ? Text(not[index].NOTIFICATIONS) : null,
            );
          }
      ),
    );
  }
}
