import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/product_model.dart';

class ProductoDetallePage extends StatelessWidget {
  final Producto producto;

  const ProductoDetallePage({super.key, required this.producto});

  /// 🔹 Método para compartir el enlace del producto con opciones
  void _compartirProducto(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "COMPARTIR",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1),
              ),
              const SizedBox(height: 10),
              ListTile(
                leading: const Icon(Icons.link, color: Colors.black),
                title: const Text("Copiar enlace"),
                onTap: () {
                  Clipboard.setData(ClipboardData(text: producto.link));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Enlace copiado al portapapeles"),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const FaIcon(FontAwesomeIcons.whatsapp, color: Colors.green),
                title: const Text("WhatsApp"),
                onTap: () {
                  final url = "https://wa.me/?text=${Uri.encodeComponent(producto.link)}";
                  launchUrl(Uri.parse(url));
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const FaIcon(FontAwesomeIcons.instagram, color: Colors.purple),
                title: const Text("Instagram"),
                onTap: () {
                  Share.share(producto.link);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const FaIcon(FontAwesomeIcons.xTwitter, color: Colors.black),
                title: const Text("X (Twitter)"),
                onTap: () {
                  final url = "https://twitter.com/intent/tweet?text=${Uri.encodeComponent(producto.link)}";
                  launchUrl(Uri.parse(url));
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const FaIcon(FontAwesomeIcons.tiktok, color: Colors.black),
                title: const Text("TikTok"),
                onTap: () {
                  Share.share(producto.link);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Fondo limpio y neutro
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Barra superior con botón de volver
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, size: 28, color: Colors.black),
                  onPressed: () => Navigator.pop(context), // ✅ Volver atrás
                ),
              ],
            ),
          ),

          // 🔹 Imagen grande del producto
          Expanded(
            flex: 6,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(producto.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // 🔹 Detalles del producto
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔹 Nombre del producto
                  Text(
                    producto.name.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // 🔹 Precio del producto
                  Text(
                    producto.price != null
                        ? "${producto.price!.current} ${producto.price!.currency}"
                        : "Precio no disponible",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(height: 5),

                  // 🔹 Precio anterior si existe
                  if (producto.price?.original != null)
                    Text(
                      "Antes: ${producto.price!.original} ${producto.price!.currency}",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),

                  const SizedBox(height: 12),

                  // 🔹 Marca del producto
                  Text(
                    producto.brand.toUpperCase(),
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey),
                  ),

                  const SizedBox(height: 16),

                  // 🔹 Botón para abrir el enlace (ahora comparte el enlace en lugar de solo abrirlo)
                  GestureDetector(
                    onTap: () => Share.share(producto.link),
                    child: const Text(
                      "VER EN WEB",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        color: Colors.black,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // 🔹 Botón flotante para compartir
      floatingActionButton: FloatingActionButton(
        onPressed: () => _compartirProducto(context),
        backgroundColor: Colors.black,
        child: const Icon(Icons.share, color: Colors.white),
      ),
    );
  }
}
