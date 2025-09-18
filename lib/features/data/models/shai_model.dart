import 'package:flutter/material.dart';
import 'package:oop_solid/features/data/models/drink.dart';

class Shai extends Drink {
  final bool extraMint;
  final bool extraSugar;
  
  Shai({this.extraMint = false, this.extraSugar = false}) 
      : super("شاي", 5.0, Icons.local_cafe);
  
  @override
  double calculatePrice() {
    double price = basePrice;
    if (extraMint) price += 1.0;
    if (extraSugar) price += 0.5;
    return price;
  }
  
  @override
  String getDescription() {
    List<String> extras = [];
    if (extraMint) extras.add("نعناع زيادة");
    if (extraSugar) extras.add("سكر زيادة");
    
    return extras.isEmpty ? name : "$name (${extras.join(', ')})";
  }
  
  @override
  Map<String, bool> getCustomizations() {
    return {
      'extraMint': extraMint,
      'extraSugar': extraSugar,
    };
  }
}