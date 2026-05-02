import 'package:flutter/material.dart';
import 'package:route_tracker_app/widgets/home_view_body.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(centerTitle: true, title: const Text('Route Tracker')),
      body: const HomeViewBody(),
    );
  }
}
