
import 'package:e_commerce/screens/auth_cubit/auth_cubit.dart';
import 'package:e_commerce/screens/loginscreen.dart';
import 'package:e_commerce/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'bloc_opserver.dart';
import 'constant.dart';
import 'layout/layout_cubit.dart';
import 'layout/layout_screen.dart';
import 'local_network.dart';


Future<void> main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  await CacheNetwork.cacheInitialization();
  token = await CacheNetwork.getCacheData(key: 'token');
  debugPrint("token is : $token");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360,690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context,child){
        return MultiBlocProvider(
          providers:
          [
            BlocProvider(create: (context) => AuthCubit()),
            BlocProvider(create: (context) => LayoutCubit()..getCarts()..getFavorites()..getBannersData()..getCategoriesData()..getProducts()),
          ],
          child: MaterialApp(
              debugShowCheckedModeBanner: false,
              home: token != null ? const LayoutScreen() : LoginScreen()
          ),
        );
      },
    );
  }
}