import 'package:basic/Components/cust_fontstyle.dart';
import 'package:basic/helpers/app_init.dart';
import 'package:basic/main_menu/FUNC/control_main.dart';
import 'package:basic/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {


    return ChangeNotifierProvider(
      create: (context) => MainController(),
      child: Consumer<MainController>(
        builder: (context, MainController, child) {
          return Scaffold(
            body: Stack(
              children: [
                Image.asset(
                  AppImage().START,
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                ),
                Positioned(
                  bottom: setResponsiveSize(context, baseSize: 171),
                  right: setResponsiveSize(context, baseSize: 60),
                  left: setResponsiveSize(context, baseSize: 60),
                  child: ElevatedButton(
                    onPressed: () {
                      MainController.checkPlayerData(context);
                    },
                    style: ButtonStyle(
                      padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                          const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 18)),
                      elevation: WidgetStateProperty.all<double>(4),
                      backgroundColor:
                          WidgetStateProperty.all<Color>(AppColor().yellow),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          side: BorderSide(color: AppColor().white, width: 4),
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                      ),
                    ),
                    child: CustFontstyle(
                      label: 'Maglaro na!',
                      fontsize: 25,
                      fontcolor: AppColor().black,
                      fontweight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
