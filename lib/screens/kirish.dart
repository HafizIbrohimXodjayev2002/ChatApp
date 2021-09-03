import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class KirishEkrani extends StatefulWidget {
  @override
  _KirishEkraniState createState() => _KirishEkraniState();
}

class _KirishEkraniState extends State<KirishEkrani>
    with TickerProviderStateMixin {
  AnimationController? controller;
  AnimationController? controllerText;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      // value: 1,
      duration: Duration(milliseconds: 500),
    );
    controllerText = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    controller!.forward();
    controllerText!.forward();

    // controller!.reverse(from: 1);

    controller!.addListener(() {
      setState(() {});
    });
    controllerText!.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF9096E6),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
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
                  "Mafia Chat",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: controllerText!.value * 33.0,
                      fontWeight: FontWeight.w800),
                )
              ],
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
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, 'sign_in'),
              label: Text(
                "Sign In",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
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
                primary: Color(0xFFFFDFFF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              icon: Icon(
                Icons.king_bed,
                color: Colors.black,
              ),
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, 'sign_up'),
              label: Text(
                "Sign Up",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
