import 'package:flutter/material.dart';
import 'package:validators/validators.dart';
import 'package:file_picker/file_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';
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
  bool _isUploading = false;

  final supabase = Supabase.instance.client;

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

  /// 🔹 Valida si la URL ingresada manualmente es correcta
  void _validarImagen() {
    final url = _urlController.text.trim();

    if (isURL(url) &&
        (url.endsWith(".jpg") ||
            url.endsWith(".jpeg") ||
            url.endsWith(".png") ||
            url.endsWith(".gif"))) {
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

  /// 🔹 Función para subir imagen a Supabase Storage
  Future<void> _subirImagen() async {
    setState(() => _isUploading = true);

    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result == null || result.files.isEmpty) {
      setState(() => _isUploading = false);
      return;
    }

    final file = File(result.files.single.path!);
    final fileName =
        '${DateTime.now().millisecondsSinceEpoch}_${result.files.single.name}';
    final storagePath = 'uploads/$fileName';

    try {
      // ✅ Subimos el archivo a Supabase Storage
      await supabase.storage.from('images').upload(storagePath, file);

      // ✅ Obtenemos la URL pública del archivo
      final publicUrl =
          supabase.storage.from('images').getPublicUrl(storagePath);

      setState(() {
        _imageUrl = publicUrl;
        _urlController.text = publicUrl;
        _errorText = "";
        _isValid = true;
        _isUploading = false;
      });

      print("✅ Imagen subida correctamente: $publicUrl");
    } catch (error) {
      print("❌ Error al subir la imagen: $error");
      setState(() {
        _errorText = "Error al subir la imagen";
        _isUploading = false;
      });
    }
  }

  /// 🔹 Función para navegar a la pantalla de productos
  void _irAProductos() {
    if (_isValid) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductosGridPage(imageUrl: _imageUrl),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 🔹 Fondo blanco minimalista
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Botón de "Volver"
            IconButton(
              icon: const Icon(Icons.arrow_back, size: 28, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),

            const SizedBox(height: 20),

            // 🔹 Título "SUBIR IMAGEN"
            const Text(
              "SUBIR IMAGEN",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),

            const SizedBox(height: 20),

            // 🔹 Botón de selección de imagen (Texto plano)
            GestureDetector(
              onTap: _isUploading ? null : _subirImagen,
              child: Text(
                _isUploading ? "SUBIENDO..." : "SELECCIONAR IMAGEN",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: _isUploading ? Colors.grey : Colors.black,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 🔹 Input para ingresar URL de imagen
            TextField(
              controller: _urlController,
              style: const TextStyle(fontSize: 16, color: Colors.black),
              decoration: InputDecoration(
                hintText: "O INTRODUCE URL",
                hintStyle: TextStyle(color: Colors.black.withOpacity(0.5)),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                errorText: _errorText.isNotEmpty ? _errorText : null,
              ),
            ),

            const SizedBox(height: 20),

            // 🔹 Mostrar imagen si ya se subió o se ingresó una URL válida
            if (_imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(0),
                child: Image.network(
                  _imageUrl,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Text(
                      "No se pudo cargar la imagen",
                      style: TextStyle(color: Colors.red)),
                ),
              ),

            const SizedBox(height: 40),

            // 🔹 Botón de búsqueda estilizado
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isValid ? _irAProductos : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0)),
                ),
                child: const Text(
                  "BUSCAR PRODUCTO",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
