import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:crm_application/NewCode/Model/StudentFeeRecieptModel.dart';
import 'package:crm_application/NewCode/Model/UserLoginData.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

import '../model/customer.dart';
import '../model/invoice.dart';
import '../model/supplier.dart';
import '../utils.dart';

class PdfInvoiceApi {
  static Future<Uint8List> generate(
      StudentFeeReceiptModel receipt, UserLoginData user) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_4, compress: true);
    pdf.addPage(MultiPage(
      pageTheme: PageTheme(
        theme: ThemeData(),
        buildBackground: (context) => Container(
          color: PdfColor.fromHex('#F2F3F4'),
        ),
      ),
      build: (context) => [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: PdfColor.fromHex('#000000')),
          ),
          child: buildHeader(receipt, user),
        ),
      ],
      // footer: (context) => buildFooter(inv),
    ));

    return pdf.save();
  }

  static Widget buildHeader(
      StudentFeeReceiptModel receipt, UserLoginData user) {
    print(receipt.courseInfo!.duration);
    print(PdfPageFormat.a4.height);
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: PdfColor.fromHex('#000000'))),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 50,
                    // width: 50,
                    child: Center(
                      child: Text(
                        'Receipt',
                        style: const TextStyle(
                          fontSize: 6 * PdfPageFormat.mm,
                        ),
                      ),
                    ),
                    // BarcodeWidget(
                    //   barcode: Barcode.qrCode(),
                    //   data: invoice.info.number,
                    // ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8 * PdfPageFormat.mm),
                      child: Text(user.branchInfo!.name! + "\n ",
                          style: TextStyle(
                              fontSize: 7 * PdfPageFormat.mm,
                              fontWeight: FontWeight.bold),
                          softWrap: true,
                          maxLines: 3,
                          overflow: TextOverflow.clip,
                          textAlign: TextAlign.center),
                    ),
                  )
                ],
              ),
              SizedBox(height: 0.5 * PdfPageFormat.cm),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8 * PdfPageFormat.mm),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 1 * PdfPageFormat.mm),
                        child: Text('Address : ' + user.data!.address!,
                            style: const TextStyle(
                                // fontSize: 7 * PdfPageFormat.mm,
                                // fontWeight: FontWeight.bold,
                                ),
                            // softWrap: true,
                            maxLines: 3,
                            overflow: TextOverflow.clip,
                            textAlign: TextAlign.center),
                      ),
                    ),
                    // Text('Address : ' + invoice['Address'].toString()),
                    Text('Phone : ' + user.data!.contact!),
                  ],
                ),
              ),
              SizedBox(height: 1 * PdfPageFormat.cm),
              Container(
                padding: const EdgeInsets.all(5),
                width: double.maxFinite,
                decoration: BoxDecoration(
                    border: Border.all(color: PdfColor.fromHex('#000000'))),
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Name of Student : ' + user.data!.name!),
                        SizedBox(width: 1 * PdfPageFormat.cm),
                        Text('Course : ' + receipt.courseInfo!.course!),
                      ],
                    ),
                    SizedBox(width: 1 * PdfPageFormat.cm),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Courses Duration : ' +
                                receipt.courseInfo!.duration! ??
                            ''),
                        SizedBox(width: 1 * PdfPageFormat.cm),
                        Text('Date Of Payment : ' +
                            DateFormat('dd-MM-yyyy')
                                .format(DateTime.parse(
                                    receipt.courseInfo!.createdAt!))
                                .toString()),
                      ],
                    ),
                    SizedBox(width: 3.5 * PdfPageFormat.cm),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    width: 2 * PdfPageFormat.cm,
                    decoration: BoxDecoration(
                        border: Border.all(color: PdfColor.fromHex('#000000'))),
                    child: Center(
                      child: Text('Sr No.'),
                    ),
                  ),
                  Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        width: 2 * PdfPageFormat.cm,
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: PdfColor.fromHex('#000000'))),
                        child: Center(child: Text('Particulars')),
                      ),
                      flex: 6),
                  Expanded(
                      child: Container(
                          padding: const EdgeInsets.all(5),
                          width: 2 * PdfPageFormat.cm,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: PdfColor.fromHex('#000000'))),
                          child: Center(child: Text('Amount'))),
                      flex: 2)
                ],
              ),
            ]),
          ),
          Container(
            height: 15 * PdfPageFormat.cm,
            decoration: BoxDecoration(
              // color: Color(0x59346563),
              border: Border.all(color: PdfColor.fromHex('#000000')),
              // color: PdfColor.fromHex('#afc9bf'),
            ),
            child: ListView.builder(
              itemBuilder: (context, i) {
                return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // SizedBox(height: 1 * PdfPageFormat.cm),
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(5),
                            width: 2 * PdfPageFormat.cm,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: PdfColor.fromHex('#000000'))),
                            child: Center(
                                child: Text(
                                    i == receipt.studentCourseFees!.length
                                        ? ' -'
                                        : i.toString())),
                          ),
                          Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                width: 2 * PdfPageFormat.cm,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: PdfColor.fromHex('#000000'))),
                                child: Text(
                                  i == receipt.studentCourseFees!.length
                                      ? 'Total'
                                      : receipt.studentCourseFees![i].feeName!,
                                ),
                              ),
                              flex: 6),
                          Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                width: 2 * PdfPageFormat.cm,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: PdfColor.fromHex('#000000'))),
                                child: Text(
                                  i == receipt.studentCourseFees!.length
                                      ? '30000/-'
                                      : receipt.studentCourseFees![i].amount!,
                                ),
                              ),
                              flex: 2)

                          // Text(invoice['fees'].toString()),
                        ],
                      ),
                      // if(i==receipt.studentCourseFees!.length-1)
                      //   Expanded(child: Container(color: PdfColor.fromHex('#945794')))
                    ]);
              },
              itemCount: receipt.studentCourseFees!.length + 1,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(5),
            // width: 2 * PdfPageFormat.cm,
            decoration: BoxDecoration(
                border: Border.all(color: PdfColor.fromHex('#000000'))),
            child: Column(children: [
              Row(children: [
                Text(
                  'Paid By : ' + 'Cash',
                ),
                Text(
                  'Balance If Any: ' + '0/-',
                ),
              ], mainAxisAlignment: MainAxisAlignment.spaceBetween),
              SizedBox(height: 1 * PdfPageFormat.cm),
              Row(children: [
                Text('Signature of Center Head'),
                Text(
                  'Signature of Student',
                ),
              ], mainAxisAlignment: MainAxisAlignment.spaceBetween),
            ]),
          ),
          Container(
            padding: const EdgeInsets.all(5),
            // width: 2 * PdfPageFormat.cm,
            decoration: BoxDecoration(
                border: Border.all(color: PdfColor.fromHex('#000000'))),
            child: Center(
              child: Text(
                  "All above mentioned Amount once paid are non refundable in any case whatsoever."),
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildCustomerAddress(Customer customer) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(customer.name, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(customer.address),
        ],
      );

  static Widget buildInvoiceInfo(InvoiceInfo info) {
    final paymentTerms = '${info.dueDate.difference(info.date).inDays} days';
    final titles = <String>[
      'Invoice Number:',
      'Invoice Date:',
      'Payment Terms:',
      'Due Date:'
    ];
    final data = <String>[
      info.number,
      Utils.formatDate(info.date),
      paymentTerms,
      Utils.formatDate(info.dueDate),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(titles.length, (index) {
        final title = titles[index];
        final value = data[index];

        return buildText(title: title, value: value, width: 200);
      }),
    );
  }

  static Widget buildSupplierAddress(Supplier supplier) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(supplier.name, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 1 * PdfPageFormat.mm),
          Text(supplier.address),
        ],
      );

  static Widget buildTitle(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'INVOICE',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
          Text(invoice.info.description),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
        ],
      );

  static Widget buildInvoice(Invoice invoice) {
    final headers = [
      'Description',
      'Date',
      'Quantity',
      'Unit Price',
      'VAT',
      'Total'
    ];
    final data = invoice.items.map((item) {
      final total = item.unitPrice * item.quantity * (1 + item.vat);

      return [
        item.description,
        Utils.formatDate(item.date),
        '${item.quantity}',
        '\$ ${item.unitPrice}',
        '${item.vat} %',
        '\$ ${total.toStringAsFixed(2)}',
      ];
    }).toList();

    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: const BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerRight,
        2: Alignment.centerRight,
        3: Alignment.centerRight,
        4: Alignment.centerRight,
        5: Alignment.centerRight,
      },
    );
  }

  static Widget buildTotal(Invoice invoice) {
    final netTotal = invoice.items
        .map((item) => item.unitPrice * item.quantity)
        .reduce((item1, item2) => item1 + item2);
    final vatPercent = invoice.items.first.vat;
    final vat = netTotal * vatPercent;
    final total = netTotal + vat;

    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          Spacer(flex: 6),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildText(
                  title: 'Net total',
                  value: Utils.formatPrice(netTotal),
                  unite: true,
                ),
                buildText(
                  title: 'Vat ${vatPercent * 100} %',
                  value: Utils.formatPrice(vat),
                  unite: true,
                ),
                Divider(),
                buildText(
                  title: 'Total amount due',
                  titleStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  value: Utils.formatPrice(total),
                  unite: true,
                ),
                SizedBox(height: 2 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
                SizedBox(height: 0.5 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildFooter(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Divider(),
          SizedBox(height: 2 * PdfPageFormat.mm),
          buildSimpleText(title: 'Address', value: invoice.supplier.address),
          SizedBox(height: 1 * PdfPageFormat.mm),
          buildSimpleText(title: 'Paypal', value: invoice.supplier.paymentInfo),
        ],
      );

  static buildSimpleText({
    required String title,
    required String value,
  }) {
    final style = TextStyle(fontWeight: FontWeight.bold);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        Text(title, style: style),
        SizedBox(width: 2 * PdfPageFormat.mm),
        Text(value),
      ],
    );
  }

  static buildText({
    required String title,
    required String value,
    double width = double.infinity,
    TextStyle? titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(child: Text(title, style: style)),
          Text(value, style: unite ? style : null),
        ],
      ),
    );
  }
}
