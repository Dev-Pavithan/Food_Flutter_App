import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../models/food.dart';
import '../theme/app_theme.dart';
import 'detail_screen.dart';
import 'cart_screen.dart';
import 'login_screen.dart';
import 'profile_screen.dart';
import 'search_screen.dart';
import 'favorites_screen.dart';
import 'orders_screen.dart';
import '../widgets/fade_transition_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _activeCategoryIndex = 0; // Default to All
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Simulate real-time data loading
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 25),
              _buildCategories(),
              const SizedBox(height: 25),
              _buildOfferBanner(),
              const SizedBox(height: 25),
              _buildSectionTitle('Best Sellers', () {}),
              const SizedBox(height: 15),
              _isLoading ? _buildSkeletonGrid() : _buildFoodGrid(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final displayName = userProvider.isGuest 
        ? 'Guest User' 
        : userProvider.email.split('@').first;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hello 👋',
              style: TextStyle(color: AppTheme.textLight, fontSize: 16),
            ),
            Text(
              displayName,
              style: const TextStyle(
                color: AppTheme.textDark,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Row(
          children: [
            _buildIconBtn(Icons.search, () {
              Navigator.push(context, FadeRoute(page: SearchScreen()));
            }),
            _buildIconBtn(Icons.person_outlined, () => _handleProtectedNavigation(context, ProfileScreen())),
          ],
        )
      ],
    );
  }

  Widget _buildIconBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: Icon(icon, color: AppTheme.textDark),
      ),
    );
  }


  Widget _buildCategories() {
    final categories = [
      {'name': 'All', 'icon': '🍽️'},
      {'name': 'Pizza', 'icon': '🍕'},
      {'name': 'Burgers', 'icon': '🍔'},
      {'name': 'Sushi', 'icon': '🍣'},
      {'name': 'Salads', 'icon': '🥗'},
      {'name': 'Drinks', 'icon': '🍹'},
    ];

    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 20),
        itemBuilder: (context, index) {
          bool isActive = _activeCategoryIndex == index;
          return GestureDetector(
            onTap: () => setState(() => _activeCategoryIndex = index),
            child: Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: isActive ? AppTheme.primaryColor : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: isActive 
                            ? AppTheme.primaryColor.withOpacity(0.3) 
                            : Colors.black.withOpacity(0.05),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      )
                    ],
                  ),
                  child: Text(
                    categories[index]['icon']!,
                    style: TextStyle(
                      fontSize: isActive ? 28 : 24,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  categories[index]['name']!,
                  style: TextStyle(
                    fontSize: 12,
                    color: isActive ? AppTheme.primaryColor : AppTheme.textLight,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOfferBanner() {
    return Container(
      width: double.infinity,
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        image: const DecorationImage(
          image: AssetImage('assets/banner.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: LinearGradient(
            colors: [
              Colors.black.withOpacity(0.6),
              Colors.transparent,
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'New Year Offer',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            const Text(
              '30% OFF',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              '16 - 31 Dec',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Get Now',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, VoidCallback onTap) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.textDark,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(context, FadeRoute(page: const SearchScreen()));
          },
          child: const Text(
            'See All',
            style: TextStyle(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSkeletonGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 4,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
      ),
      itemBuilder: (context, index) => _buildSkeletonItem(),
    );
  }

  Widget _buildSkeletonItem() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(height: 12, width: 100, color: Colors.grey.shade100),
          const SizedBox(height: 8),
          Container(height: 10, width: 60, color: Colors.grey.shade100),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(height: 15, width: 40, color: Colors.grey.shade100),
              Container(height: 25, width: 25, decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildFoodGrid(BuildContext context) {
    final categories = ['All', 'Pizza', 'Burgers', 'Sushi', 'Salads', 'Drinks'];
    final filteredFoods = _activeCategoryIndex == 0
        ? bestSellers
        : bestSellers.where((f) => f.category == categories[_activeCategoryIndex]).toList();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filteredFoods.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      itemBuilder: (context, index) {
        final food = filteredFoods[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              FadeRoute(page: DetailScreen(food: food)),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Hero(
                    tag: food.name,
                    child: Center(
                      child: food.image.startsWith('http')
                          ? Image.network(food.image, fit: BoxFit.contain)
                          : Image.asset(food.image, fit: BoxFit.contain),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  food.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '\$${food.price}',
                  style: const TextStyle(
                    color: AppTheme.textLight,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.local_fire_department,
                        color: Colors.orange, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      food.calories,
                      style: const TextStyle(fontSize: 10),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.access_time,
                            color: AppTheme.textLight, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          food.time,
                          style: const TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.add, color: Colors.white, size: 16),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildNavItem(Icons.home, 'Home', true, () {}),
          _buildNavItem(Icons.favorite_border, '', false, () {
            _handleProtectedNavigation(context, FavoritesScreen());
          }),
          _buildNavItem(Icons.shopping_cart_outlined, '', false, () {
            Navigator.push(context, FadeRoute(page: CartScreen()));
          }),
          _buildNavItem(Icons.receipt_long_outlined, '', false, () {
            _handleProtectedNavigation(context, OrdersScreen());
          }),
          _buildNavItem(Icons.person_outlined, '', false, () => _handleProtectedNavigation(context, ProfileScreen())),
        ],
      ),
    );
  }

  void _handleProtectedNavigation(BuildContext context, Widget screen) {
    final userProvider = context.read<UserProvider>();
    if (userProvider.isGuest) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Login Required'),
          content: const Text('Please login to access this feature.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(context, FadeRoute(page: LoginScreen()));
              },
              child: const Text('Login', style: TextStyle(color: AppTheme.primaryColor)),
            ),
          ],
        ),
      );
    } else {
      Navigator.push(context, FadeRoute(page: screen));
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(context, FadeRoute(page: LoginScreen()));
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.primaryColor,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: isActive
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(icon, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            )
          : Icon(icon, color: AppTheme.textLight, size: 24),
    );
  }
}

