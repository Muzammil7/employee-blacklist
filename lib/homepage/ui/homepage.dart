import 'dart:convert';

import 'package:employeeblacklistdata/adduser/ui/adduser.dart';
import 'package:employeeblacklistdata/commonwidgets/appbutton.dart';
import 'package:employeeblacklistdata/commonwidgets/apptext.dart';
import 'package:employeeblacklistdata/homepage/controllers/homecontroller.dart';
import 'package:employeeblacklistdata/login/ui/loginpage.dart';
import 'package:employeeblacklistdata/res/colors.dart';
import 'package:employeeblacklistdata/res/size.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  static const String route = '/';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _aadhar = TextEditingController();
  dynamic _user;
  dynamic _employers;
  dynamic _view;
  dynamic _blackList;
  dynamic _searchList;
  dynamic _searches;

  @override
  void initState() {
    HomeController().startStream();
    _user = homeStream.map((HomeData data) => data.userData);
    _employers = homeStream.map((HomeData data) => data.employers);
    _view = homeStream.map((HomeData data) => data.view).distinct();
    _blackList = homeStream.map((HomeData data) => data.blacklists);
    _searchList = homeStream.map((HomeData data) => data.searchList);
    _searches = homeStream.map((HomeData data) => data.searches);
    HomeController().getUserData();
    super.initState();
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

                      //logout button

                      StreamBuilder(
                          stream: _user,
                          builder: (context, snapshot) {
                            if (homeData.userData.isNotEmpty) {
                              return Row(
                                children: [
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  AppButton(
                                    padding: 0,
                                    text: 'Logout',
                                    ontap: () {
                                      HomeController().logout();
                                    },
                                    color: Colors.transparent,
                                    textColor: Colors.red,
                                  )
                                ],
                              );
                            }
                            return Container();
                          })
                    ],
                  )),
              const SizedBox(
                height: 20,
              ),

              //search employee from blacklist database

              Container(
                width:
                    Dts(context).width > 650 ? 600 : Dts(context).width * 0.9,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(12)),
                child: Column(
                  children: [
                    const AppText(
                        text: 'Search for Employee with Aadhar Number',
                        size: 16),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 50,
                      width: Dts(context).width > 650
                          ? 400
                          : Dts(context).width * 0.7,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: theme)),
                      padding: const EdgeInsets.only(left: 20),
                      child: TextField(
                        controller: _aadhar,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter Aadhar number of employee',
                          hintStyle: GoogleFonts.cabin(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 14),
                        ),
                        style: GoogleFonts.cabin(
                            color: Colors.white, fontSize: 14),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),

                    //search button

                    AppButton(
                        text: 'Search',
                        ontap: () {
                          HomeController().searchEmployee(_aadhar.text);
                        }),

                    //blacklisted data of the searched id

                    StreamBuilder(
                        stream: _searches,
                        builder: (context, snapshot) {
                          if (homeData.searches != '') {
                            return Column(
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                AppText(
                                    text:
                                        '${homeData.searchList.length} company has marked him as a blacklist',
                                    size: 14),
                              ],
                            );
                          }
                          return Container();
                        }),
                    StreamBuilder(
                        stream: _searchList,
                        builder: (context, snapshot) {
                          if (homeData.searchList.isNotEmpty) {
                            return Column(
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  children: homeData.searchList
                                      .asMap()
                                      .map((k, value) {
                                        List images =
                                            homeData.searchList[k]['images'];
                                        return MapEntry(
                                            k,
                                            StreamBuilder(
                                                stream: _view,
                                                builder: (context, snapshot) {
                                                  return Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                AppText(
                                                                    text:
                                                                        '${k + 1}. ${homeData.searchList[k]['company']}',
                                                                    size: 14),
                                                                if (homeData
                                                                        .view ==
                                                                    homeData.searchList[
                                                                            k][
                                                                        'company'])
                                                                  Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      const SizedBox(
                                                                        height:
                                                                            10,
                                                                      ),
                                                                      AppText(
                                                                          text:
                                                                              'Name : ${homeData.searchList[k]['name']}',
                                                                          size:
                                                                              14),
                                                                      const SizedBox(
                                                                        height:
                                                                            10,
                                                                      ),
                                                                      AppText(
                                                                          text:
                                                                              'Aadhar No : ${homeData.searchList[k]['aadhar']}',
                                                                          size:
                                                                              14),
                                                                      const SizedBox(
                                                                        height:
                                                                            10,
                                                                      ),
                                                                      AppText(
                                                                          text: homeData.searchList[k]
                                                                              [
                                                                              'issues'],
                                                                          size:
                                                                              14),
                                                                      const SizedBox(
                                                                        height:
                                                                            10,
                                                                      ),
                                                                      Column(
                                                                          children: images
                                                                              .asMap()
                                                                              .map((k, value) => MapEntry(
                                                                                  k,
                                                                                  Container(
                                                                                    margin: const EdgeInsets.only(bottom: 20),
                                                                                    child: Image.memory(
                                                                                      base64Decode(images[k]),
                                                                                      width: 400,
                                                                                      fit: BoxFit.contain,
                                                                                    ),
                                                                                  )))
                                                                              .values
                                                                              .toList()),
                                                                    ],
                                                                  )
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      RotatedBox(
                                                          quarterTurns: (homeData
                                                                      .view ==
                                                                  homeData.searchList[
                                                                          k][
                                                                      'company'])
                                                              ? 2
                                                              : 0,
                                                          child: IconButton(
                                                            onPressed: () {
                                                              if (homeData
                                                                      .view ==
                                                                  homeData.searchList[
                                                                          k][
                                                                      'company']) {
                                                                homeData.view =
                                                                    '';
                                                              } else {
                                                                homeData
                                                                    .view = homeData
                                                                        .searchList[k]
                                                                    ['company'];
                                                              }
                                                              homeController
                                                                  .add(
                                                                      homeData);
                                                            },
                                                            icon: const Icon(Icons
                                                                .arrow_drop_down),
                                                            color: Colors.white,
                                                          ))
                                                    ],
                                                  );
                                                }));
                                      })
                                      .values
                                      .toList(),
                                )
                              ],
                            );
                          }
                          return Container();
                        })
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),

              // add employee to black list for users and approve or decline user for admin

              StreamBuilder(
                  stream: _user,
                  builder: (context, snapshot) {
                    if (homeData.userData.isEmpty ||
                        (homeData.userData.isNotEmpty &&
                            homeData.userData['role'] == 'user')) {
                      return Container(
                        width: Dts(context).width > 650
                            ? 600
                            : Dts(context).width * 0.9,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(12)),
                        child: Column(
                          children: [
                            const AppText(
                                text: 'Add Employee to the Blacklist Database',
                                size: 16),
                            const SizedBox(
                              height: 20,
                            ),
                            (homeData.userData.isEmpty ||
                                    (homeData.userData.isNotEmpty &&
                                        homeData.userData['status'] == '1'))
                                ? AppButton(
                                    text: (homeData.userData.isEmpty)
                                        ? 'Login or Register'
                                        : 'Add Employee',
                                    ontap: () {
                                      if (homeData.userData.isEmpty) {
                                        Navigator.pushNamed(
                                            context, LoginPage.route);
                                      } else {
                                        Navigator.pushNamed(
                                            context, AddUser.route);
                                      }
                                    })
                                : SizedBox(
                                    width: Dts(context).width > 650
                                        ? 500
                                        : Dts(context).width * 0.7,
                                    child: AppText(
                                      text: (homeData.userData['status'] == '0')
                                          ? 'Waiting for approval. Our executives will contact you with in 24 hours for your comapny verification'
                                          : 'Your Account is declined for failed verification',
                                      size: 14,
                                      align: TextAlign.center,
                                      color:
                                          (homeData.userData['status'] == '0')
                                              ? Colors.orange
                                              : Colors.red,
                                    ),
                                  ),

                            //blacklisted data by current user

                            StreamBuilder(
                                stream: _blackList,
                                builder: (context, snapshot) {
                                  if (homeData.blacklists.isNotEmpty &&
                                      homeData.blacklists.isNotEmpty) {
                                    // List blackLists = homeData.blacklists;
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        const AppText(
                                            text: 'My BlackLists', size: 14),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Column(
                                          children: homeData.blacklists
                                              .asMap()
                                              .map((k, v) {
                                                List images = homeData
                                                    .blacklists[k]['images'];
                                                return MapEntry(
                                                    k,
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  AppText(
                                                                      text:
                                                                          '${k + 1}. ${homeData.blacklists[k]['name']}',
                                                                      size: 14),
                                                                  if (homeData
                                                                          .view ==
                                                                      homeData.blacklists[
                                                                              k]
                                                                          [
                                                                          'aadhar'])
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        const SizedBox(
                                                                          height:
                                                                              10,
                                                                        ),
                                                                        AppText(
                                                                            text:
                                                                                'Aadhar No : ${homeData.blacklists[k]['aadhar']}',
                                                                            size:
                                                                                14),
                                                                        const SizedBox(
                                                                          height:
                                                                              10,
                                                                        ),
                                                                        AppText(
                                                                            text:
                                                                                homeData.blacklists[k]['issues'],
                                                                            size: 14),
                                                                        const SizedBox(
                                                                          height:
                                                                              10,
                                                                        ),
                                                                        SizedBox(
                                                                          width: Dts(context).width > 650
                                                                              ? 500
                                                                              : Dts(context).width * 0.7,
                                                                          child:
                                                                              SingleChildScrollView(
                                                                            scrollDirection:
                                                                                Axis.horizontal,
                                                                            child: Row(
                                                                                children: images
                                                                                    .asMap()
                                                                                    .map((k, value) => MapEntry(
                                                                                        k,
                                                                                        Container(
                                                                                          margin: const EdgeInsets.only(right: 20),
                                                                                          child: Image.memory(
                                                                                            base64Decode(images[k]),
                                                                                            height: 100,
                                                                                          ),
                                                                                        )))
                                                                                    .values
                                                                                    .toList()),
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                          height:
                                                                              10,
                                                                        ),
                                                                        AppButton(
                                                                          text:
                                                                              'Remove from BlackList',
                                                                          ontap:
                                                                              () {
                                                                            HomeController().removeFromBlackList('${homeData.blacklists[k]['aadhar']}::${homeData.userData['email']}');
                                                                          },
                                                                          color:
                                                                              Colors.green,
                                                                        )
                                                                      ],
                                                                    )
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        RotatedBox(
                                                            quarterTurns: (homeData
                                                                        .view ==
                                                                    homeData.blacklists[
                                                                            k][
                                                                        'aadhar'])
                                                                ? 2
                                                                : 0,
                                                            child: IconButton(
                                                              onPressed: () {
                                                                if (homeData
                                                                        .view ==
                                                                    homeData.blacklists[
                                                                            k][
                                                                        'aadhar']) {
                                                                  homeData.view =
                                                                      '';
                                                                } else {
                                                                  homeData
                                                                      .view = homeData
                                                                          .blacklists[k]
                                                                      [
                                                                      'aadhar'];
                                                                }
                                                                homeController
                                                                    .add(
                                                                        homeData);
                                                              },
                                                              icon: const Icon(Icons
                                                                  .arrow_drop_down),
                                                              color:
                                                                  Colors.white,
                                                            ))
                                                      ],
                                                    ));
                                              })
                                              .values
                                              .toList(),
                                        )
                                      ],
                                    );
                                  }
                                  return Container();
                                })
                          ],
                        ),
                      );
                    }

                    // registered user shown to admin

                    return Container(
                      width: Dts(context).width > 650
                          ? 600
                          : Dts(context).width * 0.9,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        children: [
                          const AppText(text: 'Registered Users', size: 16),
                          const SizedBox(
                            height: 20,
                          ),
                          StreamBuilder(
                              stream: _employers,
                              builder: (context, snapshot) {
                                if (homeData.employers.isNotEmpty &&
                                    homeData.employers.isNotEmpty) {
                                  // List employers = homeData.employers;
                                  return Column(
                                    children: homeData.employers
                                        .asMap()
                                        .map((k, v) => MapEntry(
                                            k,
                                            (homeData.employers[k]['role'] !=
                                                    'admin')
                                                ? Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    width: Dts(context).width >
                                                            650
                                                        ? 560
                                                        : Dts(context).width *
                                                            0.8,
                                                    child:
                                                        StreamBuilder<Object>(
                                                            stream: _view,
                                                            builder: (context,
                                                                snapshot) {
                                                              return Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Expanded(
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        AppText(
                                                                            text:
                                                                                '${k + 1}. ${homeData.employers[k]['name']}',
                                                                            size:
                                                                                14,
                                                                            color: (homeData.employers[k]['status'] == '0')
                                                                                ? Colors.orange
                                                                                : (homeData.employers[k]['status'] == '1')
                                                                                    ? Colors.green
                                                                                    : Colors.red),
                                                                        if (homeData.view ==
                                                                            homeData.employers[k]['email'])
                                                                          Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              const SizedBox(
                                                                                height: 10,
                                                                              ),
                                                                              AppText(text: 'Company : ${homeData.employers[k]['company']}', size: 14),
                                                                              const SizedBox(
                                                                                height: 10,
                                                                              ),
                                                                              AppText(text: 'Email : ${homeData.employers[k]['email']}', size: 14),
                                                                              const SizedBox(
                                                                                height: 10,
                                                                              ),
                                                                              AppText(text: 'Mobile : ${homeData.employers[k]['phone']}', size: 14),
                                                                              const SizedBox(
                                                                                height: 10,
                                                                              ),
                                                                              AppText(
                                                                                text: (homeData.employers[k]['status'] == '0')
                                                                                    ? 'Waiting for Approval'
                                                                                    : (homeData.employers[k]['status'] == '1')
                                                                                        ? 'Approved'
                                                                                        : 'Declined',
                                                                                size: 14,
                                                                                color: (homeData.employers[k]['status'] == '0')
                                                                                    ? Colors.orange
                                                                                    : (homeData.employers[k]['status'] == '1')
                                                                                        ? Colors.green
                                                                                        : Colors.red,
                                                                              ),
                                                                              const SizedBox(
                                                                                height: 10,
                                                                              ),
                                                                              Row(
                                                                                children: [
                                                                                  if (homeData.employers[k]['status'] == '0' || homeData.employers[k]['status'] == '1')
                                                                                    Row(
                                                                                      children: [
                                                                                        AppButton(
                                                                                          text: 'Decline',
                                                                                          ontap: () {
                                                                                            HomeController().statusUpdate(homeData.employers[k]['email'], '2');
                                                                                          },
                                                                                          color: Colors.red,
                                                                                        ),
                                                                                        const SizedBox(
                                                                                          width: 20,
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  if (homeData.employers[k]['status'] == '0' || homeData.employers[k]['status'] == '2')
                                                                                    AppButton(
                                                                                      text: 'Approve',
                                                                                      ontap: () {
                                                                                        HomeController().statusUpdate(homeData.employers[k]['email'], '1');
                                                                                      },
                                                                                      color: Colors.green,
                                                                                    )
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  RotatedBox(
                                                                      quarterTurns:
                                                                          (homeData.view == homeData.employers[k]['email'])
                                                                              ? 2
                                                                              : 0,
                                                                      child:
                                                                          IconButton(
                                                                        onPressed:
                                                                            () {
                                                                          if (homeData.view ==
                                                                              homeData.employers[k]['email']) {
                                                                            homeData.view =
                                                                                '';
                                                                          } else {
                                                                            homeData.view =
                                                                                homeData.employers[k]['email'];
                                                                          }
                                                                          homeController
                                                                              .add(homeData);
                                                                        },
                                                                        icon: const Icon(
                                                                            Icons.arrow_drop_down),
                                                                        color: Colors
                                                                            .white,
                                                                      ))
                                                                ],
                                                              );
                                                            }),
                                                  )
                                                : Container()))
                                        .values
                                        .toList(),
                                  );
                                }
                                return Container();
                              })
                        ],
                      ),
                    );
                  }),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
