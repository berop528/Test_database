import 'dart:convert';

import 'package:database2/profilelogin.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
// import 'package:toast/toast.dart';

class EditUser extends StatefulWidget {
  final List user;
  final int index;
  const EditUser({Key? key, required this.user, required this.index})
      : super(key: key);

  @override
  State<EditUser> createState() => _AddUserState();
}

class _AddUserState extends State<EditUser> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController user = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController fullname = TextEditingController();

  Future<void> EditUser2() async {
    // var url = "https://pattyteacher.000webhostapp.com/insert_user.php";
    String urlstr = "http://172.21.245.64/addressbook/edit.php";

    final url = Uri.parse(urlstr);

    print(user.text);
    print(password.text);
    print(fullname.text);

    final response = await http.post(url, body: {
      'username': user.text,
      'password': password.text,
      'fullname': fullname.text,
    });
    print(response.statusCode);
    if (response.statusCode == 200) {
      final json = response.body;
      final data = jsonDecode(json);
      print(data);
      if (data == 'Success') {
        print('Result: $data');
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Home(
              loginUser: user.text,
            ),
          ),
        );
      } else {
        Fluttertoast.showToast(
            msg: "Something went wrong",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.purple,
            textColor: Colors.white,
            fontSize: 16.0);
        print('Result: $data');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fullname.text = widget.user[widget.index]['fullname'];
    user.text = widget.user[widget.index]['username'];
    password.text = widget.user[widget.index]['password'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit user')),
      body: Form(
        key: _formKey,
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Edit Data',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  controller: user,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: "Username",
                    labelText: "Username",
                    hintStyle: Theme.of(context).textTheme.bodyMedium,
                    labelStyle: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                TextFormField(
                  controller: fullname,
                  decoration: InputDecoration(
                    hintText: "Fullname",
                    labelText: "Fullname",
                    hintStyle: Theme.of(context).textTheme.bodyMedium,
                    labelStyle: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                TextFormField(
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
                  child: new Text("Edit"),
                  onPressed: () {
                    EditUser2();
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
