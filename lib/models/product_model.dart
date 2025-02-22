class Price {
  final String currency;
  final double current;
  final double? original; // 🔥 Puede ser `null`

  const Price({
    required this.currency,
    required this.current,
    this.original, // 🔥 Permitimos `null`
  });

  factory Price.fromJson(Map<String, dynamic> json) {
    return Price(
      currency: json['currency'] ?? "USD",
      current: (json['value']?['current'] as num?)?.toDouble() ?? 0.0, // ✅ Manejo seguro
      original: (json['value']?['original'] as num?)?.toDouble(), // ✅ Manejo seguro
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "currency": currency,
      "current": current,
      "original": original,
    };
  }

  @override
  String toString() =>
      "$current $currency (Antes: ${original ?? 'N/A'} $currency)"; // ✅ Manejo seguro
}

class Producto {
  final String? id; // 🔥 Ahora permite `null`
  final String name;
  final Price? price; // 🔥 Puede ser `null`
  final String link;
  final String brand;

  const Producto({
    this.id, // 🔥 Ya no es `required`
    required this.name,
    this.price, // 🔥 Ya no es `required`
    required this.link,
    required this.brand,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json['id'] as String?, // ✅ Manejo seguro
      name: json['name'] ?? "Sin nombre", // ✅ Valor por defecto
      price: json['price'] != null ? Price.fromJson(json['price']) : null, // ✅ Manejo seguro
      link: json['link'] ?? "https://via.placeholder.com/150",
      brand: json['brand'] ?? "No brand",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "price": price?.toJson(), // ✅ Manejo seguro
      "link": link,
      "brand": brand,
    };
  }
}
