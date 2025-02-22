import 'package:flutter/material.dart';
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

    _productos = await _productoService.obtenerProductos(imageUrl);

    _cargando = false;
    notifyListeners();
  }
}
