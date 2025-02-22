import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'views/login_page.dart';
import 'providers/product_provider.dart';
import '/core/config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: Config.supabaseUrl,
    anonKey: Config.supabaseAnonKey,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductoProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> checkSession() async {
    await Future.delayed(const Duration(seconds: 1)); // 🔥 Espera breve para asegurar carga correcta
    return Supabase.instance.client.auth.currentUser != null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Inditex App',
      home: FutureBuilder<bool>(
        future: checkSession(),
        builder: (context, snapshot) {
            return const LoginPage(); // 🔥 Si NO está autenticado, ir a Login
        },
      ),
    );
  }
}
