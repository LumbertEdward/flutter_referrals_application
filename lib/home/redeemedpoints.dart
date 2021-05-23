import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:points_application/constants/constants.dart';
import 'package:points_application/home/home.dart';
import 'package:points_application/model/user.dart';

class RedeemedPoints extends StatefulWidget {
  final String email;
  final String currentPoints;
  final String name;
  const RedeemedPoints({Key? key, required this.email, required this.currentPoints, required this.name}) : super(key: key);

  @override
  _RedeemedPointsState createState() => _RedeemedPointsState();
}

class _RedeemedPointsState extends State<RedeemedPoints> {

  late TextEditingController pointsController;

  late List<Points> points;

  Future<void> sendPoints() async{
    int cur = int.parse(widget.currentPoints);
    int pres = int.parse(pointsController.text);

    if (pres <= cur){
      int dif = cur - pres;

      var pnts = {"email": widget.email, "points": dif.toString(), "pointsRedeemed": pres.toString()};
      var response = await http.post(Uri.parse(Constants().REDEEMPOINTS_URL), body: pnts);
      if (response.statusCode == 200){
        var res = jsonDecode(response.body);
        var mes = Message.fromJson(res);
        if(mes.message == "Successful"){
          points = (res['data'] as List)
          .map((e) => Points.fromJson(e))
          .toList();

          sendNotification();

          Navigator.push(context, MaterialPageRoute(builder: (context) => Home(name: widget.name, email: widget.email)));
        }
      }


    }

  }

  Future<void> sendNotification() async{
    int cur = int.parse(widget.currentPoints);
    int pres = int.parse(pointsController.text);
    int dif = cur - pres;
    DateTime date = DateTime.now();
    DateTime t = DateTime(date.year, date.month, date.day);
    String nt = "You have redeemed ${(dif).toString()} points";
    var dt = {"email": widget.email, "notification": nt, "date": t.toString()};
    var response = await http.post(Uri.parse(Constants().SENDNOTIFICATIONS_URL), body: dt);
    if (response.statusCode == 200){
      var dat = jsonDecode(response.body);
      var res = Message.fromJson(dat);
      if(res.message == "Successful"){

      }

    }
  }


  @override
  void initState() {
    pointsController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Redeem Points"),
        centerTitle: true,
      ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.all(50),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepPurple,
                        offset: Offset(0.0, 1.0),
                        blurRadius: 4.0
                      )
                    ]
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: TextField(
                      controller: pointsController,
                      decoration: InputDecoration(
                          hintText: "Points to Redeem",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 5,),
                Container(
                  width: 300,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5.0),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.deepPurple,
                            offset: Offset(0.0, 1.0),
                            blurRadius: 4.0
                        )
                      ]
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text("${widget.currentPoints} Points", style: TextStyle(color: Colors.black),),
                  ),
                ),
                SizedBox(height: 10,),
                SizedBox(height: 40, width: 300,
                  child: ElevatedButton(
                    onPressed: sendPoints,
                    child: Text("Redeem"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
