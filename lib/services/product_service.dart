import '../models/product_model.dart';
import '../core/api_client.dart';

class ProductoService {
  final ApiClient _apiClient = ApiClient();

  Future<List<Producto>> obtenerProductos() async {
    final data = await _apiClient.get('/productos'); // Cambia por el endpoint correcto

    if (data != null && data['items'] is List) {
      return (data['items'] as List)
          .map((json) => Producto.fromJson(json))
          .toList();
    }
    return [];
  }
}
