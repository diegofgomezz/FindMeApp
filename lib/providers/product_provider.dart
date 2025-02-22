import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';
import '../services/product_service.dart';
import '../models/product_model.dart';

class ProductoProvider extends ChangeNotifier {
  final ProductoService _productoService = ProductoService();
  List<Producto> _productos = [];
  bool _cargando = false;

  List<Producto> get productos => _productos;
  bool get cargando => _cargando;

  Future<void> cargarProductos(String imageUrl) async {
    _cargando = true;
    notifyListeners();

    List<Producto> productos = await _productoService.obtenerProductos(imageUrl);

    _productos = await Future.wait(
      productos.map((producto) async {
        String extractedImageUrl = await _obtenerImagenDesdeZara(producto.link);
        print("✅ Producto: ${producto.name}");
        print("✅ Imagen obtenida: $extractedImageUrl");
        return producto.copyWith(imageUrl: extractedImageUrl);
      }).toList(),
    );

    _cargando = false;
    notifyListeners();
  }

  // 🔹 Buscar imágenes en varias ubicaciones del HTML
  Future<String> _obtenerImagenDesdeZara(String link) async {
    try {
      print("🔍 Obteniendo imagen de: $link");
      final response = await http.get(Uri.parse(link), headers: {
        "User-Agent":
            "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36",
        "Accept-Language": "en-US,en;q=0.9",
        "Referer": "https://www.google.com/",
        "Connection": "keep-alive",
        "Cache-Control": "max-age=0",
      });

      if (response.statusCode == 200) {
        var document = parse(response.body);

        // ✅ 1. Intentar obtener la imagen desde og:image
        var metaImage = document.querySelector('meta[property="og:image"]');
        if (metaImage != null) {
          String? imageUrl = metaImage.attributes['content'];
          if (imageUrl != null && imageUrl.isNotEmpty) {
            print("✅ Imagen extraída de og:image: $imageUrl");
            return imageUrl;
          }
        }

        // ✅ 2. Intentar obtener la imagen desde twitter:image
        var twitterImage = document.querySelector('meta[name="twitter:image"]');
        if (twitterImage != null) {
          String? imageUrl = twitterImage.attributes['content'];
          if (imageUrl != null && imageUrl.isNotEmpty) {
            print("✅ Imagen extraída de twitter:image: $imageUrl");
            return imageUrl;
          }
        }

        // ✅ 3. Intentar obtener la imagen desde etiquetas <img> en la web
        var imgTag = document.querySelector('img');
        if (imgTag != null) {
          String? imageUrl = imgTag.attributes['src'];
          if (imageUrl != null && imageUrl.isNotEmpty) {
            print("✅ Imagen extraída de <img>: $imageUrl");
            return imageUrl;
          }
        }

        // ✅ 4. Intentar obtener la imagen desde un JSON en <script>
        var scripts = document.querySelectorAll('script');
        for (var script in scripts) {
          if (script.text.contains('"media":')) {
            RegExp regex = RegExp(r'"media":\[\{"url":"(https://static\.zara\.net.*?)"');
            var match = regex.firstMatch(script.text);
            if (match != null) {
              String imageUrl = match.group(1)!;
              print("✅ Imagen extraída de script JSON: $imageUrl");
              return imageUrl;
            }
          }
        }
      } else {
        print("❌ Error HTTP: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Error obteniendo imagen de $link: $e");
    }

    print("⚠️ No se pudo extraer imagen, devolviendo imagen por defecto.");
    return "https://via.placeholder.com/300"; // Imagen por defecto si todo falla
  }
}
