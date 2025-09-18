import 'package:flutter/material.dart';
import 'package:oop_solid/features/data/models/order.dart';

class OrderCard extends StatelessWidget {
  final Order order;
  final VoidCallback onComplete;
  
  const OrderCard({super.key, required this.order, required this.onComplete});
  
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.brown[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(order.drink.icon, color: Colors.brown[800]),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'طلب #${order.id} - ${order.customerName}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 4),
                  Text(
                    order.drink.getDescription(),
                    style: TextStyle(color: Colors.brown[700]),
                  ),
                  if (order.specialInstructions.isNotEmpty) ...[
                    SizedBox(height: 4),
                    Text(
                      'ملاحظات: ${order.specialInstructions}',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 16, color: Colors.grey),
                      SizedBox(width: 4),
                      Text(
                        order.getFormattedTime(),
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                      Spacer(),
                      Text(
                        '${order.getTotalPrice().toStringAsFixed(1)} ج.م',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 16),
            ElevatedButton.icon(
              onPressed: onComplete,
              icon: Icon(Icons.check),
              label: Text('تم'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
