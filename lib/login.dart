import 'dart:convert';

import 'package:database2/profilelogin.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController user = TextEditingController();
  TextEditingController pwd = TextEditingController();

  int check = 0;

  Future<void> checkLogin() async {
    String urlstr = 'http://172.21.245.64/addressbook/checklogin.php';

    final url = Uri.parse(urlstr);
    final response = await http.post(
      url,
      body: {
        'username': user.text,
        'password': pwd.text,
      },
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      //Successful
      final json = response.body;
      final data = jsonDecode(json);
      debugPrint('Data: $data');
      if (data == 'Completed') {
        setState(() {
          check = 1; //Login Completed
        });
        print('Result: $data');
        // ignore: use_build_context_synchronously
        // Navigator.pushNamed(context, '/home', arguments: {
        //   'user': user.text,
        // });
      } else {
        Fluttertoast.showToast(
            msg: "Please check username or password",
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 100,
              ),
              const Text('Login Form',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  )),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                // The validator receives the text that the user has entered.
                controller: user,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  hintText: 'Please input username',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter username';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                // The validator receives the text that the user has entered.
                controller: pwd,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  hintText: 'Please input password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter password';
                  }
                  return null;
                },
              ),
              ButtonBar(
                alignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Validate returns true if the form is valid, or false otherwise.
                      if (_formKey.currentState!.validate()) {
                        checkLogin();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Home(
                              loginUser: user.text,
                            ),
                          ),
                        );
                      }
                    },
                    child: const Text('Login'),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Cancel'),
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
