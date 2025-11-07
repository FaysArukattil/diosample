import 'package:flutter/material.dart';
import 'package:diosample/service/apiservice.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Apiservice apiservice = Apiservice();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("All Products"), centerTitle: true),
      body: FutureBuilder(
        future: apiservice.getproductsall(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.data!.isEmpty) {
            return const Center(child: Text('No Products Found'));
          }

          final products = snapshot.data!.data;

          return ListView.builder(
            itemCount: products!.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: product.imageUrl != null
                        ? NetworkImage(product.imageUrl!)
                        : NetworkImage(
                            'https://via.placeholder.com/150',
                          ), // fallback image
                  ),
                  title: Text(product.name ?? 'Unnamed'),
                  subtitle: Text(
                    product.description ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Text(
                    '₹${product.price}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
