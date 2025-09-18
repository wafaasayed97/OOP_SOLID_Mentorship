import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oop_solid/features/data/models/drink.dart';
import 'package:oop_solid/features/data/models/hibiscus_tea.dart';
import 'package:oop_solid/features/data/models/shai_model.dart';
import 'package:oop_solid/features/data/models/turkish_coffee.dart';
import 'package:oop_solid/features/presentation/logic/cubit/ahwa_manager_cubit.dart';
import 'package:oop_solid/features/presentation/logic/cubit/ahwa_manager_state.dart';

class AddOrderScreen extends StatefulWidget {
  const AddOrderScreen({super.key});

  @override
  _AddOrderScreenState createState() => _AddOrderScreenState();
}

class _AddOrderScreenState extends State<AddOrderScreen> {
  final _customerNameController = TextEditingController();
  final _instructionsController = TextEditingController();
  String _selectedDrinkType = 'shai';
  Map<String, bool> _customizations = {};

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'طلب جديد',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.brown[800],
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _customerNameController,
            decoration: const InputDecoration(
              labelText: 'اسم العميل',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person),
            ),
          ),
          const SizedBox(height: 16),
          const Text('نوع المشروب:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _buildDrinkSelector(),
          const SizedBox(height: 16),
          _buildCustomizationOptions(),
          const SizedBox(height: 16),
          TextField(
            controller: _instructionsController,
            decoration: const InputDecoration(
              labelText: 'تعليمات خاصة (اختياري)',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.note),
            ),
            maxLines: 2,
          ),
          const Spacer(),
          BlocBuilder<AhwaManagerCubit, AhwaManagerState>(
            builder: (context, state) {
              final isLoading = state is AhwaManagerLoading;

              return SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: isLoading ? null : _addOrder,
                  icon: isLoading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.add),
                  label: Text(isLoading ? 'جاري الإضافة...' : 'إضافة الطلب'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown[800],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrinkSelector() {
    return Row(
      children: [
        _buildDrinkOption('shai', 'شاي', Icons.local_cafe),
        const SizedBox(width: 8),
        _buildDrinkOption('turkish', 'قهوة تركي', Icons.coffee),
        const SizedBox(width: 8),
        _buildDrinkOption('hibiscus', 'كركديه', Icons.local_drink),
      ],
    );
  }

  Widget _buildDrinkOption(String value, String label, IconData icon) {
    final isSelected = _selectedDrinkType == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() {
          _selectedDrinkType = value;
          _customizations.clear();
        }),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.brown[800] : Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Icon(icon, color: isSelected ? Colors.white : Colors.brown[800]),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.brown[800],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomizationOptions() {
    switch (_selectedDrinkType) {
      case 'shai':
        return Column(
          children: [
            CheckboxListTile(
              title: const Text('نعناع زيادة (+1 ج.م)'),
              value: _customizations['extraMint'] ?? false,
              onChanged: (value) =>
                  setState(() => _customizations['extraMint'] = value ?? false),
            ),
            CheckboxListTile(
              title: const Text('سكر زيادة (+0.5 ج.م)'),
              value: _customizations['extraSugar'] ?? false,
              onChanged: (value) => setState(
                  () => _customizations['extraSugar'] = value ?? false),
            ),
          ],
        );
      case 'turkish':
        return Column(
          children: [
            CheckboxListTile(
              title: const Text('بالسكر'),
              value: _customizations['withSugar'] ?? false,
              onChanged: (value) => setState(
                  () => _customizations['withSugar'] = value ?? false),
            ),
            CheckboxListTile(
              title: const Text('دوبل (+5 ج.م)'),
              value: _customizations['doubleShot'] ?? false,
              onChanged: (value) => setState(
                  () => _customizations['doubleShot'] = value ?? false),
            ),
          ],
        );
      case 'hibiscus':
        return Column(
          children: [
            CheckboxListTile(
              title: const Text('مثلج (+2 ج.م)'),
              value: _customizations['iced'] ?? false,
              onChanged: (value) =>
                  setState(() => _customizations['iced'] = value ?? false),
            ),
            CheckboxListTile(
              title: const Text('ليمون زيادة (+1 ج.م)'),
              value: _customizations['extraLemon'] ?? false,
              onChanged: (value) => setState(
                  () => _customizations['extraLemon'] = value ?? false),
            ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }

  void _addOrder() {
    if (_customerNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('من فضلك ادخل اسم العميل')),
      );
      return;
    }

    Drink drink;
    switch (_selectedDrinkType) {
      case 'shai':
        drink = Shai(
          extraMint: _customizations['extraMint'] ?? false,
          extraSugar: _customizations['extraSugar'] ?? false,
        );
        break;
      case 'turkish':
        drink = TurkishCoffee(
          withSugar: _customizations['withSugar'] ?? false,
          doubleShot: _customizations['doubleShot'] ?? false,
        );
        break;
      case 'hibiscus':
        drink = HibiscusTea(
          iced: _customizations['iced'] ?? false,
          extraLemon: _customizations['extraLemon'] ?? false,
        );
        break;
      default:
        drink = Shai();
    }

    context.read<AhwaManagerCubit>().addOrder(
          _customerNameController.text.trim(),
          drink,
          _instructionsController.text.trim(),
        );

    _customerNameController.clear();
    _instructionsController.clear();
    _customizations.clear();
    setState(() {
      _selectedDrinkType = 'shai';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم إضافة الطلب بنجاح! ✅'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  void dispose() {
    _customerNameController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }
}
