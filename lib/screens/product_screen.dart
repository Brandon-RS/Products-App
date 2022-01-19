import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:products_app/providers/providers.dart';
import 'package:products_app/services/services.dart';
import 'package:products_app/ui/input_decoration.dart';
import 'package:products_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({Key? key}) : super(key: key);

  static const String routeName = 'Product';

  @override
  Widget build(BuildContext context) {
    final productService = Provider.of<ProductsService>(context);

    return ChangeNotifierProvider(
      create: (_) => ProductFormProvider(productService.selectedProduct),
      child: _ProductScreenBody(productService: productService),
    );
  }
}

class _ProductScreenBody extends StatelessWidget {
  const _ProductScreenBody({Key? key, required this.productService}) : super(key: key);

  final ProductsService productService;

  @override
  Widget build(BuildContext context) {
    final productForm = Provider.of<ProductFormProvider>(context);
    final padding = MediaQuery.of(context).padding;

    return Scaffold(
      body: SingleChildScrollView(
        // keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          children: [
            Stack(
              children: [
                ProductImage(url: productService.selectedProduct.picture),
                Positioned(
                  top: padding.top + 10,
                  left: 10,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 35),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Positioned(
                  top: padding.top + 10,
                  right: 10,
                  child: IconButton(
                    icon: const Icon(Icons.camera_alt_outlined, color: Colors.white, size: 35),
                    onPressed: () async {
                      final picker = ImagePicker();
                      final XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);

                      if (pickedFile == null) return;

                      productService.updateSelectedProductImage(pickedFile.path);
                    },
                  ),
                ),
              ],
            ),
            const _ProductForm(),
            const SizedBox(height: 10),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: productService.isSaving
            ? const CircularProgressIndicator(color: Colors.white)
            : const Icon(Icons.save_outlined),
        onPressed: productService.isSaving
            ? null
            : () async {
                if (!productForm.isValidForm()) return;
                FocusScope.of(context).unfocus();

                final String? imageUrl = await productService.uploadImage();

                if (imageUrl != null) {
                  productForm.product.picture = imageUrl;
                }

                await productService.saveOrCreateProduct(productForm.product);
                productService.loadProducts();
              },
      ),
    );
  }
}

class _ProductForm extends StatelessWidget {
  const _ProductForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productForm = Provider.of<ProductFormProvider>(context);
    final product = productForm.product;

    var boxDecoration = BoxDecoration(
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(25)),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          offset: const Offset(0, 5),
          blurRadius: 7,
        ),
      ],
    );
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: boxDecoration,
      child: Form(
        key: productForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            const SizedBox(height: 10),
            TextFormField(
              initialValue: product.name,
              onChanged: (value) => product.name = value,
              validator: (value) {
                if (value == null || value.isEmpty) return 'El nombre es obligatorio';
              },
              decoration: InputDecorations.authInputDecoration(
                hintText: 'Nombre del producto',
                labelText: 'Nombre:',
              ),
            ),
            const SizedBox(height: 30),
            TextFormField(
              initialValue: '${product.price}',
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}')),
              ],
              onChanged: (value) {
                double.tryParse(value) == null ? product.price = 0 : product.price = double.parse(value);
              },
              decoration: InputDecorations.authInputDecoration(
                hintText: '\$150',
                labelText: 'Precio:',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 30),
            SwitchListTile.adaptive(
              value: product.available,
              title: const Text('Disponible'),
              activeColor: Colors.indigo,
              onChanged: productForm.updateAvailability,
              // onChanged: (value) => productForm.updateAvailability(value),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
