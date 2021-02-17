import 'package:cabservice/main.dart';
import 'package:cabservice/screens/displaydriver.dart';
import 'package:cabservice/screens/driverhistory.dart';
import 'package:cabservice/screens/drivermap.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Driverhome extends StatefulWidget {
  final String email;

  const Driverhome({Key key, this.email}) : super(key: key);

  @override
  _DriverhomeState createState() => _DriverhomeState();
}

class _DriverhomeState extends State<Driverhome> {
  int _currentIndex = 0;

  Widget PageCall(int currentIndex) {
    switch (currentIndex) {
      case 0:
        return Divhome();
      case 1:
        return DriverListView(
          dremail: widget.email,
        );
      case 2:
        return DriverJsonListView(
          email: widget.email,
        );
      case 3:
        return DisplayRequest(
          email: widget.email,
        );
        break;
      default:
        return Divhome();
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'karachi Cab',
          style: TextStyle(color: Colors.black),
        ),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            if (_currentIndex == 3 ||
                _currentIndex == 2 ||
                _currentIndex == 1) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Driverhome(
                            email: widget.email,
                          )));
            } else {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => driverlogin()));
            }
          },
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
              backgroundColor: Colors.yellow),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.list,
              color: Colors.black,
            ),
            title: Text(
              'Details',
              style: TextStyle(color: Colors.black),
            ),
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
                Icons.directions_car,
                color: Colors.black,
              ),
              title: Text('Requests', style: TextStyle(color: Colors.black)),
              backgroundColor: Colors.yellow)
        ],
        onTap: (value) {
          _currentIndex = value;
          setState(() {});
        },
      ),
    );
  }
}

class Divhome extends StatefulWidget {
  @override
  _DivhomeState createState() => _DivhomeState();
}

class _DivhomeState extends State<Divhome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: map(),
    );
  }
}

class searchresult {
  final String Email;

  final String Location;

  final String Destination;

  searchresult({this.Email, this.Location, this.Destination});

  factory searchresult.fromJson(Map<String, dynamic> jsonData) {
    return searchresult(
        Email: jsonData['User_Email'],
        Location: jsonData['Location'],
        Destination: jsonData['Destination']);
  }
}

class Request extends StatelessWidget {
  final List<searchresult> result;
  final String email;

  Request({Key key, this.email, this.result}) : super(key: key);

  Widget build(context) {
    return ListView.builder(
      itemCount: result.length,
      itemBuilder: (context, int currentIndex) {
        return createViewItem(result[currentIndex], context);
      },
    );
  }

  Widget createViewItem(searchresult s, BuildContext context) {
    return new ListTile(
        title: new Card(
          elevation: 5.0,
          child: new Container(
            decoration: BoxDecoration(border: Border.all(color: Colors.orange)),
            padding: EdgeInsets.all(20.0),
            margin: EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                ),
                Row(children: <Widget>[
                  Padding(
                      child: Text(
                        'Location',
                        style: new TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.right,
                      ),
                      padding: EdgeInsets.all(1.0)),
                  Text(" | "),
                  Padding(
                      child: Text(
                        'Destination',
                        style: new TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.right,
                      ),
                      padding: EdgeInsets.all(1.0)),
                ]),
                Row(children: <Widget>[
                  Padding(
                      child: Text(
                        s.Location,
                        style: new TextStyle(fontStyle: FontStyle.italic),
                        textAlign: TextAlign.right,
                      ),
                      padding: EdgeInsets.all(1.0)),
                  Text(" | "),
                  Padding(
                      child: Text(
                        s.Destination,
                        style: new TextStyle(fontStyle: FontStyle.italic),
                        textAlign: TextAlign.right,
                      ),
                      padding: EdgeInsets.all(1.0)),
                ]),
              ],
            ),
          ),
        ),
        onTap: () {
          //We start by creating a Page Route.
          //A MaterialPageRoute is a modal route that replaces the entire
          //screen with a platform-adaptive transition.
          var route = new MaterialPageRoute(
            builder: (BuildContext context) =>
                new SecondScreen(value: s, dremail: email),
          );
          //A Navigator is a widget that manages a set of child widgets with
          //stack discipline.It allows us navigate pages.
          Navigator.of(context).push(route);
        });
  }
}

Future<List<searchresult>> downloadJSON() async {
  final jsonEndpoint =
      "https://cabservice11.000webhostapp.com/temporarydisplay2.php";

  final response = await get(jsonEndpoint);

  if (response.statusCode == 200) {
    List rescrafts = json.decode(response.body);
    return rescrafts
        .map((searchcraft) => new searchresult.fromJson(searchcraft))
        .toList();
  } else
    throw Exception('We were not able to successfully download the json data.');
}

class SecondScreen extends StatefulWidget {
  final searchresult value;
  final String dremail;

  SecondScreen({Key key, this.value, this.dremail}) : super(key: key);

  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: bookingListView(
        email: widget.value.Email,
        dremail: widget.dremail,
        userloc: widget.value.Location,
        userdes: widget.value.Destination,
      ),
    );
  }
}

class DisplayRequest extends StatelessWidget {
  TextEditingController editingController = TextEditingController();
  final String email;

  DisplayRequest({Key key, this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: new Scaffold(
      body: new Center(
        //FutureBuilder is a widget that builds itself based on the latest snapshot
        // of interaction with a Future.
        child: new FutureBuilder<List<searchresult>>(
          future: downloadJSON(),
          //we pass a BuildContext and an AsyncSnapshot object which is an
          //Immutable representation of the most recent interaction with
          //an asynchronous computation.
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<searchresult> spacecrafts = snapshot.data;
              return new Request(email: email, result: spacecrafts);
            } else if (snapshot.hasError) {
              return Text('No request available');
            }
            //return  a circular progress indicator.
            return new CircularProgressIndicator();
          },
        ),
      ),
    ));
  }
}

class bookingListView extends StatefulWidget {
  final String email;
  final String dremail;
  final String userloc;
  final String userdes;

  const bookingListView(
      {Key key, this.email, this.dremail, this.userloc, this.userdes})
      : super(key: key);

  bookingListViewWidget createState() => bookingListViewWidget();
}

class bookingListViewWidget extends State<bookingListView> {
  Future<List<userBookingdata>> fetchData() async {
    String uri =
        "https://cabservice11.000webhostapp.com/Get.php?email=${widget.email}";
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      final dataitems = json.decode(response.body).cast<Map<String, dynamic>>();
      List<userBookingdata> listofdata = dataitems.map<userBookingdata>((json) {
        return userBookingdata.fromJson(json);
      }).toList();
      return listofdata;
    } else {
      print('error');
      throw Exception('Failed to load data.');
    }
  }

  bool visible = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Container(
            child: FutureBuilder<List<userBookingdata>>(
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
                                RaisedButton(
                                    onPressed: () {
                                      bothemail(widget.email, widget.dremail);
                                      updateDriver(
                                          widget.email, widget.dremail);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => map(
                                                    userloc: widget.userloc,
                                                    userdes: widget.userdes,
                                                    useremail: widget.email,
                                                    dremail: widget.dremail,
                                                  )));
                                    },
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(10.0),
                                        side: BorderSide(color: Colors.yellow)),
                                    color: Colors.yellow,
                                    child: Text(
                                      "Accept",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18.0,
                                      ),
                                    )),
                              ],
                            )
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

  Future bothemail(String email, String dremail) async {
    // Showing CircularProgressIndicator using State.
    setState(() {
      visible = true;
    });

    // API URL
    var url = 'https://cabservice11.000webhostapp.com/confirmdriver.php';
    print(dremail);
    // Store all data with Param Name.
    var data = {'driveremail': dremail, 'customeremail': email};

    // Starting Web Call with data.
    var response = await http.post(url, body: json.encode(data));

    // Getting Server response into variable.
    var message = jsonDecode(response.body);

    // If Web call Success than Hide the CircularProgressIndicator.
    if (response.statusCode == 200) {
      setState(() {
        visible = false;
      });
    }

    // Showing Alert Dialog with Response JSON.
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(message),
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

  Future updateDriver(String email, String dremail) async {
    // Showing CircularProgressIndicator using State.
    setState(() {
      visible = true;
    });

    // API URL
    var url =
        'https://cabservice11.000webhostapp.com/updatedriver.php?email=${email}';

    // Store all data with Param Name.
    var data = {
      'Driveremail': dremail,
    };

    // Starting Web Call with data.
    var response = await http.post(url, body: json.encode(data));

    // Getting Server response into variable.
    var message = jsonDecode(response.body);

    // If Web call Success than Hide the CircularProgressIndicator.
    if (response.statusCode == 200) {
      setState(() {
        visible = false;
      });
    }

    // Showing Alert Dialog with Response JSON.
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(message),
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
}

class userBookingdata {
  String name;
  String phone;

  userBookingdata({this.name, this.phone});

  factory userBookingdata.fromJson(Map<String, dynamic> json) {
    return userBookingdata(name: json['Name'], phone: json['Phone']);
  }
}
