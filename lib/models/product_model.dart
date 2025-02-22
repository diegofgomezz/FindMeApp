class Price {
  final String currency;
  final double current;
  final double? original;

  const Price({
    required this.currency,
    required this.current,
    this.original,
  });

  factory Price.fromJson(Map<String, dynamic> json) {
    return Price(
      currency: json['currency'] ?? "USD",
      current: (json['value']?['current'] as num?)?.toDouble() ?? 0.0,
      original: (json['value']?['original'] as num?)?.toDouble(),
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
      "$current $currency (Antes: ${original ?? 'N/A'} $currency)";
}

class Producto {
  final String? id;
  final String name;
  final Price? price;
  final String link;
  final String brand;
  final String imageUrl;

  const Producto({
    this.id,
    required this.name,
    this.price,
    required this.link,
    required this.brand,
    required this.imageUrl,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json['id']?.toString(), // Convertimos el ID en String si viene como número
      name: json['name'] ?? "Sin nombre",
      price: json['price'] != null ? Price.fromJson(json['price']) : null,
      link: json['link'] ?? "https://via.placeholder.com/150",
      brand: json['brand'] ?? "No brand",
      imageUrl: json.containsKey('imageUrl') && json['imageUrl'] != null
          ? json['imageUrl'] as String
          : "https://via.placeholder.com/150", // Imagen por defecto si no está disponible
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "price": price?.toJson(),
      "link": link,
      "brand": brand,
      "imageUrl": imageUrl,
    };
  }

  // ✅ Método copyWith para actualizar solo algunos valores sin modificar otros
  Producto copyWith({
    String? id,
    String? name,
    Price? price,
    String? link,
    String? brand,
    String? imageUrl,
  }) {
    return Producto(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      link: link ?? this.link,
      brand: brand ?? this.brand,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  @override
  String toString() {
    return "Producto(id: $id, name: $name, price: ${price?.toString()}, link: $link, brand: $brand, imageUrl: $imageUrl)";
  }
}
