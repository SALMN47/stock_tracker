import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:stockpls/barcodePage.dart';
import 'package:stockpls/listpage.dart';
import 'package:stockpls/notifier.dart';
import 'package:stockpls/product_model.dart';

class ProductAddPage extends ConsumerStatefulWidget {
  final String barcode;
  const ProductAddPage({Key? key, required this.barcode}) : super(key: key);
  @override
  ConsumerState<ProductAddPage> createState() => _ProductAddPageState();
}

class _ProductAddPageState extends ConsumerState<ProductAddPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _codeController.text = widget.barcode;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final productNotifier = ref.read(productProvider.notifier);

      productNotifier.add(Product(
        name: _nameController.text,
        barcode: _codeController.text,
        stock: int.parse(_stockController.text),
        price: double.parse(_priceController.text),
      ));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ürün başarıyla eklendi')),
      );
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => ProductListPage()));

      _nameController.clear();
      _codeController.clear();
      _priceController.clear();
      _stockController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    // final _codeController = TextEditingController(text: initialBarcode ?? "");
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text("Ürün Ekle"),
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              buildField("Ürün Adı", _nameController),
              SizedBox(height: 12),
              buildFieldcode("Barkod", _codeController,
                  keyboardType: TextInputType.number),
              SizedBox(height: 12),
              buildField("Fiyat", _priceController,
                  keyboardType: TextInputType.number),
              SizedBox(height: 12),
              buildField("Stok Adedi", _stockController,
                  keyboardType: TextInputType.number),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  textStyle: TextStyle(fontSize: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: Text("Ürünü Ekle"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      cursorColor: Colors.white,
      controller: controller,
      keyboardType: keyboardType,
      style: TextStyle(color: Colors.white),
      validator: (value) =>
          value == null || value.isEmpty ? "$label boş bırakılamaz" : null,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white),
        filled: true,
        fillColor: Colors.black,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.amber, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget buildFieldcode(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.75,
          child: TextFormField(
            cursorColor: Colors.white,
            controller: _codeController,
            keyboardType: keyboardType,
            style: TextStyle(color: Colors.white),
            validator: (value) => value == null || value.isEmpty
                ? "$label boş bırakılamaz"
                : null,
            decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(color: Colors.white),
              filled: true,
              fillColor: Colors.black,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1.5),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.amber, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 1.5),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BarcodeScannerPage(),
                ),
              );
            },
            icon: Icon(Icons.barcode_reader),
            color: Colors.amber,
            iconSize: 40),
      ],
    );
  }
}
