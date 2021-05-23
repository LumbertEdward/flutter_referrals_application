import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:points_application/constants/constants.dart';
import 'package:http/http.dart' as http;
import 'package:points_application/home/profile.dart';
import 'package:points_application/model/user.dart';

class EditProfile extends StatefulWidget {
  final String email;
  const EditProfile({Key? key, required this.email}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

  late TextEditingController first;
  late TextEditingController last;
  late TextEditingController phone;

  late List<User> newDetails;

  Future<void> updateUser() async{
    var data = {"email": widget.email, "firstname": first.text, "lastname": last.text, "phone": phone.text};
    var response = await http.post(Uri.parse(Constants().UPDATEUSER_URL), body: data);
    if(response.statusCode == 200){
      var dt = jsonDecode(response.body);
      var res = Message.fromJson(dt);
      if(res.message == "Successful"){
        newDetails = (dt['data'] as List)
            .map((e) => User.fromJson(e))
            .toList();

        Navigator.push(context, MaterialPageRoute(builder: (context) => Profile(email: widget.email)));
      }
    }
  }


  @override
  void dispose() {
    super.dispose();
    first.clear();
    last.clear();
    phone.clear();
  }

  @override
  void initState() {
    first = TextEditingController();
    last = TextEditingController();
    phone = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
        centerTitle: true,
      ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.all(25),
          child: Column(
            children: [
              Container(
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
                  padding: EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 5),
                  child: TextField(
                    controller: first,
                    decoration: InputDecoration(
                        hintText: "First Name",
                        border: InputBorder.none,
                    ),
                  ),
                )
              ),
              SizedBox(height: 10,),
              Container(
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
                    padding: EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 5),
                    child: TextField(
                      controller: last,
                      decoration: InputDecoration(
                        hintText: "Last Name",
                        border: InputBorder.none,
                      ),
                    ),
                  )
              ),
              SizedBox(height: 10,),
              Container(
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
                    padding: EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 5),
                    child: TextField(
                      controller: phone,
                      decoration: InputDecoration(
                        hintText: "Phone",
                        border: InputBorder.none,
                      ),
                    ),
                  )
              ),
              SizedBox(height: 15,),
              SizedBox(
                height: 40,
                width: 350,
                child: ElevatedButton(
                  onPressed: updateUser,
                  child: Text("Save"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
