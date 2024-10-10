import 'dart:convert';
import 'package:flutter/material.dart';

class CustomAvatar extends StatefulWidget {
  final String name;
  final String? photo;
  final double size;
  final double fontSize;
  final Function? onTap;
  final bool canChangePhoto;
  final bool? isUrl;
  final String? defaultAsset;

  const CustomAvatar({
    required this.name,
    required this.size,
    required this.fontSize,
    super.key,
    this.photo,
    this.onTap,
    this.isUrl,
    this.defaultAsset,
    this.canChangePhoto = false,
  });

  @override
  State<CustomAvatar> createState() => _CustomAvatarState();
}

class _CustomAvatarState extends State<CustomAvatar> {
  Widget _buildAvatar() {
    String trimedName = widget.name.trim();
    List<String> nameParts = trimedName.split(' ');

    String initials = '';
    if (nameParts.length >= 2) {
      initials = nameParts[0][0] + nameParts[1][0];
    } else if (nameParts.isNotEmpty && nameParts[0].isNotEmpty) { 
      initials = nameParts[0][0];
    }

    return CircleAvatar(
      backgroundColor: Theme.of(context).primaryColor,
      radius: widget.size,
      child: Text(
        initials.toUpperCase(),
        style: TextStyle(color: Theme.of(context).primaryColorLight, fontSize: widget.fontSize),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onTap!(),
      child: Stack(
        children: [
          ((widget.photo != null && widget.photo!.isNotEmpty) || widget.defaultAsset != null)
              ? CircleAvatar(
                  radius: widget.size,
                  backgroundImage:
                      widget.defaultAsset != null && widget.photo == null ? AssetImage(widget.defaultAsset!) : (widget.isUrl != null && widget.isUrl! ? NetworkImage(widget.photo!) as ImageProvider<Object> : MemoryImage(base64Decode(widget.photo!)) as ImageProvider<Object>),
                )
              : _buildAvatar(),
          widget.canChangePhoto
              ? Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: widget.size / 2,
                    height: widget.size / 2,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.camera_alt,
                      size: widget.size / 3,
                      color: Colors.white,
                    ),
                  ),
                )
              : const SizedBox(height: 0),
        ],
      ),
    );
  }
}
