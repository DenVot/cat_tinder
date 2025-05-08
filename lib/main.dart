import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get_it/get_it.dart';
import 'services/cat_service.dart';
import 'models/cat.dart';
import 'screens/cat_detail_screen.dart';
import 'screens/liked_cats_screen.dart';
import 'package:provider/provider.dart';
import 'buttons/like_button.dart';
import 'states/cat_state.dart';
import 'dep_inj.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

void main() {
  setupDeps();
  runApp(
    ChangeNotifierProvider(
      create: (_) => GetIt.instance<CatState>(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Кототиндер',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const CatTinderScreen(),
    );
  }
}

class CatTinderScreen extends StatefulWidget {
  const CatTinderScreen({super.key});

  @override
  CatTinderScreenState createState() => CatTinderScreenState();
}

class CatTinderScreenState extends State<CatTinderScreen> {
  late Future<Cat> _catFuture;
  bool _catLoaded = false;
  final CatService _catService = GetIt.instance<CatService>();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _catFuture = _catService.getRandomCat();
    _catFuture.whenComplete(() => _catLoaded = true);

    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      ConnectivityResult result,
    ) {
      if (mounted) {
        final isConnected = result != ConnectivityResult.none;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isConnected ? 'Соединение восстановлено' : 'Нет интернета',
            ),
            backgroundColor: isConnected ? Colors.green : Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    });
  }

  void _loadNewCat() {
    setState(() {
      _catFuture = _catService.getRandomCat();
      _catFuture.whenComplete(() => _catLoaded = true);
    });
  }

  void _onLike(Cat cat) {
    final catState = Provider.of<CatState>(context, listen: false);
    catState.addLikedCat(cat);
    _loadNewCat();
  }

  void _onDislike() {
    _loadNewCat();
  }

  void _showCatDetails(Cat cat) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CatDetailScreen(cat: cat)),
    );
  }

  void _openLikedCatsScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LikedCatsScreen()),
    );
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel(); // Не забываем отписаться
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Кототиндер'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: _openLikedCatsScreen,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: FutureBuilder<Cat>(
                future: _catFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Ошибка: ${snapshot.error}');
                  } else if (!snapshot.hasData) {
                    return const Text('Нет данных');
                  } else {
                    final cat = snapshot.data!;
                    return GestureDetector(
                      onTap: () => _showCatDetails(cat),
                      onHorizontalDragEnd: (details) {
                        if (details.primaryVelocity! > 0) {
                          _onLike(cat);
                        } else if (details.primaryVelocity! < 0) {
                          _onDislike();
                        }
                      },
                      child: CachedNetworkImage(
                        imageUrl: cat.url,
                        placeholder:
                            (context, url) => const CircularProgressIndicator(),
                        errorWidget:
                            (context, url, error) => const Icon(Icons.error),
                        fit: BoxFit.cover,
                      ),
                    );
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Лайков: ${Provider.of<CatState>(context).likedCats.length}',
                style: const TextStyle(fontSize: 24),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                LikeButton(onTap: _onDislike, icon: Icons.close),
                LikeButton(
                  onTap: () async {
                    if (_catLoaded) {
                      final cat = await _catFuture;
                      _onLike(cat);
                    }
                  },
                  icon: Icons.favorite,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
