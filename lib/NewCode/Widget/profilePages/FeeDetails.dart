import 'dart:convert';
import 'package:crm_application/NewCode/Model/StudentFeeRecieptModel.dart';
import 'package:crm_application/NewCode/Widget/faseInRoute.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../../../ApiManager/Apis.dart';
import '../../Model/FeeModel.dart';
import 'pdfPreview.dart';

class FeeDetails extends StatefulWidget {
  const FeeDetails({Key? key}) : super(key: key);

  @override
  State<FeeDetails> createState() => FeeDetailsState();
}

class FeeDetailsState extends State<FeeDetails> {
  List<FeeModel> fees = [];
  StudentFeeReceiptModel studentFeeReceipt = StudentFeeReceiptModel();

  void getFeeDetails() async {
    String url = ApiManager.BASE_URL + ApiManager.getStudentFeeHistories;
    final headers = {
      'Authorization': ApiManager.authKey,
    };
    try {
      var response = await http.post(Uri.parse(url), headers: headers);
      debugPrint('FeeResponse = ${response.body}');
      var responseData = await json.decode(response.body);
      if (response.statusCode == 200) {
        if (responseData['status'] == 200) {
          // var message = responseData['message'];
          var data = responseData['data'];
          setState(() {
            data.forEach((v) {
              fees.add(FeeModel.fromJson(v));
            });
          });
          if (kDebugMode) {
            print(fees.length);
          }
        }
      }
    } catch (e) {
      debugPrint('Some Error happened');
    }
  }

  Future<void> studentPrintFreeReceipt(int id) async {
    String url =
        ApiManager.BASE_URL + ApiManager.studentPrintFreeReceipt + '/$id';
    final headers = {
      'Authorization': ApiManager.authKey,
    };
    try {
      var response = await http.get(Uri.parse(url), headers: headers);
      debugPrint('Fee Recipt Response = ${response.body}');
      var responseData = await json.decode(response.body);
      if (response.statusCode == 200) {
        if (responseData['status'] == 200) {
          var message = responseData['message'];
          if (kDebugMode) {
            print(message);
          }

          studentFeeReceipt = StudentFeeReceiptModel.fromJson(responseData);

          if (kDebugMode) {
            print(studentFeeReceipt.studentCourseFees!.first.amount);
          }
        }
      }
    } catch (e) {
      debugPrint('Some Error happened');
    }
  }

  @override
  void initState() {
    super.initState();
    getFeeDetails();
  }

  @override
  Widget build(BuildContext context) {
    // Size s = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fee Details'),
      ),
      body: _getBodyWidget(),
    );
  }

  Widget _getBodyWidget() {
    Size s = MediaQuery.of(context).size;
    return SizedBox(
      child: HorizontalDataTable(
        leftHandSideColumnWidth: s.width * 0.1,
        rightHandSideColumnWidth: s.width * 0.9,
        isFixedHeader: true,
        headerWidgets: _getTitleWidget(),
        leftSideItemBuilder: _generateFirstColumnRow,
        rightSideItemBuilder: _generateRightHandSideColumnRow,
        itemCount: fees.length,
        rowSeparatorWidget: const Divider(
          color: Colors.black54,
          height: 1.0,
          thickness: 0.0,
        ),
      ),
      height: MediaQuery.of(context).size.height,
    );
  }

  List<Widget> _getTitleWidget() {
    Size s = MediaQuery.of(context).size;
    return [
      _getTitleItemWidget('     #', s.width * 0.1),
      _getTitleItemWidget('Reference No.', s.width * 0.2),
      _getTitleItemWidget('Date', s.width * 0.4),
      _getTitleItemWidget('Amount', s.width * 0.2),
      _getTitleItemWidget('Print', s.width * 0.09),
    ];
  }

  Widget _getTitleItemWidget(String label, double width) {
    return Container(
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      width: width,
      height: 56,
      padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }

  Widget _generateFirstColumnRow(BuildContext context, int index) {
    return Container(
      child: Center(child: Text('${index + 1}')),
      color: index % 2 == 0 ? Colors.grey[100] : Colors.white70,
      // width: 100,
      height: 52,
      padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }

  Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
    Size s = MediaQuery.of(context).size;
    FeeModel fee = fees[index];
    return Container(
      color: index % 2 == 0 ? Colors.grey[200] : Colors.white,
      child: Row(
        children: <Widget>[
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(fee.id.toString()),
              ],
            ),
            width: s.width * 0.2,
            height: 52,
            padding: const EdgeInsets.all(5),
            alignment: Alignment.centerLeft,
          ),
          Container(
            child: Text(DateFormat('yyyy-MM-dd  hh:mm aaa')
                .format(DateTime.parse(fee.createdAt!))),
            width: s.width * 0.4,
            height: 52,
            padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
            alignment: Alignment.centerLeft,
          ),
          Container(
            child: Text(fee.amount! + ' ₹'),
            width: s.width * 0.2,
            height: 52,
            padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
            alignment: Alignment.centerLeft,
          ),
          GestureDetector(
            onTap: () async {
              await studentPrintFreeReceipt(fee.id!)
                  .then((value) => Navigator.push(
                      context,
                      ThisIsFadeRoute(
                          route: PDFPreview(
                        receipt: studentFeeReceipt,
                      ))));
            },
            child: Container(
              child: Image.asset('assets/images/print1.png',
                  width: s.width * 0.05),
              width: s.width * 0.09,
              height: 52,
              padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
              alignment: Alignment.centerLeft,
            ),
          ),
        ],
      ),
    );
  }
}
