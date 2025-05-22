import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:stockpls/add.dart';

class BarcodeScannerPage extends StatefulWidget {
  @override
  State<BarcodeScannerPage> createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Barkod Tara')),
      body: MobileScanner(
        controller: MobileScannerController(),
        onDetect: (BarcodeCapture capture) {
          final List<Barcode> barcodes = capture.barcodes;

          if (barcodes.isNotEmpty) {
            final String? code = barcodes.first.rawValue;

            if (code != null) {
              try {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductAddPage(barcode: code),
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Barkod tarama hatası: $e')),
                );
              }
            }
          }
        },
      ),
    );
  }
}
