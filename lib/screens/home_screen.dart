import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/meal_model.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Meal> _meals = [];
  bool _isLoading = false;
  String? _errorMsg;
  String _selectedCategory = 'Chicken';

  final List<String> _categories = [
    'Chicken',
    'Beef',
    'Seafood',
    'Vegetarian',
    'Pasta',
    'Dessert'
  ];

  @override
  void initState() {
    super.initState();
    _fetchMeals();
  }

  Future<void> _fetchMeals() async {
    setState(() {
      _isLoading = true;
      _errorMsg = null;
    });
    try {
      final url = Uri.parse(
          'https://www.themealdb.com/api/json/v1/1/filter.php?c=$_selectedCategory');
      final response = await http.get(url).timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List meals = data['meals'] ?? [];
        setState(() {
          _meals = meals.map((m) => Meal.fromJson(m)).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMsg = 'Gagal memuat data.';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMsg = 'Koneksi gagal. Periksa internet.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 0, 4),
          child: Text('Resep $_selectedCategory',
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF212121))),
        ),
        SizedBox(
          height: 44,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, i) {
              final cat = _categories[i];
              final selected = cat == _selectedCategory;
              return ChoiceChip(
                label: Text(cat),
                selected: selected,
                selectedColor: const Color(0xFFFF9800),
                checkmarkColor: Colors.white,
                labelStyle: TextStyle(
                    color: selected ? Colors.white : const Color(0xFF424242),
                    fontSize: 13,
                    fontWeight: FontWeight.w500),
                backgroundColor: const Color(0xFFF5F5F5),
                side: BorderSide(
                    color: selected
                        ? const Color(0xFFFF9800)
                        : const Color(0xFFE0E0E0)),
                onSelected: (_) {
                  setState(() => _selectedCategory = cat);
                  _fetchMeals();
                },
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Color(0xFFFF9800)))
              : _errorMsg != null
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.wifi_off_outlined,
                              size: 48, color: Colors.grey),
                          const SizedBox(height: 12),
                          Text(_errorMsg!,
                              style: const TextStyle(color: Colors.grey)),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _fetchMeals,
                            style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFF9800)),
                            child: const Text('Coba Lagi',
                                style: TextStyle(color: Colors.white)),
                          )
                        ],
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.0,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: _meals.length,
                      itemBuilder: (context, i) => _MealCard(meal: _meals[i]),
                    ),
        ),
      ],
    );
  }
}

class _MealCard extends StatelessWidget {
  final Meal meal;
  const _MealCard({required this.meal});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => DetailScreen(mealId: meal.idMeal)),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar proporsi tetap
            AspectRatio(
              aspectRatio: 1.4, // lebar:tinggi gambar
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Image.network(
                  meal.strMealThumb,
                  fit: BoxFit.cover,
                  loadingBuilder: (_, child, progress) => progress == null
                      ? child
                      : Container(
                          color: const Color(0xFFF5F5F5),
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFFFF9800),
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                  errorBuilder: (_, __, ___) => Container(
                    color: const Color(0xFFF5F5F5),
                    child: const Icon(
                      Icons.broken_image_outlined,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
            // Nama resep — fixed height agar semua card rata
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                child: Text(
                  meal.strMeal,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF212121),
                    height: 1.4,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
