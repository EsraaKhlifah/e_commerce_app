import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../layout/layout_cubit.dart';
import '../layout/layout_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LayoutCubit,LayoutStates>(
      listener: (context,state) {},
      builder: (context,state){
        final cubit = BlocProvider.of<LayoutCubit>(context);
        return Scaffold(
            body: cubit.userModel != null ?
            Column(
              children:
              [
                Text(cubit.userModel!.name!),
                SizedBox(height:10),
                Text(cubit.userModel!.email!),
              ],
            ) :
            Center(child: CircularProgressIndicator())
        );
      },
    );
  }
}
