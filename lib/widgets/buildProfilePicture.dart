import 'package:flutter/material.dart';

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Colors.green[300]!, Colors.green[600]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const CircleAvatar(
            radius: 60,
            backgroundColor: Colors.white,
            backgroundImage: NetworkImage(
              "https://images.unsplash.com/photo-1530281700549-e82e7bf110d6?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(2),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.green[600],
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.camera_alt_rounded,
              size: 18,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}




