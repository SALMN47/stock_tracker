import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stockpls/add.dart';
import 'package:stockpls/notifier.dart';

class ProductListPage extends ConsumerStatefulWidget {
  static final GlobalKey<_ProductListPageState> globalKey =
      GlobalKey<_ProductListPageState>();

  ProductListPage({Key? key}) : super(key: globalKey);

  @override
  ConsumerState<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends ConsumerState<ProductListPage> {
  @override
  Widget build(BuildContext context) {
    final productList = ref.watch(productProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.yellow[700],
        title: Text(
          'Stok Takip',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Arama çubuğu
            TextField(
              decoration: InputDecoration(
                hintText: 'Ürün Ara...',
                hintStyle: TextStyle(color: Colors.grey),
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[900],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 12),

            // Ürün listesi
            Expanded(
              child: ListView.builder(
                itemCount: productList.length,
                itemBuilder: (context, index) {
                  final product = productList[index];
                  final lowStock = product.stock <= 5;

                  return Card(
                    color: Colors.grey[900],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      title: Text(
                        product.name,
                        style: TextStyle(
                          color: Colors.yellow[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        '${product.barcode} - ${product.stock} adet',
                        style: TextStyle(
                          color: lowStock ? Colors.redAccent : Colors.white70,
                        ),
                      ),
                      trailing: Text(
                        '${product.price.toStringAsFixed(2)} ₺',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        // düzenleme ekranı açılabilir
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.yellow[700],
        foregroundColor: Colors.black,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductAddPage(
                barcode: '',
              ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
