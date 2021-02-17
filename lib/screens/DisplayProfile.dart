import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class UserProfileScreen extends StatelessWidget {
// User Logout Function.

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(body: JsonListView());
  }
}

class userdata {
  String name;
  String phone;
  String address;

  userdata({this.name, this.phone, this.address});

  factory userdata.fromJson(Map<String, dynamic> json) {
    return userdata(
        name: json['Name'], phone: json['Phone'], address: json['City']);
  }
}

class JsonListView extends StatefulWidget {
  final String email;

  const JsonListView({Key key, this.email}) : super(key: key);

  JsonListViewWidget createState() => JsonListViewWidget();
}

class JsonListViewWidget extends State<JsonListView> {
  Future<List<userdata>> fetchData() async {
    String uri =
        "https://cabservice11.000webhostapp.com/Get.php?email=${widget.email}";
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
