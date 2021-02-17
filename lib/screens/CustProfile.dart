import 'package:cabservice/main.dart';
import 'package:cabservice/screens/DisplayProfile.dart';
import 'package:cabservice/screens/home.dart';
import 'package:cabservice/screens/paymentgateway.dart';
import 'package:cabservice/screens/userhistory.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class home extends StatefulWidget {
  final String email;

  const home({Key key, this.email}) : super(key: key);

  @override
  _homeState createState() => _homeState();
}

class Driveremailfetch {
  int ID;
  String Driveremail;

  Driveremailfetch({this.ID, this.Driveremail});

  factory Driveremailfetch.fromJson(Map<String, dynamic> json) {
    return Driveremailfetch(
      ID: json['ID'],
      Driveremail: json['driveremail'],
    );
  }
}

class Driverdetails {
  //int ID;
  String Name;
  int Phone;
  String CarNo;

  Driverdetails({this.Name, this.Phone, this.CarNo});

  factory Driverdetails.fromJson(Map<String, dynamic> json) {
    return Driverdetails(
      //ID: json['ID'],
      Name: json['Name'],
      Phone: json['Phone'],
      CarNo: json['CarNo'],
    );
  }
}

class _homeState extends State<home> {
  Future<List<Driveremailfetch>> getDriverData() async {
    String apiURL =
        "https://cabservice11.000webhostapp.com/Getdriveremail.php?email=${widget.email}";
    var response = await http.get(apiURL);

    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();

      List<Driveremailfetch> DriverList = items.map<Driveremailfetch>((json) {
        return Driveremailfetch.fromJson(json);
      }).toList();

      return DriverList;
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }

  Future<List<Driverdetails>> getDriverDetail(String email) async {
    String apiURL =
        "https://cabservice11.000webhostapp.com/Getdriverdetails.php?email=$email";
    var response = await http.get(apiURL);
    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();

      List<Driverdetails> Driverdetaildata = items.map<Driverdetails>((json) {
        return Driverdetails.fromJson(json);
      }).toList();

      return Driverdetaildata;
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }

  int _currentIndex = 0;

  Widget PageCall(int currentIndex) {
    switch (currentIndex) {
      case 0:
        return userhome(
          email: widget.email,
        );
      case 1:
        return USerListView(
          email: widget.email,
        );
      case 2:
        return JsonListView(
          email: widget.email,
        );
      case 3:
        return CustomerDetails();
        break;
      default:
        return userhome(
          email: widget.email,
        );
    }
  }

  selectedItem(BuildContext context, String dataHolder) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(dataHolder),
          actions: <Widget>[
            FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  getdetailsItem(BuildContext context, String datadetails) {
    print(datadetails);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FutureBuilder<List<Driverdetails>>(
          future: getDriverDetail(datadetails),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(child: CircularProgressIndicator());
            return ListView(
              padding: EdgeInsets.only(
                  top: 250.0, right: 20.0, left: 20.0, bottom: 20.0),
              children: snapshot.data
                  .map((data1) => Column(
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text('Name: ',
                                      style: TextStyle(
                                          fontSize: 21, color: Colors.blue)),
                                  Text('' + data1.Name,
                                      style: TextStyle(fontSize: 21))
                                ],
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text('Phone: ',
                                      style: TextStyle(
                                          fontSize: 21, color: Colors.blue)),
                                  Text('' + data1.Phone.toString(),
                                      style: TextStyle(fontSize: 21))
                                ],
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text('CarNo ',
                                      style: TextStyle(
                                          fontSize: 21, color: Colors.blue)),
                                  Text('' + data1.CarNo,
                                      style: TextStyle(fontSize: 21))
                                ],
                              ),
                              Align(
                                  alignment: Alignment.bottomCenter,
                                  child: RaisedButton(
                                    child: Text("Pay Online"),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => RazorPayment(Contact: data1.Phone.toString(),Email: datadetails.toString(),)));
                                    },
                                  )),
                            ],
                          ),
                        ],
                      ))
                  .toList(),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.payment, color: Colors.black),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return FutureBuilder<List<Driveremailfetch>>(
                  future: getDriverData(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return Center(child: CircularProgressIndicator());
                    return ListView(
                      padding: EdgeInsets.only(
                          top: 250.0, right: 0.0, left: 0.0, bottom: 20.0),
                      children: snapshot.data
                          .map((data) => Column(
                                children: <Widget>[
                                  RaisedButton(
                                    child: Text(
                                        'Tap to View Driver Profile',
                                        style: TextStyle(
                                            fontSize: 21,
                                            color: Colors.blue)
                                    ),
                                    onPressed: (){
                                      if (data.Driveremail == null ||
                                          data.Driveremail == "") {
                                        selectedItem(context,
                                            "Your request is on pending...");
                                      } else {
                                        Navigator.of(context).pop();
                                        String e = data.Driveremail.toString();
                                        getdetailsItem(context, e);
                                      }
                                    }
                                  ),
                                ],
                              ))
                          .toList(),
                    );
                  },
                );
              },
            );
          },
        ),
        title: Text(
          'karachi Cab',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.yellow,
      ),
      body: PageCall(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.yellow,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.black,
            ),
            title: Text('Home', style: TextStyle(color: Colors.black)),
            backgroundColor: Colors.yellow,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.list,
              color: Colors.black,
            ),
            title: Text('Details', style: TextStyle(color: Colors.black)),
            backgroundColor: Colors.yellow,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: Colors.black,
            ),
            title: Text('Profile', style: TextStyle(color: Colors.black)),
            backgroundColor: Colors.yellow,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.power_settings_new,
              color: Colors.black,
            ),
            title: Text('SignOut', style: TextStyle(color: Colors.black)),
            backgroundColor: Colors.yellow,
          )
        ],
        onTap: (value) {
          _currentIndex = value;
          setState(() {});
        },
      ),
    );
  }
}

class profile extends StatefulWidget {
  final String email;

  const profile({Key key, this.email}) : super(key: key);

  _profileState createState() => _profileState();
}

class _profileState extends State<profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: JsonListView(
      email: widget.email,
    ));
  }
}

class userhome extends StatefulWidget {
  final String email;

  const userhome({Key key, this.email}) : super(key: key);

  @override
  _userhomeState createState() => _userhomeState();
}

class _userhomeState extends State<userhome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: MyHomePage(email: widget.email));
  }
}

class CustomerDetails extends StatefulWidget {
  _CustomerDetailsState createState() => _CustomerDetailsState();
}

class _CustomerDetailsState extends State<CustomerDetails> {
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
        padding: EdgeInsets.all(20.0),
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
                          _homeState();
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
