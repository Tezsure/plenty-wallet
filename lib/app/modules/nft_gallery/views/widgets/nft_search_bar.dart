import 'package:flutter/material.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

import '../../../../../utils/colors/colors.dart';
import '../../../../../utils/styles/styles.dart';

class NFTSearchBar extends StatelessWidget {
  final bool isSearching;
  final GestureTapCallback? onTap;
  const NFTSearchBar({super.key, this.isSearching = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      curve: Curves.fastOutSlowIn,
      margin: isSearching ? EdgeInsets.all(10.sp) : EdgeInsets.zero,
      padding: isSearching ? EdgeInsets.only(bottom: 20.sp) : null,
      width: isSearching ? 0.95.width : null,
      child: Visibility(
        visible: isSearching,
        replacement: Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            onPressed: onTap,
            icon: const Icon(Icons.search),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            textAlignVertical: TextAlignVertical.center,
            textAlign: TextAlign.start,
            onEditingComplete: onTap,
            decoration: InputDecoration(
              filled: true,
              fillColor: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
              prefixIcon: Icon(
                Icons.search,
                color: ColorConst.NeutralVariant.shade60,
                size: 22,
              ),
              counterStyle: const TextStyle(backgroundColor: Colors.white),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none),
              hintText: 'Search baker',
              alignLabelWithHint: true,
              floatingLabelAlignment: FloatingLabelAlignment.center,
              hintStyle:
                  bodySmall.copyWith(color: ColorConst.NeutralVariant.shade70),
              labelStyle: labelSmall,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            ),
          ),
        ),
      ),
    );
  }
}
