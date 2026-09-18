import 'package:flutter/material.dart';
import '../app_state.dart';

class MedicationScreen extends StatefulWidget {
  const MedicationScreen({super.key});

  @override
  State<MedicationScreen> createState() => _MedicationScreenState();
}

class _MedicationScreenState extends State<MedicationScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  final List<Map<String, String>> _drugs = [
    {'name': 'Paracetamol 500mg', 'price': '₦1,200', 'details': 'Pain relief, fever reducer.'},
    {'name': 'Amoxicillin 250mg', 'price': '₦1,800', 'details': 'Antibiotic for infections.'},
    {'name': 'Metformin 500mg', 'price': '₦2,500', 'details': 'Blood sugar regulation.'},
    {'name': 'Lisinopril 10mg', 'price': '₦2,000', 'details': 'Blood pressure control.'},
    {'name': 'Vitamin D 1000 IU', 'price': '₦950', 'details': 'Bone and immune support.'},
    {'name': 'Ibuprofen 200mg', 'price': '₦1,100', 'details': 'Inflammation and pain relief.'},
    {'name': 'Cefalexin 500mg', 'price': '₦2,100', 'details': 'Broad-spectrum antibiotic.'},
    {'name': 'Omeprazole 20mg', 'price': '₦1,700', 'details': 'Stomach acid control and ulcer relief.'},
    {'name': 'Salbutamol Inhaler', 'price': '₦3,400', 'details': 'Bronchodilator for asthma and wheezing.'},
    {'name': 'Atorvastatin 20mg', 'price': '₦2,800', 'details': 'Cholesterol management.'},
    {'name': 'Amlodipine 5mg', 'price': '₦2,300', 'details': 'Helps control high blood pressure.'},
    {'name': 'Loratadine 10mg', 'price': '₦1,050', 'details': 'Seasonal allergy relief.'},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    final drugs = state.availableMedications;

    return AnimatedBuilder(
      animation: state,
      builder: (context, _) {
        final filtered = drugs.where((drug) {
          final query = _searchQuery.toLowerCase();
          return drug['name']!.toLowerCase().contains(query) || drug['details']!.toLowerCase().contains(query);
        }).toList();

        return Scaffold(
          appBar: AppBar(title: const Text('Medication Shop')),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    labelText: 'Search medication',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) => setState(() => _searchQuery = value),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView(
                    children: [
                      if (filtered.isEmpty)
                        const Center(child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: Text('No medication found. Adjust your search or try again later.'),
                        ))
                      else ...filtered.map((drug) {
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          child: ListTile(
                            title: Text(drug['name']!),
                            subtitle: Text('${drug['details']}\nPrice: ${drug['price']}', maxLines: 2, overflow: TextOverflow.ellipsis),
                            isThreeLine: true,
                            trailing: ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F766E)),
                              onPressed: () => _confirmOrder(drug['name']!, drug['price']!),
                              child: const Text('Order'),
                            ),
                          ),
                        );
                      }).toList(),
                      if (state.medicationOrders.isNotEmpty) ...[
                        const SizedBox(height: 20),
                        Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Medication orders', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 10),
                                for (final order in state.medicationOrders)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(order.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                        Text('Price: ${order.price} + Logistics: ${order.logisticsFee}'),
                                        Text('Status: ${order.status}'),
                                        Text('Payment: ${order.paymentMethod}'),
                                        if (order.deliveryConfirmed)
                                          const Text('Delivered', style: TextStyle(color: Colors.green))
                                        else ...[
                                          const SizedBox(height: 8),
                                          ElevatedButton(
                                            onPressed: () => state.confirmMedicationDelivery(order.name),
                                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F766E)),
                                            child: const Text('Confirm delivery'),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _confirmOrder(String name, String price) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Confirm medication order', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Text('Medicine: $name'),
                Text('Price: $price'),
                const SizedBox(height: 16),
                const Text('Payment option', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                ListTile(
                  leading: const Icon(Icons.credit_card),
                  title: const Text('Card payment'),
                  subtitle: const Text('Pay instantly via card'),
                  onTap: () => Navigator.pop(context, true),
                ),
                ListTile(
                  leading: const Icon(Icons.money),
                  title: const Text('Pay on delivery'),
                  subtitle: const Text('Pay when medicine arrives'),
                  onTap: () => Navigator.pop(context, true),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F766E), minimumSize: const Size.fromHeight(50)),
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (result == true) {
      AppState.instance.submitMedicationOrder(name: name, price: price, logisticsFee: '₦500', paymentMethod: 'Card payment');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Medication order confirmed.')));
    }
  }
}
