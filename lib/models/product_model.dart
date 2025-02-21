class Producto {
  final String id;
  final String nombre;
  final double precio;

  Producto({required this.id, required this.nombre, required this.precio});

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json['id'],
      nombre: json['name'],
      precio: json['price'] ?? 0.0,
    );
  }
}
