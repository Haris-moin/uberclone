import 'dart:io';

import 'package:cabservice/screens/CustProfile.dart';
import 'package:cabservice/screens/DisplayProfile.dart';
import 'package:cabservice/screens/DriverProfile.dart';
import 'package:cabservice/screens/database.dart';
import 'package:cabservice/screens/drivermap.dart';
import 'package:cabservice/screens/driversignup.dart';
import 'package:cabservice/screens/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cabservice/screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _tabController = new TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: DefaultTabController(
            length: 2,
            child: Scaffold(
                appBar: AppBar(
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.directions_car,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        // do something
                      },
                    )
                  ],
                  title: Text('Karachi Cab',
                      style: TextStyle(color: Colors.black, fontSize: 16.0)),
                  bottom: TabBar(labelColor: Colors.black, tabs: <Widget>[
                    Tab(
                      text: 'Customer',
                    ),
                    Tab(
                      text: 'Driver',
                    ),
                  ]),
                  backgroundColor: Colors.yellow,
                ),
                body: TabBarView(
                  children: <Widget>[
                    cuslogin(),
                    driverlogin(),
                  ],
                ))));
  }
}

class cuslogin extends StatefulWidget {
  @override
  _cusloginState createState() => _cusloginState();
}

class _cusloginState extends State<cuslogin> {
  bool isloggedIn = false;
  String email, _password;
  final emailController = TextEditingController();
  bool visible = false;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        exitscreen();
      },
     child : Scaffold(
      body: Container(
        child: ListView(
          padding:
              EdgeInsets.only(top: 50.0, right: 20.0, left: 20.0, bottom: 20.0),
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
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
                            return "Please type an Email";
                          }
                          return null;
                        },
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        onSaved: (input) => email = input,
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
                          if (input.length < 6) {
                            return "Password Should be minimun 6 charcters";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.visiblePassword,
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
                          prefixIcon: Icon(Icons.lock),
                        ),
                        obscureText: true,
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
                              if (_formkey.currentState.validate()) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            home(email: emailController.text)));
                                signIn();
                                // If the form is valid, display a Snackbar.
                                Scaffold.of(context).showSnackBar(
                                    SnackBar(content: Text('Processing Data')));
                              }
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(10.0),
                                side: BorderSide(color: Colors.yellow)),
                            color: Colors.yellow,
                            child: Center(
                              child: Text(
                                "Login",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                          )),
                      SizedBox(
                        height: 20.0,
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        "Forgotten Password?",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Don't have an account?"),
                        SizedBox(
                          width: 10.0,
                        ),
                        OutlineButton(
                          onPressed: () => Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return custSignup();
                          })),
                          borderSide: BorderSide(color: Colors.white24),
                          child: Text(
                            "SIGN UP",
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                        Visibility(
                            visible: visible,
                            child: Container(
                                margin: EdgeInsets.only(bottom: 30),
                                child: CircularProgressIndicator())),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }
  void exitscreen ()
  {
    exit(0);
  }
  @override
  void initState()
  {
    super.initState();
    _checkLogin();

  }
  Future _checkLogin() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getBool("isLoggedIn")){
      Navigator.push(context, MaterialPageRoute(builder: (context)=>home()));

    }

  }
  Future<void> signIn() async {
    {
      final formState = _formkey.currentState;
      if (formState.validate()) {
        formState.save();
        try {
          final SharedPreferences pref = await SharedPreferences.getInstance();
          pref.setBool("isloggedIn", true);
          pref.setString("emailController", emailController.text);
          AuthResult result = await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: email, password: _password);
          FirebaseUser user = result.user;
          DatabaaseService(uid: user.uid).getCustomer();
        } catch (e) {
          print(e.message);
        }
      }
    }
  }
}

class driverlogin extends StatefulWidget {
  @override
  driverlogState createState() => driverlogState();
}

class driverlogState extends State<driverlogin> {
  String _email, _password;
  final emailController = TextEditingController();
  bool visible = false;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView(
          padding:
              EdgeInsets.only(top: 50.0, right: 20.0, left: 20.0, bottom: 20.0),
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
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
                            return "Please type an Email";
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
                          if (input.length < 6) {
                            return "Password Should be minimun 6 charcters";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.visiblePassword,
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
                          prefixIcon: Icon(Icons.lock),
                        ),
                        obscureText: true,
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
                              if (_formkey.currentState.validate()) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Driverhome(
                                            email: emailController.text)));
                                DriverSignIn();
                                // If the form is valid, display a Snackbar.
                                Scaffold.of(context).showSnackBar(
                                    SnackBar(content: Text('Processing Data')));
                              }
                            },
                            // Validate returns true if the form is valid, or false
                            // otherwise.

                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(10.0),
                              side: BorderSide(color: Colors.yellow),
                            ),
                            color: Colors.yellow,

                            child: Center(
                              child: Text(
                                "Login",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                          )),
                      SizedBox(
                        height: 20.0,
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        "Forgotten Password?",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Don't have an account?"),
                        SizedBox(
                          width: 10.0,
                        ),
                        OutlineButton(
                          onPressed: () => Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return driverSignUp();
                          })),
                          borderSide: BorderSide(color: Colors.white12),
                          child: Text(
                            "SIGN UP",
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                        Visibility(
                            visible: visible,
                            child: Container(
                                margin: EdgeInsets.only(bottom: 30),
                                child: CircularProgressIndicator())),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> DriverSignIn() async {
    {
      final formState = _formkey.currentState;
      if (formState.validate()) {
        formState.save();
        try {
          AuthResult result = await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: _email, password: _password);
          FirebaseUser user = result.user;
          DriverDatabaseService(D_id: user.uid).getdriver();
        } catch (e) {
          print(e.message);
          print("error haris");
        }
      }
    }
  }
}
