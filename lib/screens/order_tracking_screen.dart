import 'package:flutter/material.dart';
import 'dart:async';
import '../theme/app_theme.dart';
import 'main_screen.dart';
import '../widgets/fade_transition_page.dart';

class OrderTrackingScreen extends StatefulWidget {
  const OrderTrackingScreen({super.key});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> with TickerProviderStateMixin {
  int _currentStep = 1;
  late AnimationController _courierController;
  late Animation<Offset> _courierAnimation;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    
    // Courier Movement Simulation
    _courierController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat();

    _courierAnimation = Tween<Offset>(
      begin: const Offset(0.2, 0.3),
      end: const Offset(0.7, 0.6),
    ).animate(CurvedAnimation(
      parent: _courierController,
      curve: Curves.linear,
    ));

    // Pulse effect for destination
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    // Progress simulation
    Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted && _currentStep < 3) {
        setState(() {
          _currentStep++;
        });
      } else if (_currentStep >= 3) {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _courierController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Stack(
        children: [
          _buildRealTimeMap(),
          _buildTopBar(context),
          _buildBottomCard(),
        ],
      ),
    );
  }

  Widget _buildRealTimeMap() {
    return Stack(
      children: [
        // Map Background
        Container(
          height: MediaQuery.of(context).size.height * 0.7,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: NetworkImage('https://images.unsplash.com/photo-1524661135-423995f22d0b?auto=format&fit=crop&q=80&w=1000'), // High quality city map
              fit: BoxFit.cover,
            ),
          ),
        ),
        
        // Animated Route Line (Stylized)
        Positioned.fill(
          child: CustomPaint(
            painter: RoutePainter(),
          ),
        ),

        // Destination Marker with Pulse
        Positioned(
          left: MediaQuery.of(context).size.width * 0.7,
          top: MediaQuery.of(context).size.height * 0.42,
          child: ScaleTransition(
            scale: Tween<double>(begin: 1.0, end: 1.5).animate(
              CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
            ),
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Container(
                  height: 12,
                  width: 12,
                  decoration: const BoxDecoration(
                    color: AppTheme.primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
        ),

        // Moving Courier
        AnimatedBuilder(
          animation: _courierAnimation,
          builder: (context, child) {
            return Positioned(
              left: MediaQuery.of(context).size.width * _courierAnimation.value.dx,
              top: MediaQuery.of(context).size.height * 0.7 * _courierAnimation.value.dy,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
                ),
                child: const Icon(Icons.delivery_dining, color: AppTheme.primaryColor, size: 24),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildCircleBtn(Icons.arrow_back, () {
              Navigator.pushAndRemoveUntil(
                context,
                FadeRoute(page: const MainScreen(initialIndex: 3)),
                (route) => false,
              );
            }),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
              ),
              child: const Row(
                children: [
                  Icon(Icons.gps_fixed, color: AppTheme.primaryColor, size: 16),
                  SizedBox(width: 8),
                  Text(
                    'Live Tracking',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ],
              ),
            ),
            _buildCircleBtn(Icons.help_outline, () {}),
          ],
        ),
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
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
        ),
        child: Icon(icon, color: AppTheme.textDark, size: 20),
      ),
    );
  }

  Widget _buildBottomCard() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.45,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 30, offset: Offset(0, -10))],
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              // Pull Handle
              Container(
                width: 40,
                height: 5,
                margin: const EdgeInsets.only(bottom: 25),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundColor,
                      borderRadius: BorderRadius.circular(20),
                      image: const DecorationImage(
                        image: NetworkImage('https://images.unsplash.com/photo-1599566150163-29194dcaad36?auto=format&fit=crop&q=80&w=200'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Robert Fox', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        Text('Courier • 4.9 ★', style: TextStyle(color: AppTheme.textLight, fontSize: 14)),
                      ],
                    ),
                  ),
                  _buildActionBtn(Icons.call, Colors.green),
                  const SizedBox(width: 12),
                  _buildActionBtn(Icons.message, AppTheme.primaryColor),
                ],
              ),
              const Divider(height: 50),
              _buildStepItem(Icons.receipt_long, 'Order Confirmed', '12:45 PM', true),
              _buildStepItem(Icons.restaurant, 'Preparing Food', '1:05 PM', _currentStep >= 1),
              _buildStepItem(Icons.delivery_dining, 'Out for Delivery', 'On the way', _currentStep >= 2),
              _buildStepItem(Icons.home, 'Delivered', 'Estimated 1:30 PM', _currentStep >= 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionBtn(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Icon(icon, color: color, size: 22),
    );
  }

  Widget _buildStepItem(IconData icon, String title, String time, bool isCompleted) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isCompleted ? AppTheme.primaryColor : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: isCompleted ? Colors.white : Colors.grey, size: 20),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: isCompleted ? AppTheme.textDark : AppTheme.textLight,
                  ),
                ),
                Text(
                  isCompleted ? 'Completed' : 'Upcoming',
                  style: TextStyle(
                    color: isCompleted ? AppTheme.primaryColor : AppTheme.textLight,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: const TextStyle(color: AppTheme.textLight, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class RoutePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.primaryColor.withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(size.width * 0.2, size.height * 0.3)
      ..lineTo(size.width * 0.4, size.height * 0.35)
      ..lineTo(size.width * 0.5, size.height * 0.5)
      ..lineTo(size.width * 0.7, size.height * 0.6);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
