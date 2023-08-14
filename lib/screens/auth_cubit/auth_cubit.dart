import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../../local_network.dart';
import 'auth_states.dart';

class AuthCubit extends Cubit<AuthStates>{
  AuthCubit() : super(AuthInitialState());

  void register({required String email,required String name,
    required String phone,required String password}) async {
    emit(RegisterLoadingState());
    try{
      Response response = await http.post(
        // request Url = base url + method url ( endpoint ) = https://student.valuxapps.com + /api/register
        //علشان محتاج اغير ال url الي string
        Uri.parse('https://student.valuxapps.com/api/register'),
        body: {
          'name' : name,
          'email' : email,
          'password' : password,
          'phone' : phone,
          'image' : "jdfjfj"     // الصوره مش شغاله بس لازم ابعت قيمه ك value
        },
        //jsonDecode بيفك التشفير
      );
      if( response.statusCode == 200 )
      {
        var data = jsonDecode(response.body);
        if( data['status'] == true )
        {
          debugPrint("Response is : $data");
          emit(RegisterSuccessState());
        }
        else
        {
          debugPrint("Response is : $data");
          emit(FailedToRegisterState(message: data['message']));
        }
      }
    }
    catch(e){
      debugPrint("Failed to Register , reason : $e");
      emit(FailedToRegisterState(message: e.toString()));
    }
  }

  // Account : mo.ha@gmail.com , password : 123456
  void login({required String email,required String password}) async {
    emit(LoginLoadingState());
    try{
      Response response = await http.post(
        // request => url = base url + method url
        Uri.parse('https://student.valuxapps.com/api/login'),
        body: {
          'email' : email,
          'password' : password
        },
      );
      //بعمل تشيك علي الرسبونس علشان لو 200 يبقي ترو لو لا يبقي فولس
      if( response.statusCode == 200 )
      {
        var responseData = jsonDecode(response.body);
        if( responseData['status'] == true )
        {
          await CacheNetwork.insertToCache(key: "token", value: responseData['data']['token']);
          emit(LoginSuccessState());
        }
        else
        {
          //بيجيب الداتا الموجوده في المسدج

          debugPrint("Failed to login, reason is : ${responseData['message']}");
          emit(FailedToLoginState(message: responseData['message']));
        }
      }
    }
    catch(e){
      emit(FailedToLoginState(message: e.toString()));
    }
  }
}