import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../../services/product_service.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final ProductService _service = ProductService();
  List<Product> _products = [];
  bool _loading = true;
  String? _error;
  String _search = '';

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final products = await _service.getProducts();
      if (!mounted) return;
      setState(() => _products = products);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  List<Product> get _filteredProducts => _products
      .where((p) => p.name.toLowerCase().contains(_search.toLowerCase()) ||
          p.category.toLowerCase().contains(_search.toLowerCase()))
      .toList();

  Future<void> _showProductDialog({Product? product}) async {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: product?.name ?? '');
    final categoryController =
        TextEditingController(text: product?.category ?? 'Coffee');
    final priceController =
        TextEditingController(text: product?.price.toStringAsFixed(2) ?? '');
    final editing = product != null;

    final saved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(editing ? 'Edit product' : 'Add product'),
        content: SizedBox(
          width: 420,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Product name'),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Enter a name' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: categoryController,
                  decoration: const InputDecoration(labelText: 'Category'),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Enter a category' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: priceController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'Price (៛)'),
                  validator: (v) {
                    final value = double.tryParse(v ?? '');
                    if (value == null || value <= 0) return 'Enter a price above 0';
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                final item = Product(
                  id: product?.id,
                  name: nameController.text.trim(),
                  category: categoryController.text.trim(),
                  price: double.parse(priceController.text.trim()),
                );
                try {
                  if (editing) {
                    await _service.updateProduct(item);
                  } else {
                    await _service.createProduct(item);
                  }
                  if (dialogContext.mounted) Navigator.pop(dialogContext, true);
                } catch (e) {
                  if (!dialogContext.mounted) return;
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    SnackBar(content: Text(e.toString())),
                  );
                }
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );

    nameController.dispose();
    categoryController.dispose();
    priceController.dispose();
    if (saved == true) _loadProducts();
  }

  Future<void> _deactivate(Product product) async {
    if (product.id == null) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Deactivate product?'),
        content: Text('Hide "${product.name}" from the active product list?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Deactivate'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await _service.deactivateProduct(product.id!);
      await _loadProducts();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    final products = _filteredProducts;
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            extended: MediaQuery.sizeOf(context).width > 900,
            backgroundColor: const Color(0xFF30251F),
            selectedIndex: 1,
            unselectedIconTheme: const IconThemeData(color: Colors.white70),
            selectedIconTheme: const IconThemeData(color: Color(0xFFE8C39E)),
            unselectedLabelTextStyle: const TextStyle(color: Colors.white70),
            selectedLabelTextStyle: const TextStyle(color: Color(0xFFE8C39E)),
            leading: const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Icon(Icons.coffee, color: Color(0xFFE8C39E), size: 34),
            ),
            destinations: const [
              NavigationRailDestination(
                  icon: Icon(Icons.dashboard_outlined), label: Text('Dashboard')),
              NavigationRailDestination(
                  icon: Icon(Icons.local_cafe_outlined), label: Text('Products')),
              NavigationRailDestination(
                  icon: Icon(Icons.point_of_sale), label: Text('POS')),
              NavigationRailDestination(
                  icon: Icon(Icons.inventory_2_outlined), label: Text('Inventory')),
              NavigationRailDestination(
                  icon: Icon(Icons.bar_chart), label: Text('Reports')),
            ],
            onDestinationSelected: (index) {
              if (index != 1) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('This module will be added in the next development step.')),
                );
              }
            },
          ),
          Expanded(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Coffee Shop Manager',
                                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      )),
                              const SizedBox(height: 4),
                              Text('Manage your menu and product prices',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: Colors.black54,
                                      )),
                            ],
                          ),
                        ),
                        FilledButton.icon(
                          onPressed: () => _showProductDialog(),
                          icon: const Icon(Icons.add),
                          label: const Text('Add product'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        _SummaryCard(
                          title: 'Active products',
                          value: _products.length.toString(),
                          icon: Icons.local_cafe,
                        ),
                        const _SummaryCard(
                          title: 'Sales today',
                          value: '—',
                          icon: Icons.payments_outlined,
                          note: 'Available after POS is built',
                        ),
                        const _SummaryCard(
                          title: 'Low stock',
                          value: '—',
                          icon: Icons.inventory_2_outlined,
                          note: 'Available after inventory is built',
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      decoration: const InputDecoration(
                        hintText: 'Search products or categories...',
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (value) => setState(() => _search = value),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        child: _loading
                            ? const Center(child: CircularProgressIndicator())
                            : _error != null
                                ? Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(24),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.cloud_off, size: 42),
                                          const SizedBox(height: 12),
                                          Text(_error!, textAlign: TextAlign.center),
                                          const SizedBox(height: 12),
                                          FilledButton(
                                            onPressed: _loadProducts,
                                            child: const Text('Retry'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : products.isEmpty
                                    ? const Center(
                                        child: Text('No products yet. Select “Add product” to get started.'),
                                      )
                                    : SingleChildScrollView(
                                        child: SizedBox(
                                          width: double.infinity,
                                          child: DataTable(
                                            columns: const [
                                              DataColumn(label: Text('Product')),
                                              DataColumn(label: Text('Category')),
                                              DataColumn(label: Text('Price')),
                                              DataColumn(label: Text('Actions')),
                                            ],
                                            rows: products.map((product) {
                                              return DataRow(cells: [
                                                DataCell(Text(product.name)),
                                                DataCell(Chip(label: Text(product.category))),
                                                DataCell(Text('${product.price.toStringAsFixed(0)} ៛')),
                                                DataCell(Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    IconButton(
                                                      tooltip: 'Edit',
                                                      onPressed: () => _showProductDialog(product: product),
                                                      icon: const Icon(Icons.edit_outlined),
                                                    ),
                                                    IconButton(
                                                      tooltip: 'Deactivate',
                                                      onPressed: () => _deactivate(product),
                                                      icon: const Icon(Icons.delete_outline),
                                                    ),
                                                  ],
                                                )),
                                              ]);
                                            }).toList(),
                                          ),
                                        ),
                                      ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final String? note;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    this.note,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 230,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 25, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 14),
              Text(title, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 4),
              Text(value,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      )),
              if (note != null) ...[
                const SizedBox(height: 4),
                Text(note!, style: Theme.of(context).textTheme.bodySmall),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
