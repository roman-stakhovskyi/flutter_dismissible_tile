import 'package:flutter/material.dart';
import 'package:flutter_dismissible_tile/flutter_dismissible_tile.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const _initialListSize = 10;

  late final _items = List.generate(_initialListSize, (index) => index);
  late final _keys = List.generate(
    _initialListSize,
    (index) => GlobalKey<DismissibleTileState>(),
  );

  void _startDismissAnimation(int index) {
    if (index < _items.length) {
      _keys[index].currentState?.dismiss(
            direction: DismissibleTileDirection.rightToLeft,
          );
    }
  }

  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
      _keys.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
        itemCount: _items.length,
        itemBuilder: (context, index) => DismissibleTile(
          key: _keys[index],
          padding: const EdgeInsets.symmetric(vertical: 8),
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          delayBeforeResize: const Duration(milliseconds: 500),
          ltrBackground: const ColoredBox(color: Colors.yellowAccent),
          rtlBackground: const ColoredBox(color: Colors.greenAccent),
          ltrDismissedColor: Colors.lightBlueAccent,
          rtlDismissedColor: Colors.redAccent,
          rtlOverlayIndent: 28,
          confirmDismiss: (direction) => Future.delayed(
            const Duration(seconds: 1),
            () => true,
          ),
          onDismissed: (_) => _removeItem(index),
          ltrOverlay: const _SlidableOverlay(
            title: 'Add',
            iconData: Icons.add_circle_outline,
          ),
          ltrOverlayDismissed: const _DismissedOverlay(title: 'Added'),
          rtlOverlay: const _SlidableOverlay(
            title: 'Delete',
            iconData: Icons.delete_forever,
          ),
          rtlOverlayDismissed: const _DismissedOverlay(title: 'Deleted'),
          child: Stack(
            children: [
              Container(
                height: 175,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Colors.greenAccent,
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                child: Text(
                  'Dismissible Tile ${_items[index] + 1}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                  ),
                ),
              ),
              Positioned(
                right: 12,
                bottom: 12,
                child: FilledButton(
                  onPressed: () => _startDismissAnimation(index),
                  child: const Text('Delete'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SlidableOverlay extends StatelessWidget {
  const _SlidableOverlay({
    required this.title,
    required this.iconData,
  });

  final String title;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          iconData,
          color: Colors.white,
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 22,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _DismissedOverlay extends StatelessWidget {
  const _DismissedOverlay({
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 22,
        color: Colors.white,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
