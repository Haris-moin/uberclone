import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DriverBookingdata {
  int ID;
  String Useremail;
  String Location;
  String Destination;

  DriverBookingdata({this.ID, this.Useremail, this.Location, this.Destination});

  factory DriverBookingdata.fromJson(Map<String, dynamic> json) {
    return DriverBookingdata(
        ID: json['ID'],
        Useremail: json['User_Email'],
        Location: json['Location'],
        Destination: json['Destination']);
  }
}

class DriverListView extends StatefulWidget {
  final String dremail;

  const DriverListView({Key key, this.dremail}) : super(key: key);

  @override
  DriverListViewWidget createState() => DriverListViewWidget();
}

class DriverListViewWidget extends State<DriverListView> {
  Future<List<DriverBookingdata>> fetchDriver() async {
    String apiURL =
        "https://cabservice11.000webhostapp.com/driverhistory.php?email=${widget.dremail}";
    var response = await http.get(apiURL);

    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();

      List<DriverBookingdata> DriverList = items.map<DriverBookingdata>((json) {
        return DriverBookingdata.fromJson(json);
      }).toList();

      return DriverList;
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
    return FutureBuilder<List<DriverBookingdata>>(
      future: fetchDriver(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());
        return ListView(
          children: snapshot.data
              .map((data) => Column(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          selectedItem(context, data.Useremail);
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
