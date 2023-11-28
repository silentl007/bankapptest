import 'package:flutter/material.dart';
import 'package:bankapp/model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:number_display/number_display.dart';

class TransactionTabs extends StatefulWidget {
  final String transType;
  TransactionTabs({required this.transType});
  @override
  _TransactionTabsState createState() => _TransactionTabsState();
}

class _TransactionTabsState extends State<TransactionTabs> {
  final displayNumber = createDisplay(length: 50);
  var gettrans;
  List transData = [];
  @override
  void initState() {
    super.initState();
    gettrans = getTrans();
  }

  getTrans() async {
    var decode;
    Uri link = Uri.parse('$baseUrl/transactions');
    try {
      var response = await http.get(link);
      if (response.statusCode == 200) {
        decode = jsonDecode(response.body);
        for (var data in decode['data']) {
          if (data['type'] == widget.transType.toLowerCase()) {
            transData.add(TransModel(
              transtype: data['type'],
              amount: data['amount'],
              accountNumber: data['phoneNumber'],
              date: data['created'],
            ));
          } else {
            transData.add(TransModel(
              transtype: data['type'],
              amount: data['amount'],
              accountNumber: data['phoneNumber'],
              date: data['created'],
            ));
          }
        }
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('error ====> $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: gettrans,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return UserWidgets().loadingIndicator();
          } else if (snapshot.data == true) {
            return success(context: context, data: transData);
          } else {
            return Center(
              child: ElevatedButton(
                child: Text('Retry'),
                onPressed: () {
                  setState(() {
                    gettrans = getTrans();
                  });
                },
              ),
            );
          }
        },
      ),
    );
  }

  success({required BuildContext context, required List data}) {
    return ListView.builder(
      reverse: true,
      itemCount: data.length,
      itemBuilder: (context, index) => Card(
        color: UserColors.blackbackground,
        child: ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                data[index].accountNumber,
                style: styleText(bold: true),
              ),
              Text(
                "₦ ${displayNumber(data[index].amount ?? 0)}",
                style: styleText(bold: true),
              ),
            ],
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              widget.transType.toLowerCase() == 'credit' ||
                      widget.transType.toLowerCase() == 'debit'
                  ? Container()
                  : Text(
                      data[index].transtype,
                      style: styleText(opac: true),
                    ),
              Text(
                data[index].date.substring(0, 10),
                style: styleText(opac: true),
              ),
            ],
          ),
        ),
      ),
    );
  }

  styleText({bool? bold, bool? opac}) {
    return TextStyle(
        color: opac ?? false
            ? UserColors.yellowColor.withOpacity(0.7)
            : UserColors.yellowColor,
        fontWeight: bold ?? false ? FontWeight.bold : FontWeight.normal);
  }
}

class TransModel {
  String transtype;
  int amount;
  String accountNumber;
  String date;
  TransModel(
      {required this.accountNumber,
      required this.amount,
      required this.date,
      required this.transtype});
}
