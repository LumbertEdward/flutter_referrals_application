import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:points_application/admin/adminHome.dart';
import 'package:points_application/admin/notification.dart';
import 'package:points_application/admin/redeemed.dart';
import 'package:points_application/admin/userdetails.dart';
import 'package:points_application/constants/constants.dart';
import 'package:points_application/model/user.dart';

class AdminHome extends StatefulWidget {
  final String email;
  const AdminHome({Key? key, required this.email}) : super(key: key);

  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  late List<User> all;
  bool isPresent = false;

  Future<void> getUsers() async{
    var data = {"email": widget.email};
    var response = await http.post(Uri.parse(Constants().ALLUSERS_URL), body: data);
    if(response.statusCode == 200){
      var dt = jsonDecode(response.body);
      var res = Message.fromJson(dt);
      if(res.message == "Successful"){
        all = (dt['data'] as List)
            .map((e) => User.fromJson(e))
            .toList();
      }

      setState(() {
        isPresent = true;
      });
    }
  }

  final List<Widget> lst = [
    Home(email: "hello")
  ];

  int selectedIndex = 0;

  void onTabTapped(int index){
    setState(() {
      selectedIndex = index;
    });
  }

  void goToRedeemed(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => RedeemedUsers(email: widget.email)));
  }
  void goToNotifications(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => AdminNotifications(email: widget.email)));
  }



  @override
  void initState() {
    getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text("Students"),
            centerTitle: true,
            actions: [
              IconButton(
                  onPressed: goToRedeemed,
                  icon: Icon(Icons.person_pin_outlined)
              ),
              IconButton(
                  onPressed: goToNotifications,
                  icon: Icon(Icons.notifications_active)
              )
            ],
          ),
          body: Container(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: ListView.builder(
                  itemCount: isPresent ? all.length : null,
                  itemBuilder: (context, index){
                    return GestureDetector(
                      onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) => UserDetails(email: all[index].EMAIL, all: all, admin: widget.email,)));},
                      child: ListTile(
                        title: isPresent ? Text(all[index].EMAIL) : null,
                      ),
                    );
                  }
              ),
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: selectedIndex,
            onTap: onTabTapped,
            items: [
              new BottomNavigationBarItem(
                  icon: Icon(Icons.home_filled),
                  label: "Home"
              ),
              new BottomNavigationBarItem(
                  icon: Icon(Icons.person_pin_outlined),
                  label: "Referred"
              ),
              new BottomNavigationBarItem(
                  icon: Icon(Icons.notifications_active),
                  label: "Notifications"
              )
            ],
          ),
        ),
        onWillPop: () async => false
    );
  }
}
