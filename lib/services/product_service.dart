import '../models/product_model.dart';
import '../core/api_client.dart';
import '../core/config.dart';

class ProductoService {
  final ApiClient _apiClient = ApiClient();

  Future<List<Producto>> obtenerProductos(String imageUrl) async {
    // 🔥 Asegurar que la URL de la imagen es válida
    if (!imageUrl.startsWith("http")) {
      print("❌ Error: La URL de la imagen no es válida.");
      return [];
    }

    // 🔥 Asegurar que la URL del endpoint tiene / antes de products
    final endpoint = '/products?image=$imageUrl';

    print("📌 Haciendo petición GET a: ${Config.sandboxBaseUrl}$endpoint");

    final data = await _apiClient.get(endpoint);

    print("📌 Respuesta de la API: $data");

    if (data != null && data is List) {
      return (data)
          .map((json) => Producto.fromJson(json))
          .toList();
    }

    print("⚠️ Error: No se encontraron productos o el formato es incorrecto");
    return [];
  }
}