import 'package:eco_smart/pages/camera_page.dart';
import 'package:eco_smart/pages/core/home_page.dart';
import 'package:eco_smart/pages/core/login_page.dart';
import 'package:eco_smart/pages/core/welcome_page.dart';
import 'package:eco_smart/pages/map_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:eco_smart/utils/html_stub_helper.dart' 
  if (dart.library.html) 'package:eco_smart/utils/html_web_helper.dart';


Future<bool> isAuthenticated() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('access_token') != null;
}

final GoRouter router = GoRouter(
  initialLocation: '/bem-vindo',
  routes: [
    GoRoute(
      path: '/bem-vindo',
      builder: (context, state) {
        if (kIsWeb){
          setDocumentTitle('Bem-vindo');
        }

        return const WelcomePage();
      }
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) {
        if (kIsWeb){
          setDocumentTitle('Login');
        }

        return const LoginPage();
      }
    ),
    GoRoute(
      path: '/',
      pageBuilder: (context, state) {
        if (kIsWeb){
          setDocumentTitle('Página Inicial');
        }

        return CustomTransitionPage(
          key: state.pageKey,
          child: const HomePage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );
      },
      routes: [
        GoRoute(
          path: 'pontos-coleta',
          builder: (context, state) => const MapPage(),
          pageBuilder: (context, state) {
            if (kIsWeb) {
              setDocumentTitle('Pontos de Coleta');
            }
            
            return CustomTransitionPage(
              key: state.pageKey,
              child: const MapPage(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
            );
          },
        ),
        GoRoute(
          path: 'identificacao-residuos',
          builder: (context, state) => const CameraPage(),
          pageBuilder: (context, state) {
            if (kIsWeb) {
              setDocumentTitle('Identificação de Resíduos');
            }
            
            return CustomTransitionPage(
              key: state.pageKey,
              child: const CameraPage(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
            );
          },
        ),        
      ],
    ),
  ],
  redirect: (context, state) => isAuthenticated().then((isAuth) {
    if (isAuth && state.fullPath == '/login') {
      return '/';
    } else if (!isAuth) {
      return '/login';
    }
    return null;
  }),
);
