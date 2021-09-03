import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> with SingleTickerProviderStateMixin {
  TextEditingController _password = TextEditingController();
  TextEditingController _email = TextEditingController();
  var _formKey = GlobalKey<FormState>();
  AnimationController? controller;
  FirebaseAuth _authUser = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      // value: 1,
      duration: Duration(seconds: 1),
    );

    controller!.forward();
    // controller!.reverse();

    controller!.addListener(() {
      setState(() {});
      print(controller!.value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFff7a3e).withOpacity(
        controller!.value,
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Hero(
                    tag: 'logo',
                    child: Container(
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.cover,
                      ),
                      height: controller!.value * 80,
                    ),
                  ),
                  SizedBox(
                    width: 30.0,
                  ),
                  Text(
                    "Sign In",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 33.0,
                        fontWeight: FontWeight.w800),
                  )
                ],
              ),
              SizedBox(
                height: 40.0,
              ),
              Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: [
                    // FOR EMAIL
                    TextFormField(
                      controller: _email,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Emailni Kiriting",
                      ),
                      validator: (String? text) {
                        if (text!.length < 6) {
                          return "Email 6 ta belgidan kam bolmasin !";
                        }
                      },
                    ),
                    SizedBox(
                      height: 25.0,
                    ),
                    // FOR PASSWORD
                    TextFormField(
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      controller: _password,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Passwordni Kiriting",
                      ),
                      validator: (String? text) {
                        if (text!.length < 6) {
                          return "Password 6 ta belgidan kam bolmasin !";
                        }
                      },
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(
                          double.infinity,
                          60.0,
                        ),
                        primary: Color(0xFFFFDA3E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      icon: Icon(
                        Icons.handyman,
                        color: Colors.black,
                      ),
                      onPressed: () async {
                        try {
                          if (_formKey.currentState!.validate()) {
                            final user =
                                await _authUser.signInWithEmailAndPassword(
                              email: _email.text,
                              password: _password.text,
                            );
                            if (user != null) {
                              Navigator.pushReplacementNamed(
                                  context, 'chat_ekran');
                            }
                          }
                        } catch (e) {
                          // SNACKBAR KERAK
                          print("LOGINDA XATO BOR: " + e.toString());
                        }
                      },
                      label: Text(
                        "Sign In",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
