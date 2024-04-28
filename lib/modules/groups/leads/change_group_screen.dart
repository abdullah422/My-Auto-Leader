import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mal/modules/groups/bloc/groups_cubit.dart';
import 'package:mal/modules/groups/group_item.dart';
import 'package:mal/modules/groups/leads/bloc/change_contact_group_cubit.dart';
import 'package:uuid/uuid.dart';

import '../../../model/group_model.dart';
import '../../../shared/styles/colors.dart';
import '../../../shared/styles/text_styles.dart';
import '../../../translations/locale_keys.g.dart';
import '../bloc/groups_state.dart';
import '../group_data.dart';
import 'bloc/leads_state.dart';
import 'confirm_group_changing_dialog.dart';

class ChangeGroupScreen extends StatefulWidget {
  const ChangeGroupScreen(this.contactsIds, this.oldGroupId, {Key? key}) : super(key: key);
  final List<int> contactsIds;
  final int oldGroupId;
  @override
  State<ChangeGroupScreen> createState() => _ChangeGroupScreenState();
}

class _ChangeGroupScreenState extends State<ChangeGroupScreen> {
  late GroupsCubit groupsCubit;
  late ChangeContactGroupCubit changeCubit;
  late List<GroupData> groupsData;

  @override
  void initState() {
    super.initState();
    groupsData = [];
    var uuid = const Uuid();
    groupsCubit = GroupsCubit(uuid);
    groupsCubit.getGroups();
    changeCubit = ChangeContactGroupCubit(uuid);
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
      ),
      body: BlocBuilder<GroupsCubit, GroupsState>(
        bloc: groupsCubit,
        builder: (context, state) {
          if (state is LoadedGroupsState) {
            if (state.success) {
              groupsData = getDataOfResponse(state.groups);
              return ListView.builder(
                    itemCount: groupsData.length,
                    padding: const EdgeInsetsDirectional.only(bottom: 16),
                    itemBuilder: (context, index) {
                      if(groupsData[index].id == widget.oldGroupId){
                        return Container();
                      }
                      return InkWell(
                        onTap: () async{
                          AlertDialog alert = AlertDialog(
                            content: ConfirmGroupChangingDialog(groupsData[index].name??""),
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
                              BlocListener<ChangeContactGroupCubit, LeadsState>(
                                listener: (context, state) {
                                  if (state is LoadedCrudLeadState) {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                  }
                                },
                                bloc: changeCubit,
                                child: BlocBuilder<ChangeContactGroupCubit, LeadsState>(
                                    bloc: changeCubit,
                                    builder: (context, state) {
                                      if (state is LoadingCrudLeadsState) {
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
                                          changeCubit.changeGroup(
                                              widget.contactsIds,groupsData[index].id??0);
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
                        },
                        child: GroupItem(
                          groupsData[index],
                              () {

                          },
                        ),
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
