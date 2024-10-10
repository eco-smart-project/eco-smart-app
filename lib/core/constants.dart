import 'package:flutter/material.dart';

// const String BASE_API_HOST = 'http://localhost:3000';
const String BASE_API_HOST = 'https://90e6-2804-3c48-118-f200-7524-af79-ea41-6689.ngrok-free.app';

const String BASE_API_URL = '$BASE_API_HOST/api/v1';
const String BASE_API_AUTH_URL = '$BASE_API_HOST/auth/v1';

const int WIDTH_OPEN_DRAWER = 1000;

final List<Map<String, dynamic>> MENU_ITEMS = [
  {'title': 'Pontos de Coleta', 'icon': Icons.map_rounded, 'page': '/pontos-coleta'},
  {'title': 'Identificação de Resíduos', 'icon': Icons.camera_enhance_rounded, 'page': '/identificacao-residuos'}
];
