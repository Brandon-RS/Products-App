import 'package:flutter/material.dart';
import 'package:products_app/models/models.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({Key? key, required this.product}) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 30, bottom: 40),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: _cardBorders(),
      height: 400.0,
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          _BackgroundImage(image: product.picture),
          _ProductDetail(product: product),
          _PriceTag(product: product),
          if (!product.available) const _NotAvailable(),
        ],
      ),
    );
  }

  BoxDecoration _cardBorders() => BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 10),
            blurRadius: 10,
          ),
        ],
      );
}

class _PriceTag extends StatelessWidget {
  const _PriceTag({Key? key, required this.product}) : super(key: key);
  final Product product;

  @override
  Widget build(BuildContext context) {
    const boxDecoration = BoxDecoration(
      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25)),
      color: Colors.indigo,
    );

    return Positioned(
      top: 0,
      right: 0,
      child: Container(
        width: 100,
        height: 60,
        alignment: Alignment.center,
        decoration: boxDecoration,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: FittedBox(
          fit: BoxFit.contain,
          child: Text('\$${product.price}', style: const TextStyle(color: Colors.white, fontSize: 20)),
        ),
      ),
    );
  }
}

class _NotAvailable extends StatelessWidget {
  const _NotAvailable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const boxDecoration = BoxDecoration(
      borderRadius: BorderRadius.only(bottomRight: Radius.circular(25)),
      color: Colors.orange,
    );

    return Positioned(
      top: 0,
      child: Container(
        width: 100,
        height: 60,
        alignment: Alignment.center,
        decoration: boxDecoration,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: const FittedBox(
          fit: BoxFit.contain,
          child: Text('Not Available', style: TextStyle(color: Colors.white, fontSize: 20)),
        ),
      ),
    );
  }
}

class _ProductDetail extends StatelessWidget {
  const _ProductDetail({Key? key, required this.product}) : super(key: key);
  final Product product;

  @override
  Widget build(BuildContext context) {
    const _buildBoxDecoration = BoxDecoration(
      borderRadius: BorderRadius.only(topRight: Radius.circular(25)),
      color: Colors.indigo,
    );

    return Container(
      decoration: _buildBoxDecoration,
      height: 70,
      margin: const EdgeInsets.only(right: 60),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.name,
            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          Text(
            product.id!,
            style: const TextStyle(color: Colors.white, fontSize: 15),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}

class _BackgroundImage extends StatelessWidget {
  const _BackgroundImage({Key? key, this.image}) : super(key: key);
  final String? image;

  @override
  Widget build(BuildContext context) {
    return FadeInImage(
      placeholder: const AssetImage('assets/images/jar-loading.gif'),
      image: NetworkImage(image ?? 'https://virtual.trivo.com.ec/img/no-img-placeholder.png'),
      fit: BoxFit.cover,
      width: double.infinity,
      height: 400,
    );
  }
}
