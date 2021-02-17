import 'dart:convert';
import 'package:cabservice/main.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'DriverProfile.dart';

class UserProfileScreen extends StatelessWidget {
// User Logout Function.

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(body: DriverJsonListView());
  }
}

class userdata {
  String name;
  String phone;
  String address;
  String carno;

  userdata({this.name, this.phone, this.address, this.carno});

  factory userdata.fromJson(Map<String, dynamic> json) {
    return userdata(
        name: json['Name'],
        phone: json['Phone'],
        address: json['Address'],
        carno: json['CarNo']);
  }
}

class DriverJsonListView extends StatefulWidget {
  final String email;

  const DriverJsonListView({Key key, this.email}) : super(key: key);

  JsonListViewWidget createState() => JsonListViewWidget();
}

class JsonListViewWidget extends State<DriverJsonListView> {
  Future<List<userdata>> fetchData() async {
    String uri =
        "https://cabservice11.000webhostapp.com/GetDriver.php?email=${widget.email}";
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      final dataitems = json.decode(response.body).cast<Map<String, dynamic>>();
      List<userdata> listofdata = dataitems.map<userdata>((json) {
        return userdata.fromJson(json);
      }).toList();
      return listofdata;
    } else {
      print('error');
      throw Exception('Failed to load data.');
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Container(
            child: FutureBuilder<List<userdata>>(
      future: fetchData(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());
        return ListView(
          padding:
              EdgeInsets.only(top: 0.0, right: 0.0, left: 0.0, bottom: 20.0),
          children: snapshot.data
              .map(
                (data) => Container(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 50.0,
                      ),
                      Text(
                        "Profile",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 25.0,
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: 300,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.person,
                                  color: Colors.black,
                                ),
                                Text(
                                  "  " + data.name,
                                  style: TextStyle(
                                      color: Colors.black26,
                                      fontSize: 20.0,
                                      fontStyle: FontStyle.italic),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.phone,
                                  color: Colors.black,
                                ),
                                Text(
                                  "  " + data.phone,
                                  style: TextStyle(
                                      color: Colors.black26,
                                      fontSize: 20.0,
                                      fontStyle: FontStyle.italic),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.my_location,
                                  color: Colors.black,
                                ),
                                Text(
                                  "  " + data.address,
                                  style: TextStyle(
                                      color: Colors.black26,
                                      fontSize: 20.0,
                                      fontStyle: FontStyle.italic),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.directions_car,
                                  color: Colors.black,
                                ),
                                Text(
                                  "  " + data.carno,
                                  style: TextStyle(
                                      color: Colors.black26,
                                      fontSize: 20.0,
                                      fontStyle: FontStyle.italic),
                                ),
                              ],
                            ),
                            RaisedButton(
                               child: Text("logout"),
                                onPressed:() {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DDetails()));
                            })
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
              .toList(),
        );
      },
    )));
  }
}
class Driverdetails extends StatefulWidget {
  _DriverdetailsState createState()=> _DriverdetailsState();
}

class _DriverdetailsState extends State<Driverdetails> {
  String name = "";
  @override
  void initState() {
    super.initState();
    _checkuser();
    _logout();
    //_checkLogin();
  }

  Future _checkLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool("isLoggedIn") == false) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    }
  }

  Future _logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("isLoggedIn", false);

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => driverlogin()));
  }

  Future _checkuser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString("emailController") != null) {
      setState(() {
        name = prefs.getString("emailController");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            Form(
              child: Column(
                children: <Widget>[
                  Text('are you sure'),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                      width: 280,
                      padding: EdgeInsets.all(10.0),
                      child: RaisedButton(
                        onPressed: () {
                          // Validate returns true if the form is valid, or false
                          // otherwise.
                          _logout();
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                            side: BorderSide(color: Colors.yellow)),
                        color: Colors.yellow,
                        child: Center(
                          child: Text(
                            "Yes",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      )),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                      width: 280,
                      padding: EdgeInsets.all(10.0),
                      child: RaisedButton(
                        onPressed: () {
                          // Validate returns true if the form is valid, or false
                          // otherwise.
                          Driverhome();
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                            side: BorderSide(color: Colors.yellow)),
                        color: Colors.yellow,
                        child: Center(
                          child: Text(
                            "no",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}


class DDetails extends StatefulWidget {
  _DDetailsState createState()=> _DDetailsState();
}

class _DDetailsState extends State<DDetails> {
  String name = "";
  @override
  void initState() {
    super.initState();
    _checkuser();
    //_checkLogin();
  }

  Future _checkLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool("isLoggedIn") == false) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    }
  }

  Future _logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("isLoggedIn", false);

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => cuslogin()));
  }

  Future _checkuser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString("emailController") != null) {
      setState(() {
        name = prefs.getString("emailController");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding:
        EdgeInsets.only(top: 50.0, right: 20.0, left: 20.0, bottom: 20.0),
        child: Column(
          children: <Widget>[
            Form(
              child: Column(
                children: <Widget>[
                  Text('are you sure'),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                      width: 280,
                      padding: EdgeInsets.all(10.0),
                      child: RaisedButton(
                        onPressed: () {
                          // Validate returns true if the form is valid, or false
                          // otherwise.
                          _logout();
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                            side: BorderSide(color: Colors.yellow)),
                        color: Colors.yellow,
                        child: Center(
                          child: Text(
                            "Yes",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      )
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                      width: 280,
                      padding: EdgeInsets.all(10.0),
                      child: RaisedButton(
                        onPressed: () {
                          // Validate returns true if the form is valid, or false
                          // otherwise.
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Driverhome()));
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                            side: BorderSide(color: Colors.yellow)),
                        color: Colors.yellow,
                        child: Center(
                          child: Text(
                            "no",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}