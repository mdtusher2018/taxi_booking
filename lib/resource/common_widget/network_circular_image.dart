import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class NetworkCircleAvatar extends StatefulWidget {
  final String imageUrl;
  final double radius;
  final Widget? fallback;

  const NetworkCircleAvatar({
    super.key,
    required this.imageUrl,
    this.radius = 32,
    this.fallback,
  });

  @override
  State<NetworkCircleAvatar> createState() => _NetworkCircleAvatarState();
}

class _NetworkCircleAvatarState extends State<NetworkCircleAvatar> {
  bool _hasError = false;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: widget.radius,
      backgroundImage:
          _hasError
              ? null
              : CachedNetworkImageProvider(
                widget.imageUrl,
                errorListener: (_) {
                  setState(() {
                    _hasError = true;
                  });
                },
              ),
      child:
          _hasError
              ? widget.fallback ??
                  const Icon(Icons.person, size: 32, color: Colors.grey)
              : null,
    );
  }
}
