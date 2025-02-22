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
      Provider.of<ProductoProvider>(context, listen: false)
          .cargarProductos(widget.imageUrl);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 🔹 Fondo limpio y minimalista
      body: Column(
        children: [
          // 🔹 Barra superior minimalista
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, size: 28, color: Colors.black),
                  onPressed: () => Navigator.pop(context), // ✅ Botón de volver atrás
                ),
                const Text(
                  "PRODUCTOS",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.person, size: 28, color: Colors.black),
                  onPressed: () {}, // ✅ Icono de perfil (a definir función)
                ),
              ],
            ),
          ),

          // 🔹 Contenido principal (Grid de productos)
          Expanded(
            child: Consumer<ProductoProvider>(
              builder: (context, provider, child) {
                if (provider.cargando) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.black),
                  );
                }

                if (provider.productos.isEmpty) {
                  return const Center(
                    child: Text(
                      "No hay productos disponibles",
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 🔹 Dos columnas
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 0.75,
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 🔹 Imagen sin bordes, ocupa todo el ancho
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(0), // 🔹 Estilo cuadrado como Zara
                              child: Image.network(
                                producto.imageUrl,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.image_not_supported, color: Colors.black),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),

                          // 🔹 Nombre del producto en mayúsculas
                          Text(
                            producto.name.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),

                          // 🔹 Precio en negrita
                          Text(
                            "${producto.price?.current ?? 'N/A'}€",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          // 🔹 Precio tachado si hay descuento
                          if (producto.price?.original != null)
                            Text(
                              "${producto.price!.original}€",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // 🔹 Barra inferior con botones minimalistas
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "VOLVER",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    "FAVORITOS",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
