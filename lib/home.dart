import 'package:bankapp/login.dart';
import 'package:flutter/material.dart';
import 'package:bankapp/model.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final UserWidgets userWidgets = UserWidgets();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: WillPopScope(
      onWillPop: () {
        return Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Login()));
      },
      child: Scaffold(
          backgroundColor: UserColors.blackbackground,
          appBar: userWidgets.userappbar(Icons.home),
          body: Column(
            children: [
              accountDetails(),
              Divider(),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        child: Row(
                          children: [
                            Expanded(
                                flex: 1,
                                child: Container(
                                  height: double.infinity,
                                  width: double.infinity,
                                  decoration: decorContainer(),
                                  child: Center(
                                    child: columnContainer(
                                        'Send Money', Icons.send, 70, 30),
                                  ),
                                )),
                            VerticalDivider(),
                            Expanded(
                                flex: 1,
                                child: Container(
                                  height: double.infinity,
                                  width: double.infinity,
                                  decoration: decorContainer(),
                                )),
                          ],
                        ),
                      ),
                    ),
                    Divider(),
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: double.infinity,
                        width: double.infinity,
                        decoration: decorContainer(),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        color: Colors.transparent,
                      ),
                    ),
                  ],
                ),
              )),
            ],
          )),
    ));
  }

  columnContainer(
      String text, IconData icon, double iconSize, double textSize) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: UserColors.yellowColor,
          size: iconSize,
        ),
        Text(
          text,
          style: TextStyle(
              color: UserColors.yellowColor,
              fontSize: textSize,
              fontWeight: FontWeight.bold),
        )
      ],
    );
  }

  decorContainer() {
    return BoxDecoration(
        border: Border.all(
          color: UserColors.yellowColor,
        ),
        borderRadius: BorderRadius.all(Radius.circular(30)));
  }

  accountDetails() {
    return Card(
      margin: EdgeInsets.all(10.0),
      child: Container(
          color: UserColors.blackbackground,
          padding: EdgeInsets.all(5.0),
          // color: Color(0xFF015FFF),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: UserColors.yellowColor,
                    ),
                    onPressed: () {},
                  ),
                  Text("Savings",
                      style: TextStyle(
                          color: UserColors.yellowColor, fontSize: 20.0)),
                  IconButton(
                    icon: Icon(
                      Icons.arrow_forward,
                      color: UserColors.yellowColor,
                    ),
                    onPressed: () {},
                  )
                ],
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text(r"$ " "95,940.00",
                      style: TextStyle(
                          color: UserColors.yellowColor, fontSize: 24.0)),
                ),
              ),
              SizedBox(height: 35.0),
            ],
          )),
    );
  }
}
