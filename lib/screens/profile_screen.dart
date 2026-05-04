import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import '../providers/user_provider.dart';
import '../theme/app_theme.dart';
import 'login_screen.dart';
import '../widgets/fade_transition_page.dart';
import 'personal_info_screen.dart';
import 'shipping_address_screen.dart';
import 'payment_method_screen.dart';
import 'settings_screen.dart';
import 'orders_screen.dart';
import 'favorites_screen.dart';

class ProfileScreen extends StatefulWidget {
  final bool isTab;
  const ProfileScreen({super.key, this.isTab = false});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with TickerProviderStateMixin {
  bool _showSuccess = false;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _handleLogout() async {
    setState(() {
      _showSuccess = true;
    });

    // Clear session
    context.read<UserProvider>().logout();

    // Show success animation for 2.5 seconds
    await Future.delayed(const Duration(milliseconds: 2500));

    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        FadeRoute(page: const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 600),
              switchInCurve: Curves.easeInOut,
              switchOutCurve: Curves.easeInOut,
              child: _showSuccess ? _buildLogoutSuccessScreen() : _buildProfileContent(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutSuccessScreen() {
    return Container(
      key: const ValueKey('logout_success'),
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFFF8C42), // Vibrant Orange
            const Color(0xFFFF5733).withOpacity(0.9),
            AppTheme.primaryColor,
          ],
        ),
      ),
      child: Stack(
        children: [
          // Background Decorative Elements
          ...List.generate(5, (index) {
            return Positioned(
              top: 100.0 * index + 50,
              left: index % 2 == 0 ? 30 : null,
              right: index % 2 != 0 ? 30 : null,
              child: Opacity(
                opacity: 0.1,
                child: Icon(
                  index % 3 == 0 ? Icons.restaurant : index % 3 == 1 ? Icons.local_pizza : Icons.bakery_dining,
                  size: 80,
                  color: Colors.white,
                ),
              ),
            );
          }),
          
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Heartbeat Animated Logo
                ScaleTransition(
                  scale: Tween<double>(begin: 1.0, end: 1.1).animate(
                    CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.3),
                          blurRadius: 40,
                          spreadRadius: 5,
                        )
                      ],
                    ),
                    child: Container(
                      height: 160,
                      width: 160,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(5),
                      child: ClipOval(
                        child: Image.asset('assets/logo.png', fit: BoxFit.cover),
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 60),
                
                // Glassmorphic Message Card
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.white.withOpacity(0.3)),
                      ),
                      child: const Column(
                        children: [
                          Text(
                            'Goodbye!',
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.5,
                            ),
                          ),
                          SizedBox(height: 15),
                          Text(
                            'You have successfully logged out.\nCome back soon for more delicious treats!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 80),
                
                // Custom Loading Bar
                SizedBox(
                  width: 250,
                  child: Column(
                    children: [
                      const Text(
                        'REDIRECTING',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: const LinearProgressIndicator(
                          backgroundColor: Colors.white12,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          minHeight: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(25),
      child: Column(
        children: [
          _buildTopBar(context),
          const SizedBox(height: 30),
          _buildProfileHeader(context),
          const SizedBox(height: 40),
          _buildProfileOption(Icons.person_outlined, 'Personal Info', () {
            Navigator.push(context, FadeRoute(page: const PersonalInfoScreen()));
          }),
          _buildProfileOption(Icons.shopping_bag_outlined, 'My Orders', () {
            Navigator.push(context, FadeRoute(page: const OrdersScreen()));
          }),
          _buildProfileOption(Icons.favorite_border, 'Favorites', () {
            Navigator.push(context, FadeRoute(page: const FavoritesScreen()));
          }),
          _buildProfileOption(Icons.location_on_outlined, 'Shipping Address', () {
            Navigator.push(context, FadeRoute(page: const ShippingAddressScreen()));
          }),
          _buildProfileOption(Icons.payment_outlined, 'Payment Method', () {
            Navigator.push(context, FadeRoute(page: const PaymentMethodScreen()));
          }),
          _buildProfileOption(Icons.settings_outlined, 'Settings', () {
            Navigator.push(context, FadeRoute(page: const SettingsScreen()));
          }),
          const SizedBox(height: 40),
          _buildLogoutButton(context),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (!widget.isTab)
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
                ],
              ),
              child: const Icon(Icons.arrow_back, size: 20),
            ),
          )
        else
          const SizedBox(width: 40),
        const Text(
          'Profile',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 40),
      ],
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    final user = context.watch<UserProvider>();
    final displayName = user.email.split('@').first;
    
    return Column(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
              child: const Icon(Icons.person, size: 60, color: AppTheme.primaryColor),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: AppTheme.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
              ),
            )
          ],
        ),
        const SizedBox(height: 15),
        Text(
          displayName,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(
          user.email,
          style: const TextStyle(color: AppTheme.textLight),
        ),
      ],
    );
  }

  Widget _buildProfileOption(IconData icon, String title, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10),
            ],
          ),
          child: Row(
            children: [
              Icon(icon, color: AppTheme.primaryColor),
              const SizedBox(width: 15),
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
              const Spacer(),
              const Icon(Icons.chevron_right, color: AppTheme.textLight),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () => _showLogoutDialog(context),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.redAccent),
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        child: const Text('Logout', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
      ),
    );
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
              _handleLogout();
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
