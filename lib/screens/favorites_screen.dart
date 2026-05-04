import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';
import '../models/food.dart';
import '../theme/app_theme.dart';
import 'detail_screen.dart';
import '../widgets/fade_transition_page.dart';

class FavoritesScreen extends StatelessWidget {
  final bool isTab;
  const FavoritesScreen({super.key, this.isTab = false});

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoritesProvider>().favorites;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  final food = favorites[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context, FadeRoute(page: DetailScreen(food: food)));
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 70,
                            width: 70,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppTheme.backgroundColor,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Hero(
                              tag: 'fav_${food.name}',
                              child: food.image.startsWith('http')
                                  ? Image.network(food.image, fit: BoxFit.contain)
                                  : Image.asset(food.image, fit: BoxFit.contain),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(food.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                Text(food.restaurant, style: const TextStyle(color: AppTheme.textLight, fontSize: 12)),
                                const SizedBox(height: 5),
                                Text('\$${food.price}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              ],
                            ),
                          ),
                          const Icon(Icons.favorite, color: Colors.redAccent),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (!isTab)
            _buildCircleBtn(Icons.arrow_back, () => Navigator.pop(context))
          else
            const SizedBox(width: 40),
          const Text(
            'My Favorites',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildCircleBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: Icon(icon, color: AppTheme.textDark, size: 20),
      ),
    );
  }
}
