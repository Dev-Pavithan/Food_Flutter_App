import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class OrdersScreen extends StatelessWidget {
  final bool isTab;
  const OrdersScreen({super.key, this.isTab = false});

  @override
  Widget build(BuildContext context) {
    final orders = [
      {'id': '#44521', 'status': 'Delivered', 'items': 'Melting Cheese Pizza, Drinks', 'date': 'Today, 02:30 PM', 'price': '\$15.99'},
      {'id': '#44102', 'status': 'Delivered', 'items': 'Cheese burger (x2)', 'date': 'Yesterday, 11:45 AM', 'price': '\$9.98'},
      {'id': '#43990', 'status': 'Cancelled', 'items': 'Chicken Salad', 'date': '12 Dec, 07:15 PM', 'price': '\$4.56'},
    ];

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  final isDelivered = order['status'] == 'Delivered';

                  return Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Order ${order['id']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: isDelivered ? AppTheme.primaryColor.withOpacity(0.1) : Colors.redAccent.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                order['status']!,
                                style: TextStyle(
                                  color: isDelivered ? AppTheme.primaryColor : Colors.redAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(order['items']!, style: const TextStyle(color: AppTheme.textDark)),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(order['date']!, style: const TextStyle(color: AppTheme.textLight, fontSize: 12)),
                            Text(order['price']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          ],
                        )
                      ],
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
            'My Orders',
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
