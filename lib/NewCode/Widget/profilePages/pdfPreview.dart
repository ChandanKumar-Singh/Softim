import 'dart:convert';

import 'package:crm_application/NewCode/Model/StudentFeeRecieptModel.dart';
import 'package:crm_application/NewCode/Model/UserLoginData.dart';
import "package:crm_application/NewCode/Widget/profilePages/lib/api/pdf_invoice_api.dart";
import "package:crm_application/NewCode/Widget/profilePages/lib/model/invoice.dart";
import "package:pdf/pdf.dart";
import "package:pdf/widgets.dart" as pw;
import "package:printing/printing.dart";

import "dart:typed_data";

import "package:flutter/material.dart";
import 'package:shared_preferences/shared_preferences.dart';

class PDFPreview extends StatefulWidget {
  PDFPreview({Key? key, required this.receipt}) : super(key: key);

  final StudentFeeReceiptModel receipt;

  @override
  State<PDFPreview> createState() => _PDFPreviewState();
}

class _PDFPreviewState extends State<PDFPreview> {
  late UserLoginData user;

  Future<UserLoginData> checkState() async {
    var prefs = await SharedPreferences.getInstance();
    var response = prefs.getString('loginData')!;
    user = UserLoginData.fromJson(jsonDecode(response)['results']);

    return user;
  }

  @override
  void initState() {
    super.initState();
    checkState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Fee Reciept Preview")),
      body: PdfPreview(
        build: (format) => PdfInvoiceApi.generate(widget.receipt,user),
      ),
    );
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_4, compress: true);
    final font = await PdfGoogleFonts.alegreyaSansLight();

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) {
          return pw.Column(
            children: [
              pw.SizedBox(
                width: double.infinity,
                child: pw.FittedBox(
                    child: pw.Column(children: [
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.Text("Recipt", style: pw.TextStyle(font: font)),
                    ],
                  ),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.Text("Recipt", style: pw.TextStyle(font: font)),
                    ],
                  ),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.Text("Recipt", style: pw.TextStyle(font: font)),
                    ],
                  ),
                ])

                    // pw.Text("title", style: pw.TextStyle(font: font)),
                    ),
              ),
              pw.SizedBox(height: 20),
              pw.Flexible(child: pw.FlutterLogo())
            ],
          );
        },
      ),
    );

    return pdf.save();
  }
}

