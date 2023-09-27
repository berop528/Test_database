import 'dart:convert';

import 'package:database2/adduser.dart';
import 'package:database2/edituser.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  final String loginUser;
  const Home({Key? key, required this.loginUser}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<dynamic> users = [];
  @override
  initState() {
    getUser();
    super.initState();
  }

  Future<void> getUser() async {
    const urlStr = "http://172.21.245.64/addressbook/select.php";
    final url = Uri.parse(urlStr);
    final response = await http.get(url);

    // print(response.statusCode);
    if (response.statusCode == 200) {
      final json = response.body;
      final data = jsonDecode(json);
      setState(() {
        users = data;
        // print(users);
      });
    } else {}
  }

  Future deleteUser(username) async {
    // var url = 'https://pattyteacher.000webhostapp.com/edit.php';
    var urlstr = 'http://172.21.245.64/addressbook/delete.php';
    var url = Uri.parse(urlstr);
    var data = {};

    data['username'] = username;
    debugPrint('Delete: $username');
    var response = await http.post(
      url,
      body: data,
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      debugPrint('Print Result: $result');
      if (result == "Success") {
        debugPrint('Delete Success');
        getUser();
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => const Home(),
        //   ),
        // );
      } else {
        Fluttertoast.showToast(
            msg: "Delete Error",
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
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final Firstname = users[index]['fullname'];
          final Username = users[index]['username'];
          // ตรวจสอบว่า Username ตรงกับผู้ใช้ที่เข้าสู่ระบบหรือไม่
          if (Username == widget.loginUser) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.home,
                  color: Colors.purple,
                  size: 50,
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: const Text(
                    'บัญชีผู้ใช้',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  child: ListTile(
                    leading: GestureDetector(
                      child: CircleAvatar(
                        backgroundColor: Color.fromARGB(255, 241, 192, 250),
                        radius: 30,
                        child: Icon(Icons.edit,
                            color: Color.fromARGB(255, 215, 36, 247)),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EditUser(user: users, index: index),
                          ),
                        );
                      },
                    ),
                    title: Text(
                      Username,
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      Firstname,
                      style: TextStyle(
                          color: const Color.fromARGB(255, 61, 61, 61)),
                    ),
                    // trailing: Icon(Icons.delete),
                    // onTap: () {
                    //   deleteUser(Username);
                    // },
                  ),
                ),
              ],
            );
          } else {
            return SizedBox
                .shrink(); // ซ่อนรายการที่ไม่ใช่ของผู้ใช้ที่เข้าสู่ระบบ
          }
        },
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => const AddUser(),
      //       ),
      //     );
      //   },
      //   child: Icon(
      //     Icons.person_add_alt_1,
      //     size: 30,
      //   ),
      // ),
    );
  }
}
