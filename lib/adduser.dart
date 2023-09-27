import 'dart:convert';

import 'package:database2/profilelogin.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
// import 'package:toast/toast.dart';

class AddUser extends StatefulWidget {
  const AddUser({super.key});

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  TextEditingController user = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController fullname = TextEditingController();

  Future addUser() async {
    // var url = "https://pattyteacher.000webhostapp.com/insert_user.php";
    var urlstr = "http://172.21.231.239/addressbook/insert.php";
    var data = {};
    var url = Uri.parse(urlstr);
    data['username'] = user.text;
    data['password'] = password.text;
    data['fullname'] = fullname.text;

    print(user.text);
    print(password.text);
    print(fullname.text);

    var response = await http.post(
      url,
      body: data,
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print(data);
      if (data == "Error") {
        Fluttertoast.showToast(
            msg: "Username already exist",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 5,
            backgroundColor: Theme.of(context).primaryColor,
            textColor: Colors.white,
            fontSize: 16.0);
        // Toast.show(
        //   "Username already exist",
        //   context,
        //   duration: Toast.LENGTH_SHORT,
        //   gravity: Toast.BOTTOM,
        // );
      } else if (data == "Success") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Home(
              loginUser: "",
            ),
          ),
        );
      } else {
        Fluttertoast.showToast(
            msg: "Insert Error",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 5,
            backgroundColor: Theme.of(context).primaryColor,
            textColor: Colors.white,
            fontSize: 16.0);
        // Toast.show(
        //   "Insert Error",
        //   context,
        //   duration: Toast.LENGTH_SHORT,
        //   gravity: Toast.BOTTOM,
        // );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add New User')),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                controller: fullname,
                decoration: InputDecoration(
                  hintText: "Fullname",
                  labelText: "Fullname",
                  hintStyle: Theme.of(context).textTheme.bodyMedium,
                  labelStyle: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              TextField(
                controller: user,
                decoration: InputDecoration(
                  hintText: "Username",
                  labelText: "Username",
                  hintStyle: Theme.of(context).textTheme.bodyMedium,
                  labelStyle: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              TextField(
                controller: password,
                obscureText: true,
                decoration: new InputDecoration(
                  hintText: "Password",
                  labelText: "Password",
                  hintStyle: Theme.of(context).textTheme.bodyMedium,
                  labelStyle: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              //SizedBox(height: 20),
              ElevatedButton(
                child: new Text("ADD DATA"),
                onPressed: () {
                  addUser();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
