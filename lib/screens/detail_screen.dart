import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import '../models/meal_model.dart';

class DetailScreen extends StatefulWidget {
  final String mealId;
  const DetailScreen({super.key, required this.mealId});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  Meal? _meal;
  bool _isLoading = true;
  String? _errorMsg;
  bool _isFavorite = false;

  late Box<Meal> _favBox;

  @override
  void initState() {
    super.initState();
    _favBox = Hive.box<Meal>('favorites');
    _fetchDetail();
  }

  Future<void> _fetchDetail() async {
    setState(() { _isLoading = true; _errorMsg = null; });
    try {
      final url = Uri.parse('https://www.themealdb.com/api/json/v1/1/lookup.php?i=${widget.mealId}');
      final res = await http.get(url).timeout(const Duration(seconds: 15));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final List meals = data['meals'] ?? [];
        if (meals.isNotEmpty) {
          final meal = Meal.fromJson(meals[0]);
          final fav = _favBox.values.any((m) => m.idMeal == meal.idMeal);
          setState(() { _meal = meal; _isFavorite = fav; _isLoading = false; });
        }
      } else {
        setState(() { _errorMsg = 'Gagal memuat detail.'; _isLoading = false; });
      }
    } catch (e) {
      setState(() { _errorMsg = 'Koneksi gagal.'; _isLoading = false; });
    }
  }

  void _toggleFavorite() {
    if (_meal == null) return;
    setState(() {
      if (_isFavorite) {
        final key = _favBox.keys.firstWhere((k) => _favBox.get(k)?.idMeal == _meal!.idMeal, orElse: () => null);
        if (key != null) _favBox.delete(key);
        _isFavorite = false;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Dihapus dari favorit')));
      } else {
        _favBox.add(_meal!);
        _isFavorite = true;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ditambahkan ke favorit')));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFFF9800)))
          : _errorMsg != null
              ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Text(_errorMsg!),
                  const SizedBox(height: 12),
                  ElevatedButton(onPressed: _fetchDetail, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF9800)), child: const Text('Coba Lagi', style: TextStyle(color: Colors.white))),
                ]))
              : CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      expandedHeight: 260, pinned: true,
                      backgroundColor: const Color(0xFFFF9800), foregroundColor: Colors.white,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Image.network(_meal!.strMealThumb, fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(color: const Color(0xFFFFE0B2), child: const Icon(Icons.restaurant, size: 64, color: Color(0xFFFF9800)))),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_meal!.strMeal, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF212121))),
                            const SizedBox(height: 10),
                            Row(children: [
                              if (_meal!.strCategory != null) _TagChip(icon: Icons.category_outlined, label: _meal!.strCategory!),
                              if (_meal!.strArea != null) ...[const SizedBox(width: 8), _TagChip(icon: Icons.place_outlined, label: _meal!.strArea!)],
                            ]),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity, height: 48,
                              child: ElevatedButton.icon(
                                onPressed: _toggleFavorite,
                                icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_outline),
                                label: Text(_isFavorite ? 'Hapus dari Favorit' : 'Tambah ke Favorit'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _isFavorite ? const Color(0xFFE53935) : const Color(0xFFFF9800),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  elevation: 0,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text('Bahan-bahan', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF212121))),
                            const SizedBox(height: 10),
                            if (_meal!.ingredients != null)
                              ...(_meal!.ingredients!.map((ing) => Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Container(margin: const EdgeInsets.only(top: 6, right: 10), width: 7, height: 7,
                                      decoration: const BoxDecoration(color: Color(0xFFFF9800), shape: BoxShape.circle)),
                                  Expanded(child: Text(ing, style: const TextStyle(fontSize: 14, color: Color(0xFF424242)))),
                                ]),
                              ))),
                            const SizedBox(height: 20),
                            const Text('Cara Memasak', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF212121))),
                            const SizedBox(height: 10),
                            if (_meal!.strInstructions != null) ..._buildInstructions(_meal!.strInstructions!),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }

  List<Widget> _buildInstructions(String raw) {
    final steps = raw.split('\r\n').where((s) => s.trim().isNotEmpty).toList();
    return steps.asMap().entries.map((e) => Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          margin: const EdgeInsets.only(right: 10, top: 2),
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
          decoration: BoxDecoration(color: const Color(0x1AFF9800), borderRadius: BorderRadius.circular(6)),
          child: Text('${e.key + 1}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFFF9800))),
        ),
        Expanded(child: Text(e.value.trim(), style: const TextStyle(fontSize: 14, color: Color(0xFF424242), height: 1.5))),
      ]),
    )).toList();
  }
}

class _TagChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _TagChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: const Color(0x1FFF9800), borderRadius: BorderRadius.circular(20)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 13, color: const Color(0xFFFF9800)),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFFFF9800), fontWeight: FontWeight.w500)),
      ]),
    );
  }
}
