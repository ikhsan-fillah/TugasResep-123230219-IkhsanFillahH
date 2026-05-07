import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/meal_model.dart';
import 'detail_screen.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  late Box<Meal> _favBox;

  @override
  void initState() {
    super.initState();
    _favBox = Hive.box<Meal>('favorites');
  }

  void _deleteFavorite(dynamic key) {
    setState(() { _favBox.delete(key); });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _favBox.listenable(),
      builder: (context, Box<Meal> box, _) {
        final meals = box.toMap();
        if (meals.isEmpty) {
          return const Center(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.favorite_outline, size: 64, color: Color(0xFFE0E0E0)),
              SizedBox(height: 16),
              Text('Belum ada resep favorit', style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w500)),
              SizedBox(height: 6),
              Text('Tambahkan resep dari halaman Home', style: TextStyle(fontSize: 13, color: Colors.grey)),
            ]),
          );
        }
        final keys = meals.keys.toList();
        return GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, childAspectRatio: 0.82, crossAxisSpacing: 10, mainAxisSpacing: 10,
          ),
          itemCount: keys.length,
          itemBuilder: (context, i) {
            final key = keys[i];
            final meal = meals[key]!;
            return GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DetailScreen(mealId: meal.idMeal))).then((_) => setState(() {})),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, 2))],
                ),
                child: Stack(
                  children: [
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                        child: Image.network(meal.strMealThumb, height: 130, width: double.infinity, fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(height: 130, color: const Color(0xFFF5F5F5), child: const Icon(Icons.broken_image_outlined, color: Colors.grey))),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(meal.strMeal, maxLines: 2, overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF212121))),
                      ),
                    ]),
                    Positioned(
                      top: 6, right: 6,
                      child: GestureDetector(
                        onTap: () => _deleteFavorite(key),
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                          child: const Icon(Icons.close, size: 16, color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
