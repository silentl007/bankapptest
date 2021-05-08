import 'package:bankapp/home.dart';
import 'package:bankapp/model.dart';
import 'package:bankapp/transactiontab.dart';
import 'package:flutter/material.dart';

class Transaction extends StatelessWidget {
  final List transType = ['Credit', 'All', 'Debit'];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () {
          return Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Home()));
        },
        child: DefaultTabController(
          length: transType.length,
          initialIndex: 1,
          child: Scaffold(
            backgroundColor: UserColors.blackbackground,
            appBar: AppBar(
              title: Padding(
                padding: EdgeInsets.all(18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.history,
                      color: UserColors.yellowColor,
                    ),
                  ],
                ),
              ),
              backgroundColor: UserColors.blackbackground,
              bottom: TabBar(
                isScrollable: true,
                tabs: transType
                    .map((tabText) => Tab(
                          text: tabText,
                        ))
                    .toList(),
              ),
            ),
            body: TabBarView(
              children: transType
                  .map((tabText) => TransactionTabs(
                        transType: tabText,
                      ))
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}
