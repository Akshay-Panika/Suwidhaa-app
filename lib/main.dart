import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/router/app_binding.dart';
import 'package:untitled/router/app_pages.dart';
import 'package:untitled/router/app_routes.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'feature/auth/shared_preferences/auth_shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WebViewPlatform.instance = AndroidWebViewPlatform();
  final bool loggedIn = await AuthSharedPreferences.isLoggedIn();

  runApp(MyApp(
    initialRoute: loggedIn ? AppRoutes.dashboard : AppRoutes.intro,
  ));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Suwidhaa',
      initialBinding: AppBindings(),
      // ✅ Direct route — no flash
      initialRoute: initialRoute,
      getPages: AppPages.pages,
      unknownRoute: GetPage(
        name: '/not-found',
        page: () => Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 80, color: Colors.red),
                const SizedBox(height: 20),
                const Text('Page Not Found'),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Get.offAllNamed(AppRoutes.auth),
                  child: const Text('Go to Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}