import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:points_application/auth/login.dart';
import 'package:points_application/constants/constants.dart';
import 'package:points_application/home/home.dart';
import 'package:http/http.dart' as http;
import 'package:points_application/model/user.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController email;
  late TextEditingController password;
  late TextEditingController phone;
  late TextEditingController confirmPassword;
  bool isSame = false;

  late List<User> user;

  Future<void> registerUser() async{

    if(confirmPassword.text.toString() == password.text.toString()){
      String url = Constants().REGISTER_URL;
      var data = {"firstname": firstNameController.text, "lastname": lastNameController.text, "email": email.text, "phone": phone.text, "password": password.text};
      var response = await http.post(Uri.parse(url), body: data);
      if (response.statusCode == 200){
        var result = jsonDecode(response.body);
        var mes = Message.fromJson(result);

        if(mes.message == "Successful"){
          user = (result['data'] as List)
              .map((e) => User.fromJson(e))
              .toList();

          Navigator.push(context, MaterialPageRoute(builder: (context) => Home(name: user[0].FIRSTNAME, email: user[0].EMAIL,)));
        }
        else{
          Fluttertoast.showToast(
            toastLength: Toast.LENGTH_LONG,
            msg: mes.message,
          );
        }
      }

    }
    else{
      setState(() {
        isSame = true;
      });
    }

  }

  void goToLogin(){
    Navigator.pop(context);
  }


  @override
  void initState() {
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    email = TextEditingController();
    password = TextEditingController();
    confirmPassword = TextEditingController();
    phone = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
        centerTitle: true,
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: firstNameController,
                  decoration: InputDecoration(
                    hintText: "Enter First Name",
                    border: OutlineInputBorder()
                  ),
                ),
                SizedBox(height: 5,),
                TextField(
                  controller: lastNameController,
                  decoration: InputDecoration(
                    hintText: "Enter Last Name",
                    border: OutlineInputBorder()
                  ),
                ),
                SizedBox(height: 5,),
                TextField(
                  controller: email,
                  decoration: InputDecoration(
                    hintText: "Enter Email",
                    border: OutlineInputBorder()
                  ),
                ),
                SizedBox(height: 5,),
                TextField(
                  controller: phone,
                  decoration: InputDecoration(
                    hintText: "Enter Phone Number",
                    border: OutlineInputBorder()
                  ),
                ),
                SizedBox(height: 5,),
                TextField(
                  controller: password,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Enter Password",
                    border: OutlineInputBorder()
                  ),
                ),
                SizedBox(height: 5,),
                TextField(
                  controller: confirmPassword,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Confirm Password",
                    border: OutlineInputBorder(),
                    errorText: isSame ? "Passwords do not match" : null
                  ),
                ),
                SizedBox(height: 5,),
                SizedBox(width: 400,
                child: ElevatedButton(
                  onPressed: registerUser,
                  child: Text("Register"),
                )
                ),
                SizedBox(height: 5,),
                GestureDetector(
                  onTap: goToLogin,
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.black),
                      text: "Have an account?",
                      children: <TextSpan>[
                        TextSpan(text: " Login", style: TextStyle(color: Colors.deepPurple))
                      ]
                    )
                  )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
