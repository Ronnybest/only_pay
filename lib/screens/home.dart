import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:only_pay/cubit/posts_cubit.dart';
import 'package:skeletons/skeletons.dart';

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
    final refreshBloc = BlocProvider.of<PostsCubit>(context);
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
              return LoadingSkeleton(context, 10);
            } else if (state is PostsLoaded) {
              List<dynamic> posts = state.allPosts;
              return showAllPosts(context, posts);
            } else {}
            return Container();
          },
        ),
        appBar: AppBar(
          title: const Text('test'),
          backgroundColor: Colors.red,
          actions: [
            IconButton(
                onPressed: (() => refreshBloc.getAllPosts(POSTS_DB)),
                icon: const Icon(Icons.refresh))
          ],
        ),
      ),
    );
  }

  Widget showAllPosts(BuildContext context, List<dynamic> state) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.separated(
          itemBuilder: (context, index) => Container(
                height: 450,
                width: MediaQuery.of(context).size.width / 0.2,
                decoration: const BoxDecoration(color: Colors.blue),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image(
                          image: index == 2
                              ? AssetImage('assets/test.jpg')
                              : AssetImage('assets/image_post.jpg'),
                          fit: BoxFit.cover,
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          height: 300,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text('${state[index]['author']}'),
                    SizedBox(
                      height: 10,
                    ),
                    Text('${state[index]['title']}'),
                    SizedBox(
                      height: 10,
                    ),
                    Text('${state[index]['text']}'),
                  ],
                ),
              ),
          separatorBuilder: (context, index) => const Divider(),
          itemCount: state.length),
    );
  }

  Widget LoadingSkeleton(BuildContext context, int count) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: ListView.separated(
          separatorBuilder: (context, index) => const Divider(),
          itemCount: 3,
          itemBuilder: (context, index) => SkeletonItem(
            child: Column(
              children: [
                SkeletonLine(
                  style: SkeletonLineStyle(
                    height: 50,
                    width: MediaQuery.of(context).size.width / .5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
