import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:points_application/admin/adminpage.dart';
import 'package:points_application/auth/login.dart';
import 'package:points_application/auth/register.dart';
import 'package:points_application/constants/constants.dart';
import 'package:points_application/home/home.dart';
import 'package:points_application/model/user.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class AdminLogin extends StatefulWidget {
  const AdminLogin({Key? key}) : super(key: key);

  @override
  _AdminLoginState createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {

  late TextEditingController usernameController;
  late TextEditingController passwordController;

  bool isSet = false;

  Future<void> checkUser() async{
    if(usernameController.text.isNotEmpty && passwordController.text.isNotEmpty){
      var send = {"email": usernameController.text, "password": passwordController.text};
      var response = await http.post(Uri.parse(Constants().ADMINLOGIN_URL), body: send);
      if(response.statusCode == 200){
        var res = jsonDecode(response.body);
        var out = Message.fromJson(res);
        if(out.message == "Successful"){

          Navigator.push(context, MaterialPageRoute(builder: (context) => AdminHome(email: usernameController.text,)));
        }
        else{
          Fluttertoast.showToast(
              msg: "Error",
              toastLength: Toast.LENGTH_LONG
          );
        }
        setState(() {
          isSet = false;
        });
      }
      else{
        Fluttertoast.showToast(
            msg: response.statusCode.toString(),
            toastLength: Toast.LENGTH_LONG
        );
      }

    }
    else{
      setState(() {
        isSet = true;
      });
    }

  }

  void getRegister(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
  }


  @override
  void initState() {
    usernameController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Login"),
        centerTitle: true,
      ),
      body: Container(

        child: Center(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                    hintText: "Enter Email",
                    border: OutlineInputBorder(),
                    errorText: isSet ? "No data": null,
                  ),
                  controller: usernameController,
                ),
                SizedBox(height: 10,),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                      hintText: "Enter Password",
                      errorText: isSet ? "No data": null,

                      border: OutlineInputBorder()
                  ),
                ),
                SizedBox(height: 10,),
                ElevatedButton(
                    onPressed: checkUser,
                    child: Center(
                      child: Text("Login"),
                    )
                ),
                SizedBox(height: 5,),
                GestureDetector(
                  onTap: getRegister,
                  child: RichText(
                    text: TextSpan(
                        text: "Not an admin?",
                        style: TextStyle(color: Colors.amber),
                        children: <TextSpan>[
                          TextSpan(text: " Login as Student", style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold))
                        ]
                    ),
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
