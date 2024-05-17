import 'package:flutter/material.dart';
import 'package:shop/api/endpoint/all_product/produk_item.dart';

class ProductItemWidget extends StatelessWidget {
  final ProductItem product;

  ProductItemWidget({required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              product.image,
              fit: BoxFit.cover,
              height: 120.0,
              width: double.infinity,
            ),
            SizedBox(height: 8.0),
            Text(
              product.title,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text('\$${product.price.toString()}'),
            SizedBox(height: 8.0),
            Text(
              product.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 8.0),
            Row(
              children: [
                Icon(Icons.star, color: Colors.amber),
                Text('${product.rating.rate} (${product.rating.count})'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
