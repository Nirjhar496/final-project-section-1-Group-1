import 'package:flutter/material.dart';
import 'package:inventory/models/product.dart';
import 'package:inventory/providers/inventory_provider.dart';
import 'package:provider/provider.dart';

class AddEditProductSheet extends StatefulWidget {
  final Product? product;

  const AddEditProductSheet({super.key, this.product});

  @override
  State<AddEditProductSheet> createState() => _AddEditProductSheetState();
}

class _AddEditProductSheetState extends State<AddEditProductSheet> {
  final _formKey = GlobalKey<FormState>();
  late Product _product;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _product = widget.product ?? Product.initial();
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    setState(() => _isLoading = true);

    final provider = Provider.of<InventoryProvider>(context, listen: false);
    try {
      if (widget.product != null) {
        await provider.updateProduct(_product);
      } else {
        await provider.addProduct(_product);
      }
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${error.toString()}'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.product != null;
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 24,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                isEditing ? 'Edit Product' : 'Add New Product',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),
              TextFormField(
                initialValue: _product.name,
                decoration: const InputDecoration(labelText: 'Product Name'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a name.' : null,
                onSaved: (value) => _product = _product.copyWith(name: value),
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _product.quantity.toString(),
                decoration: const InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || int.tryParse(value) == null) {
                    return 'Please enter a valid quantity.';
                  }
                  return null;
                },
                onSaved: (value) =>
                    _product = _product.copyWith(quantity: int.parse(value!)),
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _product.category,
                decoration: const InputDecoration(labelText: 'Category'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a category.' : null,
                onSaved: (value) =>
                    _product = _product.copyWith(category: value),
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _product.imageUrl,
                decoration: const InputDecoration(labelText: 'Image URL'),
                onSaved: (value) =>
                    _product = _product.copyWith(imageUrl: value),
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton.icon(
                      onPressed: _saveForm,
                      icon: Icon(isEditing ? Icons.save_alt : Icons.add),
                      label: Text(isEditing ? 'Update Product' : 'Add Product'),
                    ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
