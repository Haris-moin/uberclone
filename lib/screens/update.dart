import 'package:flutter/material.dart';

import 'CustProfile.dart';
import 'database.dart';

class update extends StatefulWidget {
  final String uid;

  const update({Key key, this.uid}) : super(key: key);

  @override
  _updateState createState() => _updateState();
}

class _updateState extends State<update> {
  String _name, _phone, _address, _gender, _email, _password;

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          return 'Please Enter Phone Number';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.phone,
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
                          return 'Please Enter Correct Adress';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      onSaved: (input) => _address = input,
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
                        if (input.isEmpty) {
                          return 'Please Enter your Gender';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      onSaved: (input) => _gender = input,
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
                    RaisedButton(
                      onPressed: () {
                        UserUpdate();
                        if (_formkey.currentState.validate()) {
                          // If the form is valid, display a Snackbar.
                          Scaffold.of(context).showSnackBar(
                              SnackBar(content: Text('Processing Data')));
                        }
                      },
                      /*{
                           if(_formkey.currentState.validate())
                            {

                           /* Navigator.push(
                                context, MaterialPageRoute(builder: (context) {
                              return Cprofile();
                                })); */

                            }
                             }, */
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10.0),
                          side: BorderSide(color: Colors.yellow)),
                      color: Colors.yellow,
                      child: Center(
                        child: Text(
                          "Update",
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

  Future<void> UserUpdate() async {
    {
      final formState = _formkey.currentState;
      if (formState.validate()) {
        formState.save();
        try {
          await DatabaaseService(uid: widget.uid)
              .DatabaseupdateUserData(_name, _phone, _address, _gender);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => home()));
        } catch (e) {
          print(e.message);
          print(_gender);
          print(_name);
          print(_phone);
          print(_email);
          print(_password);
          print(_address);
        }
      }
    }
  }
}
