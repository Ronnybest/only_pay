import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:only_pay/cubit/posts_cubit.dart';

import '../constant/constants.dart';

class MainPage extends StatefulWidget {
  const MainPage(this.model, {super.key});
  final Map<String, dynamic>? model;
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var postCubit = context.read<PostsCubit>();
    postCubit.getAllPosts(POSTS_DB);
  }

  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: BlocConsumer<PostsCubit, PostsState>(
          listener: (context, state) {
            if (state is PostsError) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            if (state is PostsLoading) {
            } else if (state is PostsLoaded) {
            } else {}
            return Container();
          },
        ),
        appBar: AppBar(
          title: Text('test'),
          backgroundColor: Colors.red,
        ),
      ),
    );
  }
}
