import 'dart:convert';
import 'package:bankapp/home.dart';
import 'package:bankapp/model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:number_display/number_display.dart';

class SendMoney extends StatefulWidget {
  final int balance;
  SendMoney(this.balance);
  @override
  _SendMoneyState createState() => _SendMoneyState();
}

class _SendMoneyState extends State<SendMoney> {
  final displayNumber = createDisplay(length: 50);
  final accountControl = TextEditingController();
  final amountControl = TextEditingController();
  final _key = GlobalKey<FormState>();
  SendMoneyLogic sendMoneyClass = SendMoneyLogic();
  var getAccount;
  int balance;
  String accountN;
  SharedPreferences prefs;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setPrefs();
    getAccount = getaccount();
  }

  setPrefs() async {
    prefs = await SharedPreferences.getInstance();
    accountN = prefs.getString('account');
  }

  getaccount() async {
    List accountData;
    var decode;
    Uri link = Uri.parse('https://bank.veegil.com/accounts/list');
    try {
      var request = await http.get(link);
      if (request.statusCode == 200) {
        print('account number =====> $accountN');
        decode = jsonDecode(request.body);
        accountData = decode['data'];
        for (var data in accountData) {
          if (data['phoneNumber'] == accountN ?? '007') {
            balance = data['balance'];
            print('account balance =====> $balance');
          }
        }
        return balance;
      }
    } catch (e) {
      print('error =====> $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
     Size size = MediaQuery.of(context).size;
    double f18 = size.height * .0225;
    return SafeArea(
      child: WillPopScope(
        onWillPop: () {
          return Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Home()));
        },
        child: Scaffold(
          backgroundColor: UserColors.blackbackground,
          appBar: UserWidgets().userappbar(Icons.send, f18),
          body: FutureBuilder(
            future: getAccount,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return UserWidgets().loadingIndicator();
              } else if (snapshot.hasData) {
                return success(context, snapshot.data);
              } else {
                return Center(
                  child: ElevatedButton(
                    child: Text('Retry'),
                    onPressed: () {
                      setState(() {
                        getAccount = getaccount();
                      });
                    },
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  success(BuildContext context, int amount) {
    Size size = MediaQuery.of(context).size;
    final node = FocusScope.of(context);
    double h40 = size.height * .05;
    double f24 = size.height * .03;
    double f16 = size.height * .02;
    double f18 = size.height * .0225;
    double w200 = size.height * .25;
    return Padding(
      padding:  EdgeInsets.all(f18),
      child: Form(
        key: _key,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            UserWidgets().accountDetails(amount, context),
            TextFormField(
                controller: accountControl,
                onEditingComplete: () => node.nextFocus(),
                keyboardType: TextInputType.number,
                validator: (text) {
                  if (text.isEmpty) {
                    return 'This field is empty';
                  }
                },
                onSaved: (text) {
                  sendMoneyClass.username = text;
                },
                decoration: UserWidgets().inputdecor('Account Number', f16)),
            Divider(),
            TextFormField(
                controller: amountControl,
                keyboardType: TextInputType.number,
                validator: (text) {
                  if (text.isEmpty) {
                    return 'This field is empty';
                  } else if (text.contains(',')) {
                    return 'Please remove the ,';
                  } else if (text.contains('.')) {
                    return 'Please remove the .';
                  }
                },
                onSaved: (text) {
                  sendMoneyClass.amount = int.tryParse(text);
                },
                decoration: UserWidgets().inputdecor('Amount', f16)),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                button('Transfer', context, h40, w200, f24),
                VerticalDivider(),
                UserWidgets().welcomeText(
                    text: "Select Beneficiaries",
                    sizeFont: f16,
                    height: 2,
                    bold: false),
              ],
            )
          ],
        ),
      ),
    );
  }

  button(String text, BuildContext context, double containerH,
      double containerW, double sizefont) {
    return InkWell(
      onTap: () {
        var keyState = _key.currentState;
        if (keyState.validate()) {
          keyState.save();
          sendDetails(context);
          // send(context);
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 0, right: 0),
        child: Container(
          height: containerH,
          width: containerW,
          decoration: BoxDecoration(
            color: UserColors.yellowColor,
            borderRadius: BorderRadius.all(
              Radius.circular(25),
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0xFFF3D657).withOpacity(0.2),
                spreadRadius: 3,
                blurRadius: 4,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: sizefont,
                fontWeight: FontWeight.bold,
                color: UserColors.blackbackground,
              ),
            ),
          ),
        ),
      ),
    );
  }

  send(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => FutureBuilder(
              future: sendMoneyClass.sendmoney(),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return UserWidgets().loadingDiag();
                } else if (snapshot.data == 200) {
                  resetField();
                  return noticeDiag(context, 'Money sent!');
                } else if (snapshot.data == 404) {
                  return UserWidgets()
                      .noticeDiag(context, 'Account not found!');
                } else if (snapshot.data == 409) {
                  return UserWidgets()
                      .noticeDiag(context, 'Account not found! 2');
                } else {
                  return UserWidgets().noticeDiag(context,
                      'Unable to register, please check internet connection');
                }
              },
            ));
  }

  resetField() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var keyState = _key.currentState;
      setState(() {
        keyState.reset();
        accountControl.clear();
        amountControl.clear();
      });
    });
  }

  noticeDiag(BuildContext context, String errorDetails) {
    return Container(
      color: Colors.transparent,
      child: AlertDialog(
        backgroundColor: UserColors.blackbackground,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        title: Center(
            child: Icon(
          Icons.error,
          size: 45,
          color: UserColors.yellowColor,
        )),
        content: Text(
          errorDetails,
          style: TextStyle(color: UserColors.yellowColor),
          textAlign: TextAlign.start,
        ),
        actions: [
          ElevatedButton.icon(
            icon: Icon(
              Icons.close,
              color: UserColors.blackbackground,
            ),
            label: Text(
              'Close',
              style: TextStyle(color: UserColors.blackbackground),
            ),
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(UserColors.yellowColor),
                shape: MaterialStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50))))),
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                getAccount = getaccount();
              });
            },
          )
        ],
      ),
    );
  }

  sendDetails(BuildContext context) async {
    Size size = MediaQuery.of(context).size;
    double f8 = size.height * .01;
    return showDialog(
        context: context,
        builder: (context) => Container(
              color: Colors.transparent,
              child: AlertDialog(
                backgroundColor: UserColors.blackbackground,
                title: Center(
                  child: Text('Transaction Details',
                      style: TextStyle(color: UserColors.yellowColor)),
                ),
                content: Padding(
                  padding: EdgeInsets.all(f8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'To account :',
                            style: styleText(),
                          ),
                          Text(
                            '${accountControl.text}',
                            style: styleText(bold: true),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Amount :',
                            style: styleText(),
                          ),
                          Text(
                            '₦ ${displayNumber(num.tryParse(amountControl.text))}',
                            style: styleText(bold: true),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Bank charges :',
                            style: styleText(),
                          ),
                          Text(
                            '₦ 10.0',
                            style: styleText(bold: true),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                actions: [
                  ElevatedButton.icon(
                    icon: Icon(
                      Icons.check,
                      color: UserColors.yellowColor,
                    ),
                    label: Text(
                      'Accept',
                      style: styleText(),
                    ),
                    style: UserWidgets().buttonDecor(),
                    onPressed: () {
                      Navigator.of(context).pop();
                      send(context);
                    },
                  ),
                  ElevatedButton.icon(
                    icon: Icon(
                      Icons.close,
                      color: UserColors.yellowColor,
                    ),
                    label: Text(
                      'Cancel',
                      style: styleText(),
                    ),
                    style: UserWidgets().buttonDecor(),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ),
            ));
  }

  styleText({bool bold, bool opac}) {
    return TextStyle(
      height: 2,
        color: opac ?? false
            ? UserColors.yellowColor.withOpacity(0.7)
            : UserColors.yellowColor,
        fontWeight: bold ?? false ? FontWeight.bold : FontWeight.normal);
  }
}
