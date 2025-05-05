import 'package:flutter/material.dart';

class DogFoodStoreScreen extends StatelessWidget {
  final List<Map<String, String>> foodItems = [
  {
    'name': 'Premium Dog Food',
    'description': 'High-quality dog food for all breeds',
    'price': '\$25.99',
    'image': 'assets/images/pre_food.jpg', // local asset path
  },
  {
    'name': 'Organic Dog Treats',
    'description': 'Healthy and organic treats for your dog',
    'price': '\$14.49',
    'image': 'assets/images/organic.jpg', // use another local image here
  },
  {
    'name': 'Grain-Free Chicken Meal',
    'description': 'Delicious grain-free dog food made with real chicken',
    'price': '\$29.99',
    'image': 'assets/images/chicken_meal.jpg',
  },
   {
    'name': 'Beef & Brown Rice Formula',
    'description': 'Nutritious blend of beef and brown rice for active dogs',
    'price': '\$27.50',
    'image': 'assets/images/beef_rice.jpg',
  },
  {
    'name': 'Puppy Starter Pack',
    'description': 'Complete nutrition for growing puppies',
    'price': '\$22.00',
    'image': 'assets/images/puppy_starter.jpg',
  },
  {
    'name': 'Senior Dog Wellness Mix',
    'description': 'Tailored nutrition for senior dogs with joint support',
    'price': '\$31.99',
    'image': 'assets/images/senior_dog.jpg',
  },
  {
    'name': 'Lamb & Sweet Potato Recipe',
    'description': 'Hypoallergenic formula with lamb and sweet potato',
    'price': '\$28.25',
    'image': 'assets/images/lamb_potato.jpg',
  },

];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Food Center",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF4CAF50), // Green theme
        centerTitle: true,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: ListView.builder(
        itemCount: foodItems.length,
        itemBuilder: (context, index) {
          final item = foodItems[index];
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 6.0,
            ),
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.all(12.0),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
  item['image']!,
  width: 60,
  height: 60,
  fit: BoxFit.cover,
  errorBuilder: (context, error, stackTrace) {
    return Icon(Icons.broken_image);
  },
),

                ),

                title: Text(
                  item['name']!,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item['description']!),
                    SizedBox(height: 4),
                    Text(
                      item['price']!,
                      style: TextStyle(
                        color: Colors.green[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(Icons.add_shopping_cart, color: Color(0xFF4CAF50)),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Added ${item['name']} to cart')),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
