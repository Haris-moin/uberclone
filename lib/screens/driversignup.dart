import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cabservice/screens/database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../main.dart';

class driverSignUp extends StatefulWidget {
  @override
  driversignState createState() => driversignState();
}

class driversignState extends State<driverSignUp> {
  String _email,
      _password,
      _name,
      _phone,
      _adress,
      _gender,
      _CNIC,
      _CarName,
      _registerNo;

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final addressController = TextEditingController();
  final emailController = TextEditingController();
  final genderController = TextEditingController();
  final passwordController = TextEditingController();
  final cnicController = TextEditingController();
  final CarnameController = TextEditingController();
  final registernoController = TextEditingController();

  // Boolean variable for CircularProgressIndicator.
  bool visible = false;

  Future drireg() async {
    // Showing CircularProgressIndicator using State.
    setState(() {
      visible = true;
    });

    // Getting value from Controller
    String name = nameController.text;
    String email = emailController.text;
    String phone = phoneNumberController.text;
    String city = addressController.text;
    String gender = genderController.text;
    String password = passwordController.text;
    String cnic = cnicController.text;
    String carname = CarnameController.text;
    String registerno = registernoController.text;

    // API URL
    var url = 'https://cabservice11.000webhostapp.com/driverreg.php';

    // Store all data with Param Name.
    var data = {
      'Name': name,
      'Email': email,
      'Phone': phone,
      'Address': city,
      'Gender': gender,
      'Password': password,
      'Cnic': cnic,
      'CarNo': carname,
      'RegNo': registerno
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Karachi CAb', style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.yellow,
        ),
        body: Container(
          child: ListView(
            padding: EdgeInsets.all(30.0),
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'SignUp',
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 34.0,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  Form(
                    key: _formkey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          validator: (input) {
                            if (input.isEmpty) {
                              return 'Please Enter Your Name';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.text,
                          controller: nameController,
                          onSaved: (input) => _name = input,
                          decoration: InputDecoration(
                              hintText: 'Your Name',
                              hintStyle:
                                  TextStyle(color: Colors.grey, fontSize: 16.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              prefixIcon: Icon(Icons.account_circle)),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        TextFormField(
                          validator: (input) {
                            if (input.isEmpty) {
                              return 'Please Enter Correct Email';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.emailAddress,
                          controller: emailController,
                          onSaved: (input) => _email = input,
                          decoration: InputDecoration(
                              hintText: 'Email Address',
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 16.0,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              prefixIcon: Icon(Icons.email)),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        TextFormField(
                          validator: (input) {
                            if (input.isEmpty) {
                              return 'Please Enter Phone Number';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.phone,
                          controller: phoneNumberController,
                          onSaved: (input) => _phone = input,
                          decoration: InputDecoration(
                              hintText: 'Phone Number',
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 16.0,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              prefixIcon: Icon(Icons.phone_android)),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        TextFormField(
                          validator: (input) {
                            if (input.isEmpty) {
                              return 'Please Enter CNIC';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.number,
                          controller: cnicController,
                          onSaved: (input) => _CNIC = input,
                          decoration: InputDecoration(
                              hintText: 'CNIC',
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 16.0,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              prefixIcon: Icon(Icons.contact_mail)),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        TextFormField(
                          validator: (input) {
                            if (input.isEmpty) {
                              return 'Please Enter Car Name';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.text,
                          controller: CarnameController,
                          onSaved: (input) => _CarName = input,
                          decoration: InputDecoration(
                              hintText: 'Car Name / Model',
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 16.0,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              prefixIcon: Icon(Icons.directions_car)),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        TextFormField(
                          validator: (input) {
                            if (input.isEmpty) {
                              return 'Please Enter Registration Number';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.phone,
                          controller: registernoController,
                          onSaved: (input) => _registerNo = input,
                          decoration: InputDecoration(
                              hintText: 'Registration No.',
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 16.0,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              prefixIcon: Icon(Icons.featured_play_list)),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        TextFormField(
                          validator: (input) {
                            if (input.isEmpty) {
                              return 'Please Enter Correct Adress';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.text,
                          controller: addressController,
                          onSaved: (input) => _adress = input,
                          decoration: InputDecoration(
                              hintText: 'Address',
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 16.0,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              prefixIcon: Icon(Icons.location_on)),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        TextFormField(
                          validator: (input) {
                            if (input.isEmpty &&
                                (input != 'male' ||
                                    input != 'female' ||
                                    input != 'Male' ||
                                    input != 'Female' ||
                                    input != 'MALE' ||
                                    input != 'FEMALE')) {
                              return 'Please Enter your Gender';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.text,
                          onSaved: (input) => _gender = input,
                          controller: genderController,
                          decoration: InputDecoration(
                              hintText: 'Male/Female',
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 16.0,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              prefixIcon: Icon(Icons.person)),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        TextFormField(
                          validator: (input) {
                            if (input.isEmpty) {
                              return 'Please Enter Password';
                            }
                            return null;
                          },
                          obscureText: true,
                          keyboardType: TextInputType.visiblePassword,
                          controller: passwordController,
                          onSaved: (input) => _password = input,
                          decoration: InputDecoration(
                              hintText: 'Password',
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 16.0,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              prefixIcon: Icon(Icons.lock)),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        RaisedButton(
                          onPressed: () {
                            if (_formkey.currentState.validate()) {
                              DriverSignUp();
                              drireg();
                            }
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(10.0),
                              side: BorderSide(color: Colors.yellow)),
                          color: Colors.yellow,
                          child: Center(
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ));
  }

  Future<void> DriverSignUp() async {
    {
      final formState = _formkey.currentState;
      if (formState.validate()) {
        formState.save();

        try {
          AuthResult result = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                  email: _email, password: _password);
          FirebaseUser user = result.user;
          await DriverDatabaseService(D_id: user.uid).UpdateDriverData(
              _name, _phone, _adress, _gender, _CNIC, _CarName, _registerNo);

          Navigator.push(
              context, MaterialPageRoute(builder: (context) => driverlogin()));
        } catch (e) {
          print(e.message);
          print(_gender);
          print(_name);
          print(_phone);
          print(_email);
          print(_password);
          print(_adress);
          print(_CarName);
          print(_registerNo);
          print(_CNIC);
        }
      }
    }
  }
}
