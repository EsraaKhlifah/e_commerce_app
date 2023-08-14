import 'dart:convert';
import 'package:bloc/bloc.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../banner_model.dart';
import '../catigory_model.dart';
import '../constant.dart';
import '../product_model.dart';
import '../screens/card_screen.dart';
import '../screens/catigories_screen.dart';
import '../screens/favorit_screen.dart';
import '../screens/home_screen.dart';
import '../screens/profile_screen.dart';
import '../user_model.dart';
import 'layout_state.dart';

class LayoutCubit extends Cubit<LayoutStates>{
  LayoutCubit() : super(LayoutInitialState());

  int bottomNavIndex = 0 ;
  List<Widget> layoutScreens = [HomeScreen() ,
   CategoriesScreen(), FavoritesScreen(), CartScreen(),
    ProfileScreen()];
  //علشان اغير اندكس الناف بار
  void changeBottomNavIndex({required int index})
  {
    bottomNavIndex = index;
    // Emit state
    emit(ChangeBottomNavIndexState());
  }

  UserModel? userModel;
  void getUserData() async {
    emit(GetUserDataLoadingState());
    Response response = await http.get(
        Uri.parse("https://student.valuxapps.com/api/profile"),
        headers:
        {
          'Authorization' : token!,
          "lang" : "en"
        }
    );
    var responseData = jsonDecode(response.body);
    if( responseData['status'] == true )
    {
      userModel = UserModel.fromJson(data: responseData['data']);
      print("response is : $responseData");
      emit(GetUserDataSuccessState());
    }
    else
    {
      print("response is : $responseData");
      emit(FailedToGetUserDataState(error: responseData['message']));
    }
  }

  List<BannerModel> banners = [];
  void getBannersData() async {
    Response response = await http.get(
        Uri.parse("https://student.valuxapps.com/api/banners")
    );
    final responseBody = jsonDecode(response.body);
    if( responseBody['status'] == true )
    {
      for( var item in responseBody['data'] )
      {
        banners.add(BannerModel.fromJson(data: item));
      }
      emit(GetBannersSuccessState());
    }
    else
    {
      emit(FailedToGetBannersState());
    }
  }

  List<CategoryModel> categories = [];
  void getCategoriesData() async {
    Response response = await http.get(
        Uri.parse("https://student.valuxapps.com/api/categories"),
        headers:
        {
          'lang' : "en"
        }
    );
    final responseBody = jsonDecode(response.body);
    if( responseBody['status'] == true )
    {
      for( var item in responseBody['data']['data'] )
      {
        categories.add(CategoryModel.fromJson(data: item));
      }
      emit(GetCategoriesSuccessState());
    }
    else
    {
      emit(FailedToGetCategoriesState());
    }
  }

  List<ProductModel> products = [];
  void getProducts() async {
    Response response = await http.get(
        Uri.parse("https://student.valuxapps.com/api/home"),
        headers:
        {
          'Authorization' : token!,
          'lang' : "en"
        }
    );
    var responseBody = jsonDecode(response.body);
    /// print("Products Data is : $responseBody");
    // loop list
    if( responseBody['status'] == true )
    {
      for( var item in responseBody['data']['products'] )
      {
        products.add(ProductModel.fromJson(data: item));
      }
      emit(GetProductsSuccessState());
    }
    else
    {
      emit(FailedToGetProductsState());
    }
  }

  // filtered products
  List<ProductModel> filteredProducts = [];
  void filterProducts({required String input})
  //بتلوب علي الليسته
  {
    filteredProducts = products.where((element) => element.name!.toLowerCase().startsWith(input.toLowerCase())).toList();
    emit(FilterProductsSuccessState());
  }

  List<ProductModel> favorites = [];
  // set مفيش تكرار
  Set<String> favoritesID = {};
  Future<void> getFavorites() async {
    favorites.clear();
    Response response = await http.get(
        Uri.parse("https://student.valuxapps.com/api/favorites"),
        headers:
        {
          "lang" : "en",
          "Authorization" : token!
        }
    );
    // http
    var responseBody = jsonDecode(response.body);
    if( responseBody['status'] == true )
    {
      // loop list
      for( var item in responseBody['data']['data'] )
      {
        // Refactoring
        favorites.add(ProductModel.fromJson(data: item['product']));
        favoritesID.add(item['product']['id'].toString());
      }
      print("Favorites number is : ${favorites.length}");
      emit(GetFavoritesSuccessState());
    }
    else
    {
      emit(FailedToGetFavoritesState());
    }
  }

  void addOrRemoveFromFavorites({required String productID}) async {
    Response response = await http.post(
        Uri.parse("https://student.valuxapps.com/api/favorites"),
        headers:
        {
          "lang" : "en",
          "Authorization" : token!
        },
        body:
        {
          "product_id" : productID
        }
    );
    var responseBody = jsonDecode(response.body);
    if( responseBody['status'] == true )
    {
      if( favoritesID.contains(productID) == true )
      {
        // delete
        favoritesID.remove(productID);
      }
      else
      {
        // add
        favoritesID.add(productID);
      }
      await getFavorites();
      emit(AddOrRemoveItemFromFavoritesSuccessState());
    }
    else
    {
      emit(FailedToAddOrRemoveItemFromFavoritesState());
    }
  }

  List<ProductModel> carts = [];
  Set<String>cartsId={};
  int totalPrice = 0;
  Future<void> getCarts() async {
    carts.clear();
    Response response = await http.get(
        Uri.parse("https://student.valuxapps.com/api/carts"),
        headers:
        {
          "Authorization" : token!,
          "lang" : "en"
        }
    );
    var responseBody = jsonDecode(response.body);
    if( responseBody['status'] == true )
    {
      // success
      for ( var item in responseBody['data']['cart_items'] )
      {
        cartsId.add(item['product']['id'].toString());
        carts.add(ProductModel.fromJson(data: item['product']));
      }
      totalPrice = responseBody['data']['total'];
      debugPrint("Carts length is : ${carts.length}");
      emit(GetCartsSuccessState());
    }
    else
    {
      // failed
      emit(FailedToGetCartsState());
    }
  }
  void addOrRemoveProductFroCart({required String id})async{
  Response response =await http.post(Uri.parse('https://student.valuxapps.com/api/carts'),
     body: {'product_id': id,},
     headers: {   "Authorization" : token!,
       "lang" : "en",
     }
     );

var responseBody=jsonDecode(response.body);
  if( responseBody['status'] == true )
  {
    // success
    cartsId.contains(id)==true?cartsId.remove(id):cartsId.add(id);
    
 await  getCarts();
    emit(AddToCartsSuccessState());
  }
  else
  {
    // failed
    emit(FailedToAddCartsState());
  }

  }

}
