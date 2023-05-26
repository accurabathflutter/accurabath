import 'package:flutter/material.dart';
import 'package:for_practice_the_app/Clients/BlueTone/bluetone_model/price_model.dart';

class SizedCheckList extends StatefulWidget {
  final List<PriceModel> SizedcheckList;
  const SizedCheckList(this.SizedcheckList);

  @override
  State<SizedCheckList> createState() => _SizedCheckListState();
}

class _SizedCheckListState extends State<SizedCheckList> {
  @override
  Widget build(BuildContext context) {
    // List<PriceModel> SizedcheckListsd = widget.SizedcheckList;

    return Scaffold(
      body: ListView.builder(
        itemBuilder: (context, index) {
          return Text(widget.SizedcheckList[index].SizeName);
        },
        itemCount: widget.SizedcheckList.length,
      ),
    );
  }
}
