import 'package:e_commerce/product_model.dart';
import 'package:flutter/material.dart';

import 'layout/layout_cubit.dart';

Widget ProductItem({required ProductModel model, required LayoutCubit cubit}) {
  return Stack(
    alignment: Alignment.bottomCenter,
    children: [
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.grey.withOpacity(0.2),
        ),
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Image.network(
                model.image!,
                fit: BoxFit.fill,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              model.name!,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  overflow: TextOverflow.ellipsis),
            ),
            const SizedBox(
              height: 2,
            ),
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            "${model.price!} \$",
                            style: TextStyle(fontSize: 13),
                          )),
                      SizedBox(
                        width: 5,
                      ),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          "${model.oldPrice!} \$",
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12.5,
                              decoration: TextDecoration.lineThrough),
                        ),
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  child: Icon(
                    Icons.favorite,
                    size: 20,
                    color: cubit.favoritesID.contains(model.id.toString())
                        ? Colors.red
                        : Colors.grey,
                  ),
                  onTap: () {
                    // Add | remove product favorites
                    cubit.addOrRemoveFromFavorites(
                        productID: model.id.toString());
                  },
                )
              ],
            )
          ],
        ),
      ),
      CircleAvatar(
        backgroundColor: Colors.black,
        child: GestureDetector(
          onTap: () {
            cubit.addOrRemoveProductFroCart(id: model.id.toString());
          },
          child:  Icon(Icons.shopping_cart,
          color: cubit.cartsId.contains(model.id.toString())?Colors.red:Colors.white
            ,
          ),
        ),
      )
    ],
  );
}
