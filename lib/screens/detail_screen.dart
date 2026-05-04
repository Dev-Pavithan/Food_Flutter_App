import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/food.dart';
import '../theme/app_theme.dart';
import 'cart_screen.dart';
import '../widgets/fade_transition_page.dart';
import '../providers/cart_provider.dart';
import '../providers/favorites_provider.dart';

class DetailScreen extends StatefulWidget {
  final Food food;
  const DetailScreen({super.key, required this.food});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int quantity = 1;
  String selectedSize = '8" - Medium';
  double basePrice = 0.0;
  late List<Map<String, dynamic>> sizes;
  
  List<Map<String, dynamic>> ingredients = [
    {'name': 'Chicken', 'weight': '250 gm', 'price': 1.40, 'isAdded': true},
    {'name': 'Mushroom', 'weight': '50 gm', 'price': 0.40, 'isAdded': false},
  ];

  @override
  void initState() {
    super.initState();
    basePrice = double.parse(widget.food.price);
    sizes = [
      {'label': '6" - Small', 'price': basePrice - 2.0},
      {'label': '8" - Medium', 'price': basePrice},
      {'label': '10" - Large', 'price': basePrice + 2.0},
    ];
  }

  double get totalPrice {
    double ingPrice = 0;
    for (var ing in ingredients) {
      if (ing['isAdded'] == true) {
        ingPrice += ing['price'] as double;
      }
    }
    return (basePrice + ingPrice) * quantity;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopBar(context),
              _buildMainImage(),
              Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTitleAndRating(),
                    const SizedBox(height: 25),
                    _buildSizeSelection(),
                    const SizedBox(height: 25),
                    _buildIngredientsSection(),
                    const SizedBox(height: 30),
                    _buildRelatedItems(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildCircleBtn(Icons.arrow_back, () => Navigator.pop(context)),
          Row(
            children: [
              Consumer<FavoritesProvider>(
                builder: (context, favProvider, child) {
                  final isFav = favProvider.isFavorite(widget.food);
                  return _buildCircleBtn(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    () => favProvider.toggleFavorite(widget.food),
                    color: isFav ? Colors.redAccent : AppTheme.textDark,
                  );
                },
              ),
              const SizedBox(width: 15),
              _buildCircleBtn(Icons.share_outlined, () => _showShareBottomSheet(context)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildCircleBtn(IconData icon, VoidCallback onTap, {Color color = AppTheme.textDark}) {
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
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }

  void _showShareBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Share via', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildShareOption(Icons.message, 'SMS', Colors.green),
                _buildShareOption(Icons.email, 'Email', Colors.red),
                _buildShareOption(Icons.copy, 'Copy Link', Colors.grey),
                _buildShareOption(Icons.more_horiz, 'More', AppTheme.primaryColor),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildShareOption(IconData icon, String label, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildMainImage() {
    return Container(
      height: 300,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Hero(
        tag: widget.food.name,
        child: widget.food.image.startsWith('http')
            ? Image.network(widget.food.image, fit: BoxFit.contain)
            : Image.asset(widget.food.image, fit: BoxFit.contain),
      ),
    );
  }

  Widget _buildTitleAndRating() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.food.name,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppTheme.textDark,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const CircleAvatar(
              radius: 12,
              backgroundColor: Colors.orange,
              child: Icon(Icons.restaurant, color: Colors.white, size: 12),
            ),
            const SizedBox(width: 8),
            Text(
              widget.food.restaurant,
              style: const TextStyle(color: AppTheme.textLight),
            ),
            const SizedBox(width: 15),
            const Icon(Icons.star, color: Colors.amber, size: 18),
            const SizedBox(width: 4),
            Text(
              '${widget.food.rating} (${widget.food.reviews})',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppTheme.textDark,
              ),
            ),
            const Icon(Icons.chevron_right, color: AppTheme.textLight),
          ],
        )
      ],
    );
  }

  Widget _buildSizeSelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: sizes.map((size) {
        bool isSelected = selectedSize == size['label'];
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedSize = size['label']!;
              basePrice = size['price'] as double;
            });
          },
          child: Container(
            width: 100,
            padding: const EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(
              color: isSelected ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: isSelected ? AppTheme.primaryColor : Colors.grey.shade300,
                width: 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      )
                    ]
                  : [],
            ),
            child: Column(
              children: [
                Icon(
                  isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                  color: isSelected ? AppTheme.primaryColor : Colors.grey.shade400,
                  size: 20,
                ),
                const SizedBox(height: 10),
                Text(
                  size['label'] as String,
                  style: TextStyle(
                    fontSize: 12,
                    color: isSelected ? AppTheme.textDark : AppTheme.textLight,
                  ),
                ),
                Text(
                  (size['price'] as double).toStringAsFixed(2),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                )
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildIngredientsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Add Ingredients',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.textDark,
          ),
        ),
        const SizedBox(height: 15),
        ...ingredients.asMap().entries.map((entry) {
          int idx = entry.key;
          Map<String, dynamic> ing = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _buildIngredientItem(
              ing['name'] as String,
              ing['weight'] as String,
              '+\$${(ing['price'] as double).toStringAsFixed(2)}',
              ing['isAdded'] as bool,
              (bool? value) {
                setState(() {
                  ingredients[idx]['isAdded'] = value ?? false;
                });
              },
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildIngredientItem(String name, String weight, String price, bool isAdded, ValueChanged<bool?> onChanged) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.backgroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.fastfood_outlined, color: AppTheme.primaryColor),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '$weight  $price',
                  style: const TextStyle(color: AppTheme.textLight, fontSize: 12),
                )
              ],
            ),
          ),
          Checkbox(
            value: isAdded,
            onChanged: onChanged,
            activeColor: AppTheme.primaryColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          )
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                _buildQtyBtn(Icons.remove, () {
                  if (quantity > 1) setState(() => quantity--);
                }),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    '$quantity',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                _buildQtyBtn(Icons.add, () => setState(() => quantity++)),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                context.read<CartProvider>().addToCart(widget.food, quantity, selectedSize);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${widget.food.name} added to cart',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                    backgroundColor: const Color(0xFF65B773), // Exact green from image
                    behavior: SnackBarBehavior.floating,
                    margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              child: Text('Add to Cart  •  \$${totalPrice.toStringAsFixed(2)}'),
            ),
          )
        ],
      ),
    );
  }


  Widget _buildQtyBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppTheme.textDark, size: 20),
      ),
    );
  }

  Widget _buildRelatedItems() {
    final relatedFoods = bestSellers.where((f) => f.name != widget.food.name).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'You might also like',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textDark),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.zero,
            itemCount: relatedFoods.length,
            itemBuilder: (context, index) {
              final food = relatedFoods[index];
              return GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    FadeRoute(page: DetailScreen(food: food)),
                  );
                },
                child: Container(
                  width: 140,
                  margin: const EdgeInsets.only(right: 15),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Center(
                          child: food.image.startsWith('http')
                          ? Image.network(food.image, fit: BoxFit.contain)
                          : Image.asset(food.image, fit: BoxFit.contain),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(food.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12), maxLines: 1),
                      Text('\$${food.price}', style: const TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
