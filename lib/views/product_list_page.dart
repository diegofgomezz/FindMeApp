import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import 'product_details_page.dart';

class ProductosGridPage extends StatefulWidget {
  final String imageUrl;

  const ProductosGridPage({super.key, required this.imageUrl});

  @override
  State<ProductosGridPage> createState() => _ProductosGridPageState();
}

class _ProductosGridPageState extends State<ProductosGridPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductoProvider>(context, listen: false).cargarProductos(widget.imageUrl);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Productos")),
      body: Consumer<ProductoProvider>(
        builder: (context, provider, child) {
          if (provider.cargando) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.productos.isEmpty) {
            return const Center(child: Text("No hay productos disponibles"));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(8.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.7,
            ),
            itemCount: provider.productos.length,
            itemBuilder: (context, index) {
              final producto = provider.productos[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductoDetallePage(producto: producto),
                    ),
                  );
                },
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      Image.network(
                        producto.link,
                        height: 150,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              producto.name.isNotEmpty ? producto.name : "Sin nombre",
                              style: const TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              producto.price != null
                                  ? "${producto.price!.current} ${producto.price!.currency}"
                                  : "Precio no disponible",
                            ),
                            Text(
                              producto.brand.isNotEmpty ? producto.brand : "Marca desconocida",
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
