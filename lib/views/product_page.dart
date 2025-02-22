import 'package:flutter/material.dart';
import 'package:validators/validators.dart';
import 'product_list_page.dart'; 

class ProductoPage extends StatefulWidget {
  const ProductoPage({super.key});

  @override
  State<ProductoPage> createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {
  final TextEditingController _urlController = TextEditingController();
  String _imageUrl = ""; 
  String _errorText = ""; 
  bool _isValid = false; 

  @override
  void initState() {
    super.initState();
    _urlController.addListener(_validarImagen);
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  void _validarImagen() {
    final url = _urlController.text.trim();

    if (isURL(url) && (url.endsWith(".jpg") || url.endsWith(".jpeg") || url.endsWith(".png") || url.endsWith(".gif"))) {
      setState(() {
        _imageUrl = url;
        _errorText = "";
        _isValid = true; 
      });
    } else {
      setState(() {
        _imageUrl = "";
        _errorText = "Introduce una URL válida de imagen (jpg, png, gif).";
        _isValid = false;
      });
    }
  }

  void _irAProductos() {
    if (_isValid) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductosGridPage(imageUrl: _imageUrl), // ✅ Pasamos `imageUrl`
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Validar Imagen")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _urlController,
              decoration: InputDecoration(
                labelText: "Introduce la URL de una imagen",
                border: const OutlineInputBorder(),
                errorText: _errorText.isNotEmpty ? _errorText : null,
              ),
            ),
          ),
          if (_imageUrl.isNotEmpty) 
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.network(
                _imageUrl,
                height: 200,
                errorBuilder: (context, error, stackTrace) => const Text("No se pudo cargar la imagen"),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _isValid ? _irAProductos : null, 
              child: const Text("OK"),
            ),
          ),
        ],
      ),
    );
  }
}
