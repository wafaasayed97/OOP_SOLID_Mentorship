import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  final Map<String, bool> _customizations = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          // Header Section
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Colors.brown[800]!, Colors.brown[600]!],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30.r),
                bottomRight: Radius.circular(30.r),
              ),
            ),
            padding: EdgeInsets.fromLTRB(24.w, 60.h, 24.w, 30.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 24.sp,
                      ),
                    ),
                    Text(
                      'طلب جديد',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  'اضف طلبك الجديد بسهولة',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
          ),
          
          // Scrollable Content
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Customer Name Card
                  _buildSectionCard(
                    title: 'معلومات العميل',
                    icon: Icons.person,
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: TextField(
                        controller: _customerNameController,
                        decoration: InputDecoration(
                          labelText: 'اسم العميل',
                          hintText: 'ادخل اسم العميل',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.r),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.r),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.r),
                            borderSide: BorderSide(color: Colors.brown[600]!, width: 2),
                          ),
                          prefixIcon: Icon(Icons.person_outline, color: Colors.brown[600]),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20.h),

                  // Drink Selection Card
                  _buildSectionCard(
                    title: 'اختر نوع المشروب',
                    icon: Icons.local_cafe,
                    child: _buildDrinkSelector(),
                  ),

                  SizedBox(height: 20.h),

                  // Customization Card
                  if (_getCustomizationOptions().isNotEmpty)
                    _buildSectionCard(
                      title: 'خيارات إضافية',
                      icon: Icons.tune,
                      child: _buildCustomizationOptions(),
                    ),

                  if (_getCustomizationOptions().isNotEmpty) SizedBox(height: 20.h),

                  // Special Instructions Card
                  _buildSectionCard(
                    title: 'تعليمات خاصة',
                    icon: Icons.note_alt_outlined,
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: TextField(
                        controller: _instructionsController,
                        decoration: InputDecoration(
                          labelText: 'تعليمات خاصة (اختياري)',
                          hintText: 'اي ملاحظات اضافية...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.r),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.r),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.r),
                            borderSide: BorderSide(color: Colors.brown[600]!, width: 2),
                          ),
                          prefixIcon: Icon(Icons.note_outlined, color: Colors.brown[600]),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        maxLines: 3,
                        minLines: 1,
                      ),
                    ),
                  ),

                  SizedBox(height: 30.h),
                ],
              ),
            ),
          ),

          // Bottom Button
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: BlocBuilder<AhwaManagerCubit, AhwaManagerState>(
              builder: (context, state) {
                final isLoading = state is AhwaManagerLoading;

                return Container(
                  width: double.infinity,
                  height: 56.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.brown[700]!, Colors.brown[800]!],
                    ),
                    borderRadius: BorderRadius.circular(28.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.brown.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _addOrder,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28.r),
                      ),
                    ),
                    child: isLoading
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20.w,
                                height: 20.h,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Text(
                                'جاري الإضافة...',
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_circle_outline,
                                color: Colors.white,
                                size: 24.sp,
                              ),
                              SizedBox(width: 12.w),
                              Text(
                                'إضافة الطلب',
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            decoration: BoxDecoration(
              color: Colors.brown[50],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: Colors.brown[600], size: 24.sp),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown[800],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.w),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildDrinkSelector() {
    return Column(
      children: [
        Row(
          textDirection: TextDirection.rtl,
          children: [
            _buildDrinkOption('shai', 'شاي', Icons.local_cafe, Colors.green),
            SizedBox(width: 12.w),
            _buildDrinkOption('turkish', 'قهوة تركي', Icons.coffee, Colors.brown),
            SizedBox(width: 12.w),
            _buildDrinkOption('hibiscus', 'كركديه', Icons.local_drink, Colors.red),
          ],
        ),
        SizedBox(height: 16.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Text(
            _getDrinkDescription(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDrinkOption(String value, String label, IconData icon, Color color) {
    final isSelected = _selectedDrinkType == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() {
          _selectedDrinkType = value;
          _customizations.clear();
        }),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 12.w),
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [color.withOpacity(0.8), color],
                  )
                : null,
            color: isSelected ? null : Colors.grey[100],
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isSelected ? color : Colors.grey[300]!,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: color.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey[600],
                size: 32.sp,
              ),
              SizedBox(height: 8.h),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey[700],
                  fontSize: 14.sp,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getDrinkDescription() {
    switch (_selectedDrinkType) {
      case 'shai':
        return 'شاي مصري تقليدي بالنعناع والسكر';
      case 'turkish':
        return 'قهوة تركية أصيلة محضرة بالطريقة التقليدية';
      case 'hibiscus':
        return 'مشروب الكركديه المنعش والصحي';
      default:
        return '';
    }
  }

  List<Widget> _getCustomizationOptions() {
    switch (_selectedDrinkType) {
      case 'shai':
        return [
          _buildCustomCheckbox('extraMint', 'نعناع زيادة (+1 ج.م)', Icons.eco),
          _buildCustomCheckbox('extraSugar', 'سكر زيادة (+0.5 ج.م)', Icons.add_circle),
        ];
      case 'turkish':
        return [
          _buildCustomCheckbox('withSugar', 'بالسكر', Icons.add_circle),
          _buildCustomCheckbox('doubleShot', 'دوبل (+5 ج.م)', Icons.coffee_maker),
        ];
      case 'hibiscus':
        return [
          _buildCustomCheckbox('iced', 'مثلج (+2 ج.م)', Icons.ac_unit),
          _buildCustomCheckbox('extraLemon', 'ليمون زيادة (+1 ج.م)', Icons.emoji_food_beverage),
        ];
      default:
        return [];
    }
  }

  Widget _buildCustomizationOptions() {
    final options = _getCustomizationOptions();
    if (options.isEmpty) return const SizedBox.shrink();

    return Column(
      children: options,
    );
  }

  Widget _buildCustomCheckbox(String key, String title, IconData icon) {
    final isChecked = _customizations[key] ?? false;
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: isChecked ? Colors.brown[50] : Colors.grey[50],
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isChecked ? Colors.brown[300]! : Colors.grey[300]!,
        ),
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: CheckboxListTile(
          title: Row(
            children: [
              Icon(
                icon,
                color: isChecked ? Colors.brown[600] : Colors.grey[600],
                size: 20.sp,
              ),
              SizedBox(width: 12.w),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: isChecked ? FontWeight.w600 : FontWeight.normal,
                  color: isChecked ? Colors.brown[800] : Colors.grey[700],
                ),
              ),
            ],
          ),
          value: isChecked,
          onChanged: (value) => setState(() => _customizations[key] = value ?? false),
          activeColor: Colors.brown[600],
          checkColor: Colors.white,
          controlAffinity: ListTileControlAffinity.leading,
        ),
      ),
    );
  }

  void _addOrder() {
    if (_customerNameController.text.trim().isEmpty) {
      _showSnackBar('من فضلك ادخل اسم العميل', Colors.orange);
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

    _showSnackBar('تم إضافة الطلب بنجاح! ✅', Colors.green);
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        margin: EdgeInsets.all(16.w),
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