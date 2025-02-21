
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';

class ProductoPage extends StatefulWidget {
  const ProductoPage({super.key});

  @override
  State<ProductoPage> createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductoProvider>(context, listen: false).cargarProductos();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductoProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Productos")),
      body: provider.cargando
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: provider.productos.length,
              itemBuilder: (context, index) {
                final producto = provider.productos[index];
                return ListTile(
                  title: Text(producto.nombre),
                  subtitle: Text("\$${producto.precio.toStringAsFixed(2)}"),
                );
              },
            ),
    );
  }
}
