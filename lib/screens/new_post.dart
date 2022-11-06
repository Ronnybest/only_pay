import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:only_pay/api.dart';
import 'package:only_pay/constant/constants.dart';
import 'package:only_pay/cubit/addpost_cubit.dart';
import 'package:only_pay/models/comments_model.dart';
import 'package:only_pay/models/post_model.dart';

class AddPosts extends StatefulWidget {
  const AddPosts({super.key, required this.model});
  final Map<String, dynamic>? model;
  @override
  State<AddPosts> createState() => _AddPostsState();
}

XFile? img;

class _AddPostsState extends State<AddPosts> {
  late CloudApi api;
  late Uint8List imgbytes;
  late String imgName;
  var titleController = TextEditingController();
  var textController = TextEditingController();
  @override
  void setState(VoidCallback fn) {
    rootBundle
        .loadString('assets/credentials.json')
        .then((json) => api = CloudApi(json));
    super.setState(fn);
  }

  void pickImg() async {
    ImagePicker imagePicker = ImagePicker();
    img = await imagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 75);
    if (img != null) {
      File test1 = File(img!.path);
      imgName = test1.path.split('/').last;
      imgbytes = test1.readAsBytesSync();
      setState(() {});
    }
  }

  void saveToCloud(String title, String text) async {
    final response = await api.save(imgName, imgbytes);
    PostModel model1 = PostModel(
        id: mongo.ObjectId(),
        title: title,
        text: text,
        imgUrl: response.downloadLink.toString(),
        view: 0,
        author: widget.model?["username"],
        authorID: widget.model?["_id"],
        comments: List<CommentModel>.empty(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        v: 1);
    final addPostCubit = context.read<AddpostCubit>();
    addPostCubit.uploadPost(model1, context, POSTS_DB);
    //* print(response.downloadLink);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: BlocConsumer<AddpostCubit, AddpostState>(
        listener: ((context, state) {
          if (state is AddpostError) {
            ScaffoldMessenger.of(context).showMaterialBanner(
              MaterialBanner(
                content: Text(state.message),
                actions: List.empty(),
              ),
            );
          }
        }),
        builder: ((context, state) {
          if (state is AddpostInitial) {
            return FullPage(context);
          } else if (state is AddpostLoading) {
            return Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (state is AddpostLoaded) {
            return FullPage(context);
          } else {
            return FullPage(context);
          }
        }),
      ),
    ));
  }

  Widget FullPage(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            img == null ? Text('Пост без фото') : Image.file(File(img!.path)),
            TextField(
              controller: titleController,
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: textController,
            ),
            MaterialButton(
              onPressed: () =>
                  saveToCloud(titleController.text, textController.text),
              child: Text('Добавить пост'),
            ),
          ]),
        ),
      ),
      floatingActionButton: FloatingActionButton.large(
        onPressed: () {
          pickImg();
        },
        child: FaIcon(FontAwesomeIcons.image),
      ),
    );
  }
}
