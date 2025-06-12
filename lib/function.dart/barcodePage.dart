import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:stockpls/pages/add.dart';

class BarcodeScannerModal extends StatefulWidget {
  @override
  State<BarcodeScannerModal> createState() => _BarcodeScannerModalState();
}

class _BarcodeScannerModalState extends State<BarcodeScannerModal> {
  bool _isProcessing = false;
  String? _scanMessage;
  late MobileScannerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Modal handle (sürükleme çubuğu)
          Container(
            width: 40,
            height: 4,
            margin: EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Barkod Tara',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close),
                ),
              ],
            ),
          ),

          // Scanner area
          Expanded(
            child: Container(
              margin: EdgeInsets.all(16),
              clipBehavior: Clip.hardEdge, // Bu satırı değiştirdim
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  MobileScanner(
                    controller: _controller,
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

                          await Future.delayed(
                            Duration(seconds: 1, milliseconds: 500),
                          );

                          try {
                            // Modal'ı kapat
                            Navigator.pop(context);

                            // Ürün ekleme sayfasına git
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProductAddPage(barcode: code),
                              ),
                            );
                          } catch (e) {
                            setState(() {
                              _isProcessing = false;
                              _scanMessage = null;
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Barkod tarama hatası: $e'),
                              ),
                            );
                          }
                        }
                      }
                    },
                  ),

                  // Loading overlay
                  if (_isProcessing)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(color: Colors.white),
                            SizedBox(height: 16),
                            Text(
                              _scanMessage ?? '',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Alt bilgi
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Barkodu kamera görüş alanına getirin',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
