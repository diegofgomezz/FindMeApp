import 'package:flutter/material.dart';
import '../models/product_model.dart';

class ProductoDetallePage extends StatelessWidget {
  final Producto producto;

  const ProductoDetallePage({super.key, required this.producto});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(producto.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                producto.link,
                height: 250,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              producto.name.isNotEmpty ? producto.name : "Sin nombre",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              producto.price != null
                  ? "Precio: ${producto.price!.current} ${producto.price!.currency}"
                  : "Precio no disponible",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              "Marca: ${producto.brand.isNotEmpty ? producto.brand : "Marca desconocida"}",
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // 🔥 Agrega lógica para abrir el enlace en navegador
              },
              child: const Text("Ver en la tienda"),
            ),
          ],
        ),
      ),
    );
  }
}
