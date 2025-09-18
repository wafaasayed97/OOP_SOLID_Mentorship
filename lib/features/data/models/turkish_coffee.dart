
import 'package:flutter/material.dart';
import 'package:oop_solid/features/data/models/drink.dart';

class TurkishCoffee extends Drink {
  final bool withSugar;
  final bool doubleShot;
  
  TurkishCoffee({this.withSugar = false, this.doubleShot = false}) 
      : super("قهوة تركي", 12.0, Icons.coffee);
  
  @override
  double calculatePrice() {
    double price = basePrice;
    if (doubleShot) price += 5.0;
    return price;
  }
  
  @override
  String getDescription() {
    List<String> extras = [];
    if (withSugar) extras.add("بالسكر");
    if (doubleShot) extras.add("دوبل");
    
    return extras.isEmpty ? name : "$name (${extras.join(', ')})";
  }
  
  @override
  Map<String, bool> getCustomizations() {
    return {
      'withSugar': withSugar,
      'doubleShot': doubleShot,
    };
  }
}
