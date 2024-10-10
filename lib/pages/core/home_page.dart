import 'package:eco_smart/components/main_drawer.dart';
import 'package:eco_smart/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final double gridWidthChange = 1200;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const String title = 'Página inicial';

    return LayoutBuilder(builder: (context, constraints) {
      int crossAxisCount = constraints.maxWidth > gridWidthChange ? 6 : 2;

      return Scaffold(
          appBar: AppBar(
              centerTitle: true,
              title: const Text(title),
              leading: Builder(
                builder: (context) {
                  return constraints.maxWidth <= WIDTH_OPEN_DRAWER
                      ? IconButton(
                          icon: const Icon(Icons.menu),
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          })
                      : const SizedBox.shrink();
                },
              )),
          drawer: constraints.maxWidth <= WIDTH_OPEN_DRAWER ? const MainDrawer() : null,
          body: Row(
            children: [
              if (constraints.maxWidth > WIDTH_OPEN_DRAWER) const MainDrawer(rounded: false, isMobile: false),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.count(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    children: <Widget>[
                      for (var item in MENU_ITEMS) _buildGridButton(context, item, constraints.maxWidth),
                    ],
                  ),
                ),
              )
            ],
          ));
    });
  }

  Widget _buildGridButton(BuildContext context, Map<String, dynamic> item, double maxWidth) {
    double iconSize = maxWidth > gridWidthChange ? 90 : 50;
    double fontSize = maxWidth > gridWidthChange ? 16 : 12;

    return InkWell(
      onTap: () {
        if (item['page'] != null) {
          context.go(item['page']);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Em desenvolvimento, em breve você poderá acessar ${item['title']}!')),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).dialogBackgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(item['icon'], size: iconSize, color: Theme.of(context).primaryColor),
            const SizedBox(height: 10),
            Text(
              item['title'],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}
