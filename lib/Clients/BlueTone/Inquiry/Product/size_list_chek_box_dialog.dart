import 'package:flutter/material.dart';
import 'package:for_practice_the_app/Clients/BlueTone/bluetone_model/price_model.dart';
import 'package:for_practice_the_app/blocs/base/base_bloc.dart';
import 'package:for_practice_the_app/ui/res/color_resources.dart';
import 'package:for_practice_the_app/utils/offline_db_helper.dart';

class CheckboxListViewDialog extends StatefulWidget {
  List<PriceModel> arrinquiryShareModel = [];
  CheckboxListViewDialog(this.arrinquiryShareModel);

  @override
  _CheckboxListViewDialogState createState() => _CheckboxListViewDialogState();
}

class _CheckboxListViewDialogState extends State<CheckboxListViewDialog> {
  List<PriceModel> sizeList = [];

  @override
  void initState() {
    super.initState();
    sizeList.clear();
    for (int i = 0; i < widget.arrinquiryShareModel.length; i++) {
      sizeList.add(widget.arrinquiryShareModel[i]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => showDialog<bool>(
        context: context,
        builder: (c) => AlertDialog(
          title: Text('Alert'),
          content: Text('Do you really want to exit ?'),
          actions: [
            ElevatedButton(
              child: Text('Yes'),
              onPressed: () => sizedListCRUD(),
            ),
            ElevatedButton(
              child: Text('No'),
              onPressed: () => Navigator.pop(c, false),
            ),
          ],
        ),
      ),
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Select Items',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: colorPrimary,
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 16.0),
            Divider(
              height: 2,
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: sizeList.length,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    title: Text(sizeList[index].SizeName),
                    value: sizeList[index].isChecked == "true" ? true : false,
                    onChanged: (checked) {
                      setState(() {
                        String isCheecked = "";
                        if (checked == true) {
                          isCheecked = "true";
                        } else {
                          isCheecked = "false";
                        }
                        sizeList[index].isChecked = isCheecked;
                      });
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                sizedListCRUD();
              },
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(40.0),
                      bottomRight: Radius.circular(40.0),
                      topLeft: Radius.circular(40.0),
                      bottomLeft: Radius.circular(40.0)),
                ),
                child: Center(
                  child: Text("Submit"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void sizedListCRUD() async {
    ShowProgressIndicatorState(true);
    await OfflineDbHelper.getInstance()
        .deleteProductPriceList(sizeList[0].ProductID);

    List<String> sizedNameList = [];
    for (int i = 0; i < sizeList.length; i++) {
      await OfflineDbHelper.getInstance().insertProductPriceList(PriceModel(
          sizeList[i].ProductID.toString(),
          sizeList[i].ProductName.toString(),
          sizeList[i].SizeID.toString(),
          sizeList[i].SizeName.toString(),
          sizeList[i].isChecked));

      if (sizeList[i].isChecked == "true") {
        sizedNameList.add(sizeList[i].SizeName);
      }
    }

    ShowProgressIndicatorState(false);
    Navigator.of(context).pop(sizedNameList);
  }
}
