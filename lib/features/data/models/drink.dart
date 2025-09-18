
import 'package:flutter/material.dart';

abstract class Drink {
  final String name;
  final double basePrice;
  final IconData icon;
  
  Drink(this.name, this.basePrice, this.icon);
  
  double calculatePrice();
  String getDescription();
  Map<String, bool> getCustomizations();
  
  String getFullDescription() {
    return "${getDescription()} - ${calculatePrice().toStringAsFixed(1)} LE";
  }
}