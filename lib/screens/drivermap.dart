import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../request/googlerequests.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
class map extends StatefulWidget {
  final String userloc;
  final String userdes;
  final String useremail;
  final String dremail;
  const map({Key key, this.userloc, this.userdes, this.useremail, this.dremail}) : super(key: key);

  @override
  _mapState createState() => _mapState();
}

class _mapState extends State<map> {
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
              Align(
                  alignment: Alignment.bottomCenter,
                  child: RaisedButton(
                    child: Text("Check Route"),
                    onPressed: () {
                      if (widget.userloc != null) {
                        sendRequest(widget.userloc);
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: new Align(
                                alignment: Alignment.center,
                                child: Text("OOps!Select Your Ride"),
                              ),
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
                    },
                  )),
              Align(
                  alignment: Alignment.bottomRight,
                  child: RaisedButton(
                    child: Text("Reach"),
                    onPressed: () {
                      if (widget.userloc != null) {
                        sendRequest(widget.userdes);
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: new Align(
                                alignment: Alignment.center,
                                child: Text("OOps!Select Your Ride"),
                              ),
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
                    },
                  )),
              Align(
                  alignment: Alignment.bottomLeft,
                  child: RaisedButton(
                    child: Text("End Ride"),
                    onPressed: () {
                      if (widget.userloc != null) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: new Align(
                                alignment: Alignment.center,
                                child: Text("\n" +"$dis"+" km" + "\n" + "\n" +"RS $cost"),

                              ),
                              actions: <Widget>[
                                FlatButton(
                                  child: new Text("OK"),
                                  onPressed: () {
                                    history(widget.userloc,widget.userdes,widget.useremail,widget.dremail);
                                    del(widget.dremail);
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: new Align(
                                alignment: Alignment.center,
                                child: Text("OOps!Select Your Ride"),
                              ),
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
                    },
                  ))
            ],
          );
  }
  Future history(String loc,String des,String useremail,String dremail) async {
    // API URL
    var url = 'https://cabservice11.000webhostapp.com/RideHistory.php';

    // Store all data with Param Name.
    var data = {
      'Driveremail' : dremail,
      'User_Email' : useremail,
      'Location' : loc,
      'Destination' : des
    };

    // Starting Web Call with data.
    var response = await http.post(url, body: json.encode(data));

    // Getting Server response into variable.
    var message = jsonDecode(response.body);
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
  Future del(String dremail) async {
    var url = 'https://cabservice11.000webhostapp.com/DeleteTemporary.php?email=$dremail';
    var response = await http.get(url);
    var message = jsonDecode(response.body);
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
  Future<String> distance(double initiallat, double initiallong, double lastlat,double lastlong) async {
    double distanceInKm = await Geolocator()
        .distanceBetween(initiallat, initiallong, lastlat, lastlong);
    distanceInKm = (distanceInKm / 1000);
    print(distanceInKm.toStringAsFixed(2));
    return distanceInKm.toStringAsFixed(2);
  }

  //  Cost
  Future<String> expense(double initiallat, double initiallong, double lastlat,double lastlong) async {
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
