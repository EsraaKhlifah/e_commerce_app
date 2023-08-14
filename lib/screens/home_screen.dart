
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../colors.dart';
import '../layout/layout_cubit.dart';
import '../layout/layout_state.dart';
import '../product_item.dart';

class HomeScreen extends StatelessWidget {
  final pageController = PageController();
  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<LayoutCubit>(context);
    return BlocConsumer<LayoutCubit,LayoutStates>(
        listener: (context,state){},
        builder:(context,state){
          return Scaffold(
              body: Padding(
                padding: const EdgeInsets.symmetric(vertical: 18.0,horizontal: 15),
                child: ListView(
                  shrinkWrap: true,
                  children:
                  [
                    TextFormField(
                      onChanged: (input){cubit.filterProducts(input: input);},
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        hintText: "Search",
                        suffixIcon: const Icon(Icons.clear),
                        filled: true,
                        fillColor: Colors.black12.withOpacity(0.1),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: const BorderSide(color: Colors.grey)
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 17),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15,),
                    // Todo: Display Banners
                    cubit.banners.isEmpty ?
                    const Center(child: CupertinoActivityIndicator(),) :
                    SizedBox(
                      height: 150,
                      width: double.infinity,
                      child: PageView.builder(
                          controller: pageController,
                          physics: const BouncingScrollPhysics(),
                          itemCount: 3,
                          itemBuilder: (context,index){
                            return Image.network(cubit.banners[index].url!,fit: BoxFit.fill,);
                          }
                      ),
                    ),
                    const SizedBox(height: 15,),
                    // Todo: Smooth Page Indicator
                    Center(
                      child: SmoothPageIndicator(
                        controller: pageController,
                        count: 3,
                        axisDirection: Axis.horizontal,
                        effect:  SlideEffect(
                            spacing: 8.0,
                            radius:  25,
                            dotWidth:  16,
                            dotHeight:  16.0,
                            paintStyle: PaintingStyle.stroke,
                            strokeWidth:  1.5,
                            dotColor:  Colors.grey,
                            activeDotColor: secondColor
                        ),
                      ),
                    ),
                    const SizedBox(height: 15,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:
                      [
                        Text("Categories",style: TextStyle(color: mainColor,fontSize: 20,fontWeight: FontWeight.bold),),
                        Text("View all",style: TextStyle(color: secondColor,fontSize: 14,fontWeight: FontWeight.bold),),
                      ],
                    ),
                    const SizedBox(height: 15,),
                    cubit.categories.isEmpty ?
                    const Center(child: CupertinoActivityIndicator(),) :
                    SizedBox(
                      height: 70,
                      width: double.infinity,
                      child: ListView.separated(
                          physics: BouncingScrollPhysics(),
                          itemCount: cubit.categories.length,
                          scrollDirection: Axis.horizontal,
                          separatorBuilder: (context,index){
                            return SizedBox(width: 15,);
                          },
                          itemBuilder: (context,index)
                          {
                            return CircleAvatar(
                              radius: 35,
                              backgroundImage: NetworkImage(cubit.categories[index].url!),
                            );
                          }
                      ),
                    ),
                    SizedBox(height: 15,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:
                      [
                        Text("Products",style: TextStyle(color: mainColor,fontSize: 20,fontWeight: FontWeight.bold),),
                        Text("View all",style: TextStyle(color: secondColor,fontSize: 14,fontWeight: FontWeight.bold),),
                      ],
                    ),
                    const SizedBox(height: 15,),
                    cubit.products.isEmpty ?
                    const Center(child: CupertinoActivityIndicator(),) :
                    GridView.builder(
                        itemCount: cubit.filteredProducts.isEmpty ?
                        cubit.products.length :
                        cubit.filteredProducts.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 15,
                            childAspectRatio: 0.6
                        ),
                        itemBuilder: (context,index)
                        {
                          return ProductItem(
                              model: cubit.filteredProducts.isEmpty ?
                              cubit.products[index] :
                              cubit.filteredProducts[index],
                              cubit: cubit
                          );
                        }
                    )
                  ],
                ),
              )
          );
        }
    );
  }
}

