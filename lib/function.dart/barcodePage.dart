import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:stockpls/pages/add.dart';

class BarcodeScannerPage extends StatefulWidget {
  @override
  State<BarcodeScannerPage> createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage> {
  bool _isProcessing = false;
  String? _scanMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Barkod Tara')),
      body: Stack(
        children: [
          MobileScanner(
            controller: MobileScannerController(),
            onDetect: (BarcodeCapture capture) async {
              if (_isProcessing) return;

              final List<Barcode> barcodes = capture.barcodes;

              if (barcodes.isNotEmpty) {
                final String? code = barcodes.first.rawValue;

                if (code != null) {
                  setState(() {
                    _isProcessing = true;
                    _scanMessage = "Barkod başarıyla okundu";
                  });

                  // Bekleme süresi: 1.5 saniye (kullanıcıya mesajı göster)
                  await Future.delayed(Duration(seconds: 1, milliseconds: 500));

                  try {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductAddPage(barcode: code),
                      ),
                    ).then((_) {
                      // Sayfadan geri dönülünce işlem durumunu sıfırla
                      setState(() {
                        _isProcessing = false;
                        _scanMessage = null;
                      });
                    });
                  } catch (e) {
                    setState(() {
                      _isProcessing = false;
                      _scanMessage = null;
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Barkod tarama hatası: $e')),
                    );
                  }
                }
              }
            },
          ),

          // Yükleniyor göstergesi ve mesaj
          if (_isProcessing)
            Container(
              color: Colors.black54,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      _scanMessage ?? '',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
