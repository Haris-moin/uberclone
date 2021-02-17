import 'package:cabservice/screens/paymentgateway.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../request/googlerequests.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  final String email;

  const MyHomePage({Key key, this.email}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: custmap(
      email: widget.email,
    ));
  }
}

class custmap extends StatefulWidget {
  final String email;

  const custmap({Key key, this.email}) : super(key: key);

  @override
  _custmapState createState() => _custmapState();
}

class _custmapState extends State<custmap> {
  TextEditingController locationController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  static LatLng _initialPosition;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  LatLng _lastPosition = _initialPosition;
  GoogleMapsServices _googleMapsServices = GoogleMapsServices();
  GoogleMapController _mapController;
  String cost;
  String dis;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  @override
  Widget build(BuildContext context) {
    return _initialPosition == null
        ? Container(
            alignment: Alignment.center,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Stack(
            children: <Widget>[
              GoogleMap(
                initialCameraPosition:
                    CameraPosition(target: _initialPosition, zoom: 15),
                onMapCreated: onCreated,
                myLocationEnabled: true,
                mapType: MapType.normal,
                compassEnabled: true,
                markers: _markers,
                onCameraMove: _onCameraMove,
                polylines: _polylines,
              ),
              Positioned(
                  top: 50.0,
                  right: 15.0,
                  left: 15.0,
                  child: Container(
                    height: 50.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3.0),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey,
                            offset: Offset(1.0, 5.0),
                            blurRadius: 10,
                            spreadRadius: 3)
                      ],
                    ),
                    child: TextField(
                      cursorColor: Colors.black,
                      controller: locationController,
                      decoration: InputDecoration(
                        icon: Container(
                          margin: EdgeInsets.only(left: 20, top: 5, bottom: 16),
                          width: 10,
                          height: 10,
                          child: Icon(
                            Icons.location_on,
                            color: Colors.black,
                          ),
                        ),
                        hintText: "pick up",
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.only(left: 15.0, top: 16.0, bottom: 15),
                      ),
                    ),
                  )),
              Positioned(
                  top: 105.0,
                  right: 15.0,
                  left: 15.0,
                  child: Container(
                    height: 50.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3.0),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey,
                            offset: Offset(1.0, 5.0),
                            blurRadius: 10,
                            spreadRadius: 3)
                      ],
                    ),
                    child: TextField(
                      cursorColor: Colors.black,
                      controller: destinationController,
                      textInputAction: TextInputAction.go,
                      onSubmitted: (value) {
                        sendRequest(value);
                      },
                      decoration: InputDecoration(
                        icon: Container(
                          margin: EdgeInsets.only(left: 20, top: 5, bottom: 16),
                          width: 10,
                          height: 10,
                          child: Icon(
                            Icons.local_taxi,
                            color: Colors.black,
                          ),
                        ),
                        hintText: "destination",
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.only(left: 15.0, top: 16.0, bottom: 15),
                      ),
                    ),
                  )),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: RaisedButton(
                    child: Text("Confirm Ride"),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: new Align(
                              alignment: Alignment.center,
                              child: Text("Estimated Price"),
                            ),
                            actions: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text(
                                    "Distance:",
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.yellow.shade700,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 20.0,
                                  ),
                                  Text(
                                    "$dis",
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.black,
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    "Cost:",
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.yellow.shade700,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 20.0,
                                  ),
                                  Text(
                                    "$cost",
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.black,
                                    ),
                                  )
                                ],
                              ),
                              FlatButton(
                                child: new Text("Confirm"),
                                onPressed: () async {
                                  temporary();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  )),
            ],
          );
  }

  bool visible = false;

  Future temporary() async {
    // Showing CircularProgressIndicator using State.
    setState(() {
      visible = true;
    });

    // Getting value from Controller
    String email = widget.email;
    String location = locationController.text;
    String destination = destinationController.text;
    // API URL
    var url = 'https://cabservice11.000webhostapp.com/temporary.php';

    // Store all data with Param Name.
    var data = {
      'User_Email': email,
      'Location': location,
      'Destination': destination,
      'Driveremail': ''
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

  //User location
  void _getUserLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    List<Placemark> placemark = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
      locationController.text = placemark[0].name;
    });
  }

  //  Distance
  Future<String> distance(double initiallat, double initiallong, double lastlat,
      double lastlong) async {
    double distanceInKm = await Geolocator()
        .distanceBetween(initiallat, initiallong, lastlat, lastlong);
    distanceInKm = (distanceInKm / 1000);
    print(distanceInKm.toStringAsFixed(2));
    return distanceInKm.toStringAsFixed(2);
  }

  //  Cost
  Future<String> expense(double initiallat, double initiallong, double lastlat,
      double lastlong) async {
    double distanceInKm = await Geolocator()
        .distanceBetween(initiallat, initiallong, lastlat, lastlong);
    distanceInKm = (distanceInKm / 1000) * 32;
    print(distanceInKm.toStringAsFixed(2));
    return distanceInKm.toStringAsFixed(2);
  }

  //Create Route
  void createRoute(String encodedPoly) {
    var check;
    if (check != _lastPosition.toString()) {
      _polylines.clear();
      _polylines.add(Polyline(
          polylineId: PolylineId(_lastPosition.toString()),
          width: 5,
          visible: true,
          points: convertToLatlng(_decodePoly(encodedPoly)),
          color: Colors.blue));
      check = _lastPosition.toString();
    } else {
      _polylines.add(Polyline(
          polylineId: PolylineId(_lastPosition.toString()),
          width: 5,
          visible: true,
          points: convertToLatlng(_decodePoly(encodedPoly)),
          color: Colors.blue));
      check = _lastPosition.toString();
    }
  }

  //Add Marker
  void _addMarker(LatLng location, String address) {
    setState(() {
      var check;
      if (check != _lastPosition.toString()) {
        _markers.clear();
        _markers.add(Marker(
            markerId: MarkerId(_lastPosition.toString()),
            position: location,
            infoWindow: InfoWindow(title: address, snippet: "go here"),
            icon: BitmapDescriptor.defaultMarker));
      } else {
        _markers.add(Marker(
            markerId: MarkerId(_lastPosition.toString()),
            position: location,
            infoWindow: InfoWindow(title: address, snippet: "go here"),
            icon: BitmapDescriptor.defaultMarker));
      }
    });
  }

  //Converting Lat lon
  List<LatLng> convertToLatlng(List points) {
    List<LatLng> result = <LatLng>[];
    for (int i = 0; i < points.length; i++) {
      if (i % 2 != 0) {
        result.add(LatLng(points[i - 1], points[i]));
      }
    }
    return result;
  }

  //Decoding latlong
  List _decodePoly(String poly) {
    var list = poly.codeUnits;
    var llist = new List();
    int index = 0;
    int len = poly.length;
    int c = 0;
    do {
      var shift = 0;
      int result = 0;
      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);
      if (result & 1 == 1) {
        result = ~result;
      }
      var ressult1 = (result >> 1) * 0.00001;
      llist.add(ressult1);
    } while (index < len);
    for (var i = 2; i < llist.length; i++) {
      llist[i] += llist[i - 2];
    }
    return llist;
  }

  //Send Request
  void sendRequest(String intendedLocation) async {
    List<Placemark> placemark =
        await Geolocator().placemarkFromAddress(intendedLocation);
    double latitude = placemark[0].position.latitude;
    double longitude = placemark[0].position.longitude;
    LatLng destination = LatLng(latitude, longitude);
    _addMarker(destination, intendedLocation);
    String route = await _googleMapsServices.getRouteCoordinates(
        _initialPosition, destination);
    createRoute(route);
    dis = await distance(_initialPosition.latitude.toDouble(),
        _initialPosition.longitude.toDouble(), latitude, longitude);
    cost = await expense(_initialPosition.latitude.toDouble(),
        _initialPosition.longitude.toDouble(), latitude, longitude);
    longitude = null;
    latitude = null;
  }

  //On Camera Move
  void _onCameraMove(CameraPosition position) {
    setState(() {
      _lastPosition = position.target;
    });
  }

//on Created
  void onCreated(GoogleMapController controller) {
    setState(() {
      _mapController = controller;
    });
  }
}
