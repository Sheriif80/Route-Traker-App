import 'package:flutter/material.dart';
import 'package:route_tracker_app/widgets/custom_google_maps.dart';
import 'package:route_tracker_app/widgets/custom_text_field.dart';

class HomeViewBody extends StatefulWidget {
  const HomeViewBody({super.key});

  @override
  State<HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody> {
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const CustomGoogleMaps(),
        Positioned(
          top: 20,
          left: 20,
          right: 20,
          child: CustomTextField(textController: _textController),
        ),
      ],
    );
  }
}
