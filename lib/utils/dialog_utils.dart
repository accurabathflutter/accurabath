import 'package:flutter/material.dart';
import 'package:for_practice_the_app/ui/res/color_resources.dart';
import 'package:for_practice_the_app/ui/res/image_resources.dart';
import 'package:for_practice_the_app/utils/image_full_screen.dart';

class DialogUtils {
  static DialogUtils _instance = new DialogUtils.internal();

  DialogUtils.internal();

  factory DialogUtils() => _instance;

  static showCustomDialog(BuildContext context,
      {@required String title,
      String details,
      String okBtnText = "Ok",
      String cancelBtnText = "Cancel",
      @required Function okBtnFunction}) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text(title),
            content: Text(details),
            actions: <Widget>[
              Visibility(
                visible: false,
                child: ElevatedButton(
                  child: Text(okBtnText),
                  onPressed: okBtnFunction,
                ),
              ),
              ElevatedButton(
                  child: Text(cancelBtnText),
                  onPressed: () => Navigator.pop(context))
            ],
          );
        });
  }

  static imageDialog(text, path, context, bool isImageExist, String Address) {
    return Dialog(
      // backgroundColor: Colors.transparent,
      // elevation: 0,
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$text',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.close_rounded),
                    color: Colors.redAccent,
                  ),
                ],
              ),
            ),
            Container(
              /*width: 220,
              height: 200,*/
              padding: EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 200,
                      child: Center(
                          child: ImageFullScreenWrapperWidget(
                        child: Image.network(
                          '$path',
                          frameBuilder:
                              (context, child, frame, wasSynchronouslyLoaded) {
                            return child;
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              return Image.asset(
                                LOADDER,
                                height: 100,
                                width: 100,
                              );
                            }
                          },
                          errorBuilder: (BuildContext context, Object exception,
                              StackTrace stackTrace) {
                            return Image.asset(
                              NO_IMAGE_FOUND,
                              height: 100,
                              width: 100,
                            );
                          },

                          // fit: BoxFit.fill,
                        ),
                      )),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Address : ",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: colorPrimary),
                    ),
                    Text(
                      Address == null || Address == ""
                          ? "No Address Found"
                          : Address,
                      style: TextStyle(fontSize: 12, color: colorBlack),
                    )
                  ],
                ),
              ),
            ),
            isImageExist == false ? Text("No Image Uploaded") : Container(),
          ],
        ),
      ),
    );
  }
}
