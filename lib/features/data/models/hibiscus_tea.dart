
import 'package:flutter/material.dart';
import 'package:oop_solid/features/data/models/drink.dart';

class HibiscusTea extends Drink {
  final bool iced;
  final bool extraLemon;
  
  HibiscusTea({this.iced = false, this.extraLemon = false}) 
      : super("كركديه", 8.0, Icons.local_drink);
  
  @override
  double calculatePrice() {
    double price = basePrice;
    if (iced) price += 2.0;
    if (extraLemon) price += 1.0;
    return price;
  }
  
  @override
  String getDescription() {
    List<String> extras = [];
    if (iced) extras.add("مثلج");
    if (extraLemon) extras.add("ليمون زيادة");
    
    return extras.isEmpty ? name : "$name (${extras.join(', ')})";
  }
  
  @override
  Map<String, bool> getCustomizations() {
    return {
      'iced': iced,
      'extraLemon': extraLemon,
    };
  }
}