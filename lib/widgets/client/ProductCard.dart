import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jkmapp/widgets/image_display.dart';
import 'package:jkmapp/providers/client/cart_provider.dart';
import 'package:provider/provider.dart';



class ProudctCard extends StatelessWidget{
    final Map<String,dynamic>product;
    ProudctCard({required this.product});

    @override
    Widget build(BuildContext context){
        return Container(
            width: 50,
            height: 50,
            color: Colors.white,
            child: Card(
                color: Colors.white,
                elevation: 4,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        ImageDisplay(imageData: product['image']),
                        const SizedBox(height: 5),
                        Text(product['name'] ?? '', style: const TextStyle(fontSize: 18,),
                        ),
                        const SizedBox(height: 8),
                        Text('NT\$ ${product['price']}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal,),
                        ),
                        ElevatedButton(
                            onPressed: () {
                                Provider.of<CartProvider>(context, listen: false).addToCart(
                                    product['name'],
                                    product['price'],
                                    product['product_id']//可能傳遞null
                                );
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                minimumSize: const Size(100, 40),
                            ),
                            child: const Text('加入購物車', style: TextStyle(color: Colors.black)),
                        ),
                    ],
                ),
            ),
        );
    }
}