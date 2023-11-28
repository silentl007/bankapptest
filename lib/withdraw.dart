import 'package:bankapp/home.dart';
import 'package:bankapp/model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class WithDraw extends StatefulWidget {
  @override
  _WithDrawState createState() => _WithDrawState();
}

class _WithDrawState extends State<WithDraw> {
  final amountControl = TextEditingController();
  final _key = GlobalKey<FormState>();
  WithdrawMoneyLogic withdrawMoneyClass = WithdrawMoneyLogic();
  var getAccount;
  int balance = 0;
  String accountN = '';
  SharedPreferences? prefs;
  @override
  void initState() {
    super.initState();
    setPrefs();
    getAccount = getaccount();
  }

  setPrefs() async {
    prefs = await SharedPreferences.getInstance();
    accountN = prefs!.getString('account') ?? '';
  }

  getaccount() async {
    List accountData;
    var decode;
    Uri link = Uri.parse('$baseUrl/accounts/list');
    try {
      var request = await http.get(link);
      if (request.statusCode == 200) {
        print('account number =====> $accountN');
        decode = jsonDecode(request.body);
        accountData = decode['data'];
        for (var data in accountData) {
          if (data['phoneNumber'] == accountN) {
            balance = data['balance'];
            print('account balance =====> $balance');
          }
        }
        return true;
      } else {
        return false;
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
        onWillPop: () async {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Home()));
          return true;
        },
        child: Scaffold(
          backgroundColor: UserColors.blackbackground,
          appBar: UserWidgets().userappbar(Icons.atm, f18, 'Withdraw'),
          body: FutureBuilder(
            future: getAccount,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return UserWidgets().loadingIndicator();
              } else if (snapshot.data == true) {
                return success(context, balance);
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
    double h40 = size.height * .05;
    double f24 = size.height * .03;
    double f16 = size.height * .02;
    double w200 = size.height * .25;
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Form(
        key: _key,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            UserWidgets().accountDetails(amount, context),
            TextFormField(
                controller: amountControl,
                keyboardType: TextInputType.number,
                validator: (text) {
                  if (text!.isEmpty) {
                    return 'This field is empty';
                  } else if (text.contains(',')) {
                    return 'Please remove the ,';
                  } else if (text.contains('.')) {
                    return 'Please remove the .';
                  }
                  return null;
                },
                onSaved: (text) {
                  withdrawMoneyClass.amount = int.tryParse(text!) ?? 0;
                },
                decoration: UserWidgets().inputdecor('Amount', f16)),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                button('Withdraw', context, h40, w200, f24),
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
        if (keyState!.validate()) {
          withdrawMoneyClass.username = accountN;
          keyState.save();
          send(context);
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
              future: withdrawMoneyClass.withdraw(),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return UserWidgets().loadingDiag();
                } else if (snapshot.data == 200) {
                  resetField();
                  return noticeDiag(context, 'Money withdrawn!');
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
        keyState!.reset();
        amountControl.clear();
      });
    });
  }

  noticeDiag(BuildContext context, String errorDetails) {
    Size size = MediaQuery.of(context).size;
    double f45 = size.height * .05632;
    return Container(
      color: Colors.transparent,
      child: AlertDialog(
        backgroundColor: UserColors.blackbackground,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        title: Center(
            child: Icon(
          Icons.error,
          size: f45,
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
}
