import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:points_application/constants/constants.dart';
import 'package:points_application/home/profile.dart';
import 'package:points_application/home/notifications.dart';
import 'package:points_application/home/redeemedpoints.dart';
import 'package:points_application/home/transactions.dart';
import 'package:http/http.dart' as http;
import 'package:points_application/model/user.dart';

class Home extends StatefulWidget {
  final String name;
  final String email;
  const Home({Key? key, required this.name, required this.email}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  late List<Points> point;

  bool present = false;

  Future<void> getPoints() async{
    var em = {"email": widget.email};
    var response = await http.post(Uri.parse(Constants().POINTS_URL), body: em);
    if (response.statusCode == 200){
      var res = jsonDecode(response.body);
      var mes = Message.fromJson(res);
      if (mes.message == "Successful"){
        point = (res['data'] as List)
            .map((e) => Points.fromJson(e))
            .toList();

        setState(() {
          present = true;
        });
      }
    }

  }

  void showSnack(){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("This is a snackbar")));
  }

  void goToTransactions(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => Transactions(email: widget.email,)));
  }

  void goToRedeemPoints(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => RedeemedPoints(email: point[0].EMAIL, currentPoints: point[0].TOTALPOINTS, name: widget.name,)));
  }

  void goToHistory(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => Profile(email: widget.email,)));
  }

  void goToNotifications(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => Notifications(email: widget.email,)));
  }


  @override
  void initState() {
    getPoints();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hello ${widget.name}"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: showSnack,
              tooltip: "Notification",
              icon: Icon(Icons.add_alert)
          )
        ],
      ),
      drawer: Drawer(
        child: ListTile(
          title: Text("Home"),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 150,
                    width: 180,
                    child: Card(
                      color: Colors.white,
                      elevation: 4,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(present ? point[0].TOTALPOINTS : "0", style: TextStyle(color: Colors.black, fontSize: 24),),
                            SizedBox(height: 5,),
                            Text("Total Points", style: TextStyle(color: Colors.deepPurple),)
                          ],
                        ),
                      )
                    ),
                  ),
                  Container(
                    height: 150,
                    width: 180,
                    child: Card(
                        color: Colors.white,
                        elevation: 4,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(present ? (int.parse(point[0].TOTALPOINTS) * 500).toString() : "Ksh 0", style: TextStyle(color: Colors.black, fontSize: 24),),
                              SizedBox(height: 5,),
                              Text("Total Amount", style: TextStyle(color: Colors.deepPurple),)
                            ],
                          ),
                        )
                    ),
                  )
                ],
              ),
              SizedBox(height: 10,),
              Divider(height: 5, thickness: 2,),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: goToTransactions,
                    child: Container(
                      height: 150,
                      width: 180,
                      child: Card(
                          color: Colors.blue,
                          elevation: 4,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.account_balance_wallet, color: Colors.white, size: 34,
                                ),
                                SizedBox(height: 5,),
                                Text("View Transactions", style: TextStyle(color: Colors.white),)
                              ],
                            ),
                          )
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: goToRedeemPoints,
                    child: Container(
                      height: 150,
                      width: 180,
                      child: Card(
                          color: Colors.red,
                          elevation: 4,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.wallet_giftcard_rounded, color: Colors.white, size: 34,
                                ),
                                SizedBox(height: 5,),
                                Text("Redeem Points", style: TextStyle(color: Colors.white),)
                              ],
                            ),
                          )
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: goToHistory,
                    child: Container(
                      height: 150,
                      width: 180,
                      child: Card(
                          color: Colors.green,
                          elevation: 4,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.person, color: Colors.white, size: 34,
                                ),
                                SizedBox(height: 5,),
                                Text("Profile", style: TextStyle(color: Colors.white),)
                              ],
                            ),
                          )
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: goToNotifications,
                    child: Container(
                      height: 150,
                      width: 180,
                      child: Card(
                          color: Colors.yellow,
                          elevation: 4,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.notifications_active, color: Colors.white, size: 34,
                                ),
                                SizedBox(height: 5,),
                                Text("Notifications", style: TextStyle(color: Colors.white),)
                              ],
                            ),
                          )
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
