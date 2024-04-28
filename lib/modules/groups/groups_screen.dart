import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mal/model/group_model.dart';
import 'package:mal/modules/groups/group_data.dart';
import 'package:mal/modules/groups/bloc/groups_cubit.dart';
import 'package:mal/modules/groups/create_group_dialog.dart';
import 'package:mal/modules/groups/group_item.dart';
import 'package:mal/shared/components/app_routes.dart';
import 'package:uuid/uuid.dart';

import '../../shared/styles/colors.dart';
import '../../shared/styles/text_styles.dart';
import '../../translations/locale_keys.g.dart';
import 'bloc/create_group_cubit.dart';
import 'bloc/groups_state.dart';
import 'bloc/groups_ui_cubit.dart';
import 'confirm_delete_dialog.dart';

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({Key? key}) : super(key: key);

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  late GroupsCubit groupsCubit;
  late GroupsUiCubit groupsUiCubit;
  late CreateGroupCubit createGroupCubit;
  late TextEditingController createGroupController;
  late List<GroupData> groupsData;

  @override
  void initState() {
    super.initState();
    groupsData = [];
    groupsCubit = GroupsCubit(const Uuid());
    groupsUiCubit = GroupsUiCubit(const Uuid());
    groupsCubit.getGroups();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleKeys.groups.tr(),
          style: headingStyle,
        ),
        titleTextStyle: headingStyle,
        centerTitle: false,
        backgroundColor: kYellow,
        elevation: 0,
        toolbarHeight: 78.h,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25.r),
            bottomRight: Radius.circular(25.r),
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            size: 35.sp,
            color: kBlack,
          ),
        ),
        actions: [
          BlocBuilder<GroupsUiCubit, GroupsState>(
            bloc: groupsUiCubit,
            builder: (context, state) {
              if (state is EditGroupsState) {
                return const SizedBox(
                  width: 0,
                );
              }
              return IconButton(
                  onPressed: () {
                    for (int i = 0; i < groupsData.length; i++) {
                      groupsData[i].isEditShown = true;
                    }
                    groupsUiCubit.showEdit(0);
                  },
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.black,
                  ));
            },
          ),
          BlocBuilder<GroupsUiCubit, GroupsState>(
            bloc: groupsUiCubit,
            builder: (context, state) {
              if (state is EditGroupsState) {
                var list = <PopupMenuItem<String>>[];

                if (state.selectedCount == 1) {
                  list.add(
                    PopupMenuItem(
                      child: Text(LocaleKeys.delete
                          .tr(args: [state.selectedCount.toString()])),
                      value: "delete",
                    ),
                  );
                  list.add(
                    PopupMenuItem(
                      child: Text(LocaleKeys.edit.tr()),
                      value: "edit",
                    ),
                  );
                } else if (state.selectedCount > 1) {
                  list.add(
                    PopupMenuItem(
                      child: Text(LocaleKeys.delete
                          .tr(args: [state.selectedCount.toString()])),
                      value: "delete",
                    ),
                  );
                }
                list.add(
                  PopupMenuItem(
                    child: Text(LocaleKeys.cancel.tr()),
                    value: "cancel",
                  ),
                );
                return PopupMenuButton<String>(
                  itemBuilder: (context) => list,
                  onSelected: (value) {
                    if (value == "cancel") {
                      for (int i = 0; i < groupsData.length; i++) {
                        groupsData[i].isEditShown = false;
                        groupsData[i].isSelected = false;
                      }
                      groupsUiCubit.hideEdit();
                    } else if (value == "edit") {
                      var selectedGroup = GroupData(0, "", 0, false, false);
                      for (int i = 0; i < groupsData.length; i++) {
                        if (groupsData[i].isSelected) {
                          selectedGroup = groupsData[i];
                          break;
                        }
                      }
                      createGroupCubit = CreateGroupCubit(const Uuid());
                      createGroupController =
                          TextEditingController(text: selectedGroup.name ?? "");
                      AlertDialog alert = AlertDialog(
                        content: CreateGroupDialog(createGroupController, true),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0))),
                        insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
                        actionsPadding: const EdgeInsetsDirectional.only(end: 4, bottom: 8),
                        contentPadding: const EdgeInsetsDirectional.only(start: 12, end: 12, top: 16, bottom: 16),
                        actions: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              LocaleKeys.cancel.tr(),
                              style: cancelStyle,
                            ),
                          ),
                          BlocListener<CreateGroupCubit, GroupsState>(
                            listener: (context, state) {
                              if (state is LoadedCreateGroupState) {
                                Navigator.of(context).pop();
                                groupsCubit.getGroups();
                                groupsUiCubit.hideEdit();
                              }
                            },
                            bloc: createGroupCubit,
                            child: BlocBuilder<CreateGroupCubit, GroupsState>(
                                bloc: createGroupCubit,
                                builder: (context, state) {
                                  if (state is LoadingCreateGroupState) {
                                    return SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        color: kYellow,
                                      ),
                                    );
                                  }
                                  return InkWell(
                                    onTap: () {
                                      if (createGroupController
                                          .text.isNotEmpty) {
                                        createGroupCubit.editGroup(
                                            createGroupController.text,
                                            selectedGroup.id);
                                      }
                                    },
                                    child: Text(
                                      LocaleKeys.edit.tr(),
                                      style: titleForActionFieldStyle,
                                    ),
                                  );
                                }),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                        ],
                      );
                      showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (BuildContext context) {
                          return alert;
                        },
                      );
                    } else if (value == "delete") {
                      List<GroupData> selectedGroups = <GroupData>[];
                      for (int i = 0; i < groupsData.length; i++) {
                        if (groupsData[i].isSelected) {
                          selectedGroups.add(groupsData[i]);
                        }
                      }
                      createGroupCubit = CreateGroupCubit(const Uuid());
                      AlertDialog alert = AlertDialog(
                        content: ConfirmDeleteDialog(selectedGroups.length),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0))),
                        insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
                        actions: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              LocaleKeys.no.tr(),
                              style: cancelStyle,
                            ),
                          ),
                          BlocListener<CreateGroupCubit, GroupsState>(
                            listener: (context, state) {
                              if (state is LoadedCreateGroupState) {
                                Navigator.of(context).pop();
                                groupsCubit.getGroups();
                                groupsUiCubit.hideEdit();
                              }
                            },
                            bloc: createGroupCubit,
                            child: BlocBuilder<CreateGroupCubit, GroupsState>(
                                bloc: createGroupCubit,
                                builder: (context, state) {
                                  if (state is LoadingCreateGroupState) {
                                    return SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        color: kYellow,
                                      ),
                                    );
                                  }
                                  return InkWell(
                                    onTap: () {
                                      createGroupCubit.deleteGroups(
                                          selectedGroups
                                              .map((e) => e.id)
                                              .toList());
                                    },
                                    child: Text(
                                      LocaleKeys.yes.tr(),
                                      style: titleForActionFieldStyle,
                                    ),
                                  );
                                }),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                        ],
                      );
                      showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (BuildContext context) {
                          return alert;
                        },
                      );
                    }
                  },
                  icon: const Icon(
                    Icons.more_horiz,
                    color: Colors.black,
                  ),
                );
              }
              return IconButton(
                onPressed: () async {
                  createGroupCubit = CreateGroupCubit(const Uuid());
                  createGroupController = TextEditingController();
                  AlertDialog alert = AlertDialog(
                    content: CreateGroupDialog(createGroupController, false),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0))),
                    insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
                    actionsPadding: const EdgeInsetsDirectional.only(end: 4, bottom: 8),
                    contentPadding: const EdgeInsetsDirectional.only(start: 12, end: 12, top: 16, bottom: 16),
                    actions: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          LocaleKeys.cancel.tr(),
                          style: cancelStyle,
                        ),
                      ),
                      BlocListener<CreateGroupCubit, GroupsState>(
                        listener: (context, state) {
                          if (state is LoadedCreateGroupState) {
                            Navigator.of(context).pop();
                            groupsCubit.getGroups();
                          }
                        },
                        bloc: createGroupCubit,
                        child: BlocBuilder<CreateGroupCubit, GroupsState>(
                            bloc: createGroupCubit,
                            builder: (context, state) {
                              if (state is LoadingCreateGroupState) {
                                return SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    color: kYellow,
                                  ),
                                );
                              }
                              return InkWell(
                                onTap: () {
                                  if (createGroupController.text.isNotEmpty) {
                                    createGroupCubit.createGroup(
                                        createGroupController.text);
                                  }
                                },
                                child: Text(
                                  LocaleKeys.create.tr(),
                                  style: titleForActionFieldStyle,
                                ),
                              );
                            }),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                    ],
                  );
                  showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext context) {
                      return alert;
                    },
                  );
                },
                icon: const Icon(
                  Icons.add_circle,
                  color: Colors.black,
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<GroupsCubit, GroupsState>(
        bloc: groupsCubit,
        builder: (context, state) {
          if (state is LoadedGroupsState) {
            if (state.success) {
              groupsData = getDataOfResponse(state.groups);
              return BlocBuilder<GroupsUiCubit, GroupsState>(
                bloc: groupsUiCubit,
                builder: (context, state) {
                  if (state is InitialGroupsState) {
                    for (int i = 0; i < groupsData.length; i++) {
                      groupsData[i].isEditShown = false;
                    }
                  } else if (state is EditGroupsState) {
                    for (int i = 0; i < groupsData.length; i++) {
                      groupsData[i].isEditShown = true;
                    }
                  }
                  return ListView.builder(
                    itemCount: groupsData.length,
                    padding: const EdgeInsetsDirectional.only(bottom: 16),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () async{
                          await Navigator.of(context)
                              .pushNamed(AppRoutes.groupLeaders, arguments: {
                                "group_id": groupsData[index].id,
                            "name":groupsData[index].name
                          });
                          groupsCubit.getGroups();
                        },
                        child: GroupItem(
                          groupsData[index],
                          () {
                            int selectedCount = 0;
                            for (int i = 0; i < groupsData.length; i++) {
                              if (groupsData[i].isSelected) {
                                selectedCount++;
                              }
                            }
                            groupsUiCubit.showEdit(selectedCount);
                          },
                        ),
                      );
                    },
                  );
                },
              );
            }
            return Container(
              alignment: Alignment.center,
              child: const Text("error"),
            );
          }
          return Container(
            margin: const EdgeInsets.only(top: 16),
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: 48,
              height: 48,
              child: CircularProgressIndicator(
                color: kYellow,
              ),
            ),
          );
        },
      ),
    );
  }

  List<GroupData> getDataOfResponse(List<GroupModel>? groups) {
    List<GroupData> data = [];
    for (int i = 0; i < (groups?.length ?? 0); i++) {
      data.add(GroupData(groups![i].id, groups[i].title,
          groups[i].contacts?.length, false, false));
    }
    return data;
  }
}
