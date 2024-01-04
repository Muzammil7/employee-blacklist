import 'dart:convert';

import 'package:employeeblacklistdata/adduser/controllers/addusercontroller.dart';
import 'package:employeeblacklistdata/commonwidgets/appbutton.dart';
import 'package:employeeblacklistdata/commonwidgets/apptext.dart';
import 'package:employeeblacklistdata/commonwidgets/apptextfield.dart';
import 'package:employeeblacklistdata/res/colors.dart';
import 'package:employeeblacklistdata/res/size.dart';
import 'package:flutter/material.dart';

class AddUser extends StatefulWidget {
  static const String route = '/add-user';
  const AddUser({super.key});

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _aadhar = TextEditingController();
  final TextEditingController _issue = TextEditingController();
  dynamic _images;
  dynamic _error;

  @override
  void initState() {
    AddUserController().startStream();
    _images = addUserStream.map((AddUserData data) => data.images);
    _error = addUserStream.map((AddUserData data) => data.error).distinct();
    super.initState();
  }

  @override
  void dispose() {
    addUserController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Container(
          padding: EdgeInsets.only(left: Dts(context).width * 0.05),
          height: Dts(context).height,
          width: Dts(context).width,
          child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                const SizedBox(
                  height: 50,
                ),
                SizedBox(
                  width: Dts(context).width * 0.9,
                  child: Row(
                    children: [
                      Expanded(
                          child: AppText(
                        text: 'Employee Blacklist Data',
                        size: 28,
                        weight: FontWeight.w600,
                        color: theme,
                      )),
                    ],
                  ),
                ),

                // input fields for blacklist user data

                const SizedBox(
                  height: 20,
                ),
                Container(
                  width:
                      Dts(context).width > 650 ? 600 : Dts(context).width * 0.9,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    children: [
                      AppTextField(
                          controller: _name, hint: 'Enter Employer Name'),
                      const SizedBox(
                        height: 20,
                      ),
                      AppTextField(
                          controller: _aadhar, hint: 'Enter Aadhar Number'),
                      const SizedBox(
                        height: 20,
                      ),
                      AppTextField(
                        controller: _issue,
                        hint: 'Enter the issue faced with the employee briefly',
                        maxLines: 5,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      StreamBuilder<Object>(
                          stream: _images,
                          builder: (context, snapshot) {
                            if (addUSerData.images.isNotEmpty) {
                              return Column(
                                children: [
                                  SizedBox(
                                    width: Dts(context).width > 650
                                        ? 400
                                        : Dts(context).width * 0.7,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: addUSerData.images
                                            .asMap()
                                            .map((k, value) => MapEntry(
                                                k,
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 20),
                                                  child: Image.memory(
                                                    base64Decode(
                                                        addUSerData.images[k]),
                                                    height: 50,
                                                  ),
                                                )))
                                            .values
                                            .toList(),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                ],
                              );
                            }
                            return Container();
                          }),

                      // pick images for blacklist

                      InkWell(
                        onTap: () {
                          AddUserController().pickImages();
                        },
                        child: Container(
                          height: 52,
                          width: Dts(context).width > 650
                              ? 400
                              : Dts(context).width * 0.7,
                          // decoration: BoxDecoration(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: theme)),
                          padding: const EdgeInsets.only(left: 20),
                          alignment: Alignment.center,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AppText(
                                  text: 'Upload Images if available', size: 14),
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.cloud_upload_outlined,
                                size: 20,
                                color: Colors.white,
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                      // error text

                      StreamBuilder<Object>(
                          stream: _error,
                          builder: (context, snapshot) {
                            if (addUSerData.error != '') {
                              return Column(
                                children: [
                                  SizedBox(
                                    width: Dts(context).width > 650
                                        ? 500
                                        : Dts(context).width * 0.6,
                                    child: AppText(
                                      text: addUSerData.error,
                                      size: 14,
                                      color: Colors.red,
                                      align: TextAlign.center,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  )
                                ],
                              );
                            }
                            return Container();
                          }),

                      // bitton to submit blacklist data

                      AppButton(
                          text: 'Add to BlackList',
                          ontap: () {
                            if (_name.text.isNotEmpty &&
                                _aadhar.text.isNotEmpty &&
                                _issue.text.isNotEmpty) {
                              if (addUSerData.error != '') {
                                addUSerData.error = '';
                                addUserController.add(addUSerData);
                              }
                              AddUserController().addBlackListData(_name.text,
                                  _aadhar.text, _issue.text, context);
                            } else {
                              addUSerData.error =
                                  'please update required information to proceed';
                              addUserController.add(addUSerData);
                            }
                          })
                    ],
                  ),
                )
              ]))),
    );
  }
}
