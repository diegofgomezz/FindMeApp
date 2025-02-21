import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';

class ProductoProvider with ChangeNotifier {
  final ProductoService _service = ProductoService();
  List<Producto> _productos = [];
  bool _cargando = false;

  List<Producto> get productos => _productos;
  bool get cargando => _cargando;

  Future<void> cargarProductos() async {
    _cargando = true;
    notifyListeners();

    try {
      _productos = await _service.obtenerProductos();
    } catch (e) {
      print("Error al obtener productos: $e");
    }

    _cargando = false;
    notifyListeners();
  }
}
