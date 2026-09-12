import 'package:e_commeric/features/home/data/models/product_model.dart';
import 'package:e_commeric/features/product_details/presentation/views/widgets/information_row.dart';
import 'package:flutter/material.dart';

class ProductInformation extends StatelessWidget {
  const ProductInformation({required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Column(
          children: [
            InformationRow(
              icon: Icons.inventory_2_outlined,
              label: 'Availability',
              value: '${product.availabilityStatus} (${product.stock})',
            ),
            const Divider(),
            InformationRow(
              icon: Icons.verified_user_outlined,
              label: 'Warranty',
              value: product.warrantyInformation,
            ),
            const Divider(),
            InformationRow(
              icon: Icons.assignment_return_outlined,
              label: 'Returns',
              value: product.returnPolicy,
            ),
            const Divider(),
            InformationRow(
              icon: Icons.qr_code_2_rounded,
              label: 'SKU',
              value: product.sku,
            ),
          ],
        ),
      ),
    );
  }
}
