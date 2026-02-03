import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:islami/core/utils/app_colors.dart';

AppBar customAppBar(BuildContext context, String? title) {
    return AppBar(
        automaticallyImplyLeading: false,
        leading: BackButton(
          color: AppColors.primaryColor,
          onPressed: () {
            context.pop();
          },
        ),
        backgroundColor:AppColors.backgroundColor,
        forceMaterialTransparency: true,
        title:  Text(
          title??'Suora Screen',
          style: TextStyle(color: AppColors.primaryColor),
        ),
        centerTitle: true,
      );
  }