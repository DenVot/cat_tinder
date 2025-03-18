import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'services/cat_service.dart';
import 'models/cat.dart';
import 'screens/cat_detail_screen.dart'; // Импортируем новый экран

void main() {
  runApp(const MyApp());
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
  int _likeCount = 0;

  @override
  void initState() {
    super.initState();
    _catFuture = CatService().getRandomCat();
  }

  void _loadNewCat() {
    setState(() {
      _catFuture = CatService().getRandomCat();
    });
  }

  void _onLike() {
    setState(() {
      _likeCount++;
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Кототиндер'), centerTitle: true),
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
                          _onLike();
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
                'Лайков: $_likeCount',
                style: const TextStyle(fontSize: 24),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                LikeButton(onTap: _onDislike, icon: Icons.close),
                LikeButton(onTap: _onLike, icon: Icons.favorite),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class LikeButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;

  const LikeButton({super.key, required this.onTap, required this.icon});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(16),
      ),
      child: Icon(icon, size: 32),
    );
  }
}
