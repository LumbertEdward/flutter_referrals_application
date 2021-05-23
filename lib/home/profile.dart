import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:points_application/constants/constants.dart';
import 'package:points_application/home/editprofile.dart';
import 'package:points_application/model/user.dart';

class Profile extends StatefulWidget {
  final String email;
  const Profile({Key? key, required this.email}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  late List<User> details;

  bool isPresent = false;

  Future<void> getDetails() async{
    var data = {"email": widget.email};
    var response = await http.post(Uri.parse(Constants().USERDETAILS_URL), body: data);
    if(response.statusCode == 200){
      var dt = jsonDecode(response.body);
      var res = Message.fromJson(dt);
      if(res.message == "Successful"){
        details = (dt['data'] as List)
            .map((e) => User.fromJson(e))
            .toList();

        setState(() {
          isPresent = true;
        });
      }
    }
  }

  void goToEdit(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfile(email: widget.email)));
  }


  @override
  void initState() {
    getDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        centerTitle: true,
      ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 50,
                width: 350,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
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
                  padding: EdgeInsets.all(16),
                  child: isPresent ?  Text(details[0].FIRSTNAME) : null,
                ),
              ),
              SizedBox(height: 7,),
              Container(
                height: 50,
                width: 350,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
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
                  padding: EdgeInsets.all(16),
                  child: isPresent ?  Text(details[0].LASTNAME) : null,
                ),
              ),
              SizedBox(height: 7,),
              Container(
                height: 50,
                width: 350,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
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
                  padding: EdgeInsets.all(16),
                  child: isPresent ?  Text(details[0].EMAIL) : null,
                ),
              ),
              SizedBox(height: 7,),
              Container(
                height: 50,
                width: 350,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
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
                  padding: EdgeInsets.all(16),
                  child: isPresent ?  Text(details[0].PHONE) : null,
                ),
              ),
              SizedBox(height: 20,),
              SizedBox(
                height: 40,
                width: 350,
                child: ElevatedButton(
                  onPressed: goToEdit,
                  child: Text("Edit Profile"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

