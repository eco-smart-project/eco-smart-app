import 'dart:async';
import 'dart:convert';

import 'package:eco_smart/components/custom_avatar.dart';
import 'package:eco_smart/utils/image_utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eco_smart/core/constants.dart';

class MainDrawer extends StatefulWidget {
  final bool rounded;
  final bool isMobile;
  const MainDrawer({super.key, this.rounded = true, this.isMobile = true});

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  late dynamic userData = {};
  String? lastSyncDate;
  String? foto;
  Timer? _timer;

  Future<void> _fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userData = jsonDecode(prefs.getString('user_data') ?? '');
      foto = userData['photo'];
    });
  }

  Future<void> _logout(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sair'),
          content: const Text('Deseja realmente desconectar?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar', style: TextStyle(color: Colors.red)),
            ),
            ElevatedButton(
              onPressed: () {
                SharedPreferences.getInstance().then((prefs) {
                  prefs.remove('access_token').then((value) {
                    context.go('/login');
                  });
                });
              },
              child: const Text('Sair'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String getUserName(dynamic userData) {
    if (userData is Map<String, dynamic>) {
      return userData['name'] ?? '';
    }
    return '';
  }

  void _showImageSourceActionSheet(BuildContext context) async {
    final image = await pickImage(context);

    if (image.isNotEmpty && image['image'] != null && image['image']!.isNotEmpty) {
      setState(() {
        foto = image['image']!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String currentRoute = GoRouter.of(context).routerDelegate.currentConfiguration.uri.toString();

    return Drawer(
      elevation: 0,
      shape: widget.rounded
          ? const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            )
          : const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
      child: Column(
        children: <Widget>[
          SizedBox(
            width: double.infinity,
            child: DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: Column(
                children: <Widget>[
                  CustomAvatar(
                    name: getUserName(userData),
                    photo: foto == null || foto!.isEmpty ? null : foto,
                    defaultAsset: 'assets/images/user_default_icon.png',
                    size: 50,
                    fontSize: 30,
                    canChangePhoto: true,
                    onTap: () {
                      _showImageSourceActionSheet(context);
                    },
                  ),
                  const SizedBox(height: 10),
                  Text(
                    getUserName(userData),
                    style: TextStyle(color: Theme.of(context).primaryColorLight, fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ListTile(
                    title: const Text('Página Inicial', overflow: TextOverflow.ellipsis),
                    iconColor: Theme.of(context).primaryColor,
                    trailing: const Icon(Icons.home),
                    tileColor: currentRoute == '/' ? Theme.of(context).primaryColor.withOpacity(0.1) : null,
                    onTap: () {
                      if (currentRoute != '/') {
                        if (widget.isMobile) {
                          Navigator.of(context).pop();
                        }
                        context.go('/');
                      }
                    },
                  ),
                  for (var item in MENU_ITEMS)
                    ListTile(
                      title: Text(item['title'], overflow: TextOverflow.ellipsis),
                      iconColor: Theme.of(context).primaryColor,
                      trailing: Icon(item['icon']),
                      tileColor: currentRoute == item['page'] ? Theme.of(context).primaryColor.withOpacity(0.1) : null,
                      onTap: () {
                        if (item['page'] != null) {
                          if (currentRoute != item['page']) {
                            if (widget.isMobile) {
                              Navigator.of(context).pop();
                            }
                            context.go(item['page']);
                          }
                        } else {
                          if (widget.isMobile) {
                            Navigator.of(context).pop();
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Em desenvolvimento, em breve você poderá acessar ${item['title']}!')),
                          );
                        }
                      },
                    ),
                ],
              ),
            ),
          ),
          ListTile(
            title: const Text('Configurações', overflow: TextOverflow.ellipsis),
            iconColor: Theme.of(context).primaryColor,
            trailing: const Icon(Icons.settings),
            tileColor: currentRoute == '/configuracoes' ? Theme.of(context).primaryColor.withOpacity(0.1) : null,
            onTap: () {
              context.go('/configuracoes');
            },
          ),
          ListTile(
            title: const Text('Sair', overflow: TextOverflow.ellipsis),
            iconColor: Colors.red,
            trailing: const Icon(Icons.logout),
            onTap: () {
              _logout(context);
            },
          ),
        ],
      ),
    );
  }
}
