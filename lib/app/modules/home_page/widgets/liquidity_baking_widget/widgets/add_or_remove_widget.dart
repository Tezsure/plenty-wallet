import 'package:flutter/material.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

class AddOrRemoveWiget extends StatefulWidget {
  const AddOrRemoveWiget({Key? key,required this.onChanged}) : super(key: key);
  final ValueChanged<bool> onChanged;

  @override
  State<AddOrRemoveWiget> createState() => _AddOrRemoveWigetState();
}

class _AddOrRemoveWigetState extends State<AddOrRemoveWiget> {
  bool add = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.08.width,
      width: 0.42.width,
      decoration: BoxDecoration(
        color: ColorConst.Tertiary.shade90,
        borderRadius: BorderRadius.circular(0.02.height),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            alignment: add ? Alignment.centerLeft : Alignment.centerRight,
            duration: const Duration(milliseconds: 100),
            child: Container(
              height: 0.08.width,
              width: 0.21.width,
              padding: EdgeInsets.zero,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(0.02.height),
              ),
            ),
          ),
          Row(
            children: [
              customButton(title: "Add", selected: add),
              customButton(title: "Remove", selected: !add),
            ],
          )
        ],
      ),
    );
  }

  GestureDetector customButton({
    required String title,
    required bool selected,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (!selected) {
            add = !add;
          }
          widget.onChanged(add);
        });
      },
      child: Container(
        height: 0.08.width,
        width: 0.21.width,
        alignment: Alignment.center,
        child: Text(
          title,
          style: labelSmall.copyWith(
              color: selected ? Colors.white : ColorConst.Tertiary),
        ),
      ),
    );
  }
}
