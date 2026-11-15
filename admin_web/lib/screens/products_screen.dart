import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _mrpController = TextEditingController();
  final _unitController = TextEditingController();
  final _stockController = TextEditingController();

  Future<void> _addProduct() async {
    if (_nameController.text.isEmpty || _priceController.text.isEmpty) return;

    await FirebaseFirestore.instance.collection('products').add({
      'name': _nameController.text.trim(),
      'price': double.tryParse(_priceController.text) ?? 0,
      'mrp': double.tryParse(_mrpController.text) ?? 0,
      'unit': _unitController.text.trim().isEmpty
          ? '1 unit'
          : _unitController.text.trim(),
      'stock': int.tryParse(_stockController.text) ?? 0,
      'isActive': true,
      'imageUrls': [],
      'categoryId': '',
      'description': '',
      'tags': [],
      'createdAt': FieldValue.serverTimestamp(),
    });

    _nameController.clear();
    _priceController.clear();
    _mrpController.clear();
    _unitController.clear();
    _stockController.clear();

    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Product added')));
    }
  }

  Future<void> _deleteProduct(String id) async {
    await FirebaseFirestore.instance.collection('products').doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Products'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      body: Row(
        children: [
          // Add form
          SizedBox(
            width: 320,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('Add Product',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                        labelText: 'Name', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        labelText: 'Price', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _mrpController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        labelText: 'MRP', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _unitController,
                    decoration: const InputDecoration(
                        labelText: 'Unit (e.g. 1 kg)',
                        border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _stockController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        labelText: 'Stock', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _addProduct,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E7D32),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Add Product'),
                  ),
                ],
              ),
            ),
          ),
          const VerticalDivider(),
          // List
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('products')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final docs = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (_, i) {
                    final data = docs[i].data() as Map<String, dynamic>;
                    return ListTile(
                      title: Text(data['name'] ?? ''),
                      subtitle: Text(
                          '₹${data['price']} • Stock: ${data['stock']} • ${data['unit']}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteProduct(docs[i].id),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
