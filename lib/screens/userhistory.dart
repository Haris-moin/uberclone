import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class userBookingdata {
  int ID;
  String Driveremail;
  String Location;
  String Destination;

  userBookingdata({this.ID, this.Driveremail, this.Location, this.Destination});

  factory userBookingdata.fromJson(Map<String, dynamic> json) {
    return userBookingdata(
        ID: json['ID'],
        Driveremail: json['Driveremail'],
        Location: json['Location'],
        Destination: json['Destination']);
  }
}

class USerListView extends StatefulWidget {
  final String email;

  const USerListView({Key key, this.email}) : super(key: key);

  @override
  USerListViewWidget createState() => USerListViewWidget();
}

class USerListViewWidget extends State<USerListView> {
  Future<List<userBookingdata>> fetchCustomer() async {
    String apiURL =
        "https://cabservice11.000webhostapp.com/userhistory.php?email=${widget.email}";
    var response = await http.get(apiURL);

    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();

      List<userBookingdata> CustomerList = items.map<userBookingdata>((json) {
        return userBookingdata.fromJson(json);
      }).toList();

      return CustomerList;
    } else {
      throw Exception('Failed to load data from Server.');
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<userBookingdata>>(
      future: fetchCustomer(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());
        return ListView(
          children: snapshot.data
              .map((data) => Column(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          selectedItem(context, data.Driveremail);
                        },
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                  padding: EdgeInsets.fromLTRB(25, 20, 0, 0),
                                  child: Row(
                                    children: <Widget>[
                                      Text('Location = ',
                                          style: TextStyle(
                                              fontSize: 21,
                                              color: Colors.blue)),
                                      Text('' + data.Location,
                                          style: TextStyle(fontSize: 21))
                                    ],
                                  )),
                              Padding(
                                  padding: EdgeInsets.fromLTRB(20, 0, 0, 20),
                                  child: Row(
                                    children: <Widget>[
                                      Text('Destination = ',
                                          style: TextStyle(
                                              fontSize: 21,
                                              color: Colors.blue)),
                                      Text('' + data.Destination,
                                          style: TextStyle(fontSize: 21))
                                    ],
                                  )),
                            ]),
                      ),
                      Divider(color: Colors.black),
                    ],
                  ))
              .toList(),
        );
      },
    );
  }
}
