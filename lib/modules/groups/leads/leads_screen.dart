import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mal/model/phone_model.dart';
import 'package:mal/modules/groups/leads/bloc/crud_leads_cubit.dart';
import 'package:mal/modules/groups/leads/bloc/leads_cubit.dart';
import 'package:mal/modules/groups/leads/bloc/leads_state.dart';
import 'package:mal/modules/groups/leads/lead_data.dart';
import 'package:mal/modules/groups/leads/leader_create_mode_dialog.dart';
import 'package:mal/modules/groups/leads/leads_list_item.dart';
import 'package:uuid/uuid.dart';

import '../../../model/contact_model.dart';
import '../../../shared/components/app_routes.dart';
import '../../../shared/styles/colors.dart';
import '../../../shared/styles/text_styles.dart';
import '../../../translations/locale_keys.g.dart';
import '../confirm_delete_dialog.dart';
import 'bloc/leads_ui_cubit.dart';

class LeadsScreen extends StatefulWidget {
  const LeadsScreen(this.groupId, this.name, {Key? key}) : super(key: key);
  final int groupId;
  final String name;

  @override
  State<LeadsScreen> createState() => _LeadsScreenState();
}

class _LeadsScreenState extends State<LeadsScreen> {
  late LeadsCubit leadsCubit;
  late LeadsUiCubit leadsUiCubit;
  late CrudLeadsCubit crudLeadsCubit;
  late List<LeadData> leadsData;

  @override
  void initState() {
    super.initState();
    leadsData = [];
    var uuid = const Uuid();
    leadsCubit = LeadsCubit(uuid);
    leadsUiCubit = LeadsUiCubit(uuid);
    crudLeadsCubit = CrudLeadsCubit(uuid);

    leadsCubit.getLeads(widget.groupId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.name,
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
          BlocBuilder<LeadsUiCubit, LeadsState>(
            bloc: leadsUiCubit,
            builder: (context, state) {
              if (state is EditLeadsState) {
                return const SizedBox(
                  width: 0,
                );
              }
              return IconButton(
                  onPressed: () {
                    for (int i = 0; i < leadsData.length; i++) {
                      leadsData[i].isEditShown = true;
                    }
                    leadsUiCubit.showEdit(0);
                  },
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.black,
                  ));
            },
          ),
          BlocBuilder<LeadsUiCubit, LeadsState>(
              bloc: leadsUiCubit,
              builder: (context, state) {
                if (state is EditLeadsState)  {
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
                    list.add(
                      PopupMenuItem(
                        child: Text(LocaleKeys.change_group_param.tr(args: [state.selectedCount.toString()])),
                        value: "change_group",
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
                    list.add(
                      PopupMenuItem(
                        child: Text(LocaleKeys.change_group_param.tr(args: [state.selectedCount.toString()])),
                        value: "change_group",
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
                    onSelected: (value) async{
                      if (value == "cancel") {
                        for (int i = 0; i < leadsData.length; i++) {
                          leadsData[i].isEditShown = false;
                          leadsData[i].isSelected = false;
                        }
                        leadsUiCubit.hideEdit();
                      } else if (value == "edit") {
                        LeadData? selectedLead;
                        for (int i = 0; i < leadsData.length; i++) {
                          if (leadsData[i].isSelected) {
                            selectedLead = leadsData[i];
                            break;
                          }
                        }
                        //todo open edit contact
                        await Navigator.of(context).pushNamed(AppRoutes.editLeader,
                            arguments: {"group_id": widget.groupId,
                            "lead_id":selectedLead?.id});
                        leadsCubit.getLeads(widget.groupId);
                        leadsUiCubit.hideEdit();
                      } else if (value == "delete") {
                        List<LeadData> selectedLeads = <LeadData>[];
                        for (int i = 0; i < leadsData.length; i++) {
                          if (leadsData[i].isSelected) {
                            selectedLeads.add(leadsData[i]);
                          }
                        }
                        crudLeadsCubit = CrudLeadsCubit(const Uuid());
                        AlertDialog alert = AlertDialog(
                          content: ConfirmDeleteDialog(selectedLeads.length),
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
                            BlocListener<CrudLeadsCubit, LeadsState>(
                              listener: (context, state) {
                                if (state is LoadedCrudLeadState) {
                                  Navigator.of(context).pop();
                                  leadsCubit.getLeads(widget.groupId);
                                  leadsUiCubit.hideEdit();
                                }
                              },
                              bloc: crudLeadsCubit,
                              child: BlocBuilder<CrudLeadsCubit, LeadsState>(
                                  bloc: crudLeadsCubit,
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
                                        crudLeadsCubit.deleteContacts(
                                            selectedLeads
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
                      } else if(value == "change_group"){
                        List<LeadData> selectedLeads = <LeadData>[];
                        for (int i = 0; i < leadsData.length; i++) {
                          if (leadsData[i].isSelected) {
                            selectedLeads.add(leadsData[i]);
                          }
                        }
                        await Navigator.of(context).pushNamed(AppRoutes.changeGroup,
                        arguments:
                        {"ids": selectedLeads.map((e) => e.id??0).toList(),
                        "oldId": widget.groupId}
                        );
                        leadsCubit.getLeads(widget.groupId);
                        leadsUiCubit.hideEdit();
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
                      AlertDialog alert = AlertDialog(
                        content: LeaderCreateModeDialog(widget.groupId, () {
                          Navigator.of(context).pop();
                          leadsCubit.getLeads(widget.groupId);
                        }),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0))),
                        insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
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
                    ));
              }),
        ],
      ),
      body: BlocBuilder<LeadsCubit, LeadsState>(
        bloc: leadsCubit,
        builder: (context, state) {
          if (state is LoadedLeadsState) {
            if (state.success) {
              leadsData = getDataOfResponse(state.leads ?? []);
              return BlocBuilder<LeadsUiCubit, LeadsState>(
                bloc: leadsUiCubit,
                builder: (context, state) {
                  if (state is InitialLeadsState) {
                    for (int i = 0; i < leadsData.length; i++) {
                      leadsData[i].isEditShown = false;
                    }
                  } else if (state is EditLeadsState) {
                    for (int i = 0; i < leadsData.length; i++) {
                      leadsData[i].isEditShown = true;
                    }
                  }
                  return ListView.builder(
                    itemCount: leadsData.length,
                    padding: const EdgeInsetsDirectional.only(bottom: 16),
                    itemBuilder: (context, index) {
                      return InkWell(
                          onTap: () async{
                            await Navigator.of(context).pushNamed(
                                AppRoutes.leaderDetails,
                                arguments: leadsData[index].id);
                            leadsCubit.getLeads(widget.groupId);
                          },
                          child: LeadsListItem(leadsData[index], () {
                            int selectedCount = 0;
                            for (int i = 0; i < leadsData.length; i++) {
                              if (leadsData[i].isSelected) {
                                selectedCount++;
                              }
                            }
                            leadsUiCubit.showEdit(selectedCount);
                          }));
                    },
                  );
                },
              );
            }
          } else if (state is LoadingGetLeadsState ||
              state is InitialLeadsState) {
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
          }

          return Container(
            alignment: Alignment.center,
            child: const Text("error"),
          );
        },
      ),
    );
  }

  List<LeadData> getDataOfResponse(List<ContactModel> list) {
    List<LeadData> leads = [];
    for (int i = 0; i < list.length; i++) {
      PhoneModel? phoneModel;
      if (list[i].phones?.isNotEmpty == true) {
        phoneModel = list[i].phones?.first;
      }
      LeadData data = LeadData(
          list[i].id,
          list[i].displayName,
          phoneModel?.value,
          list[i],
          "${list[i].givenName?.substring(0, 1).toUpperCase() ?? ""}${list[i].familyName?.substring(0, 1).toUpperCase() ?? ""}",
          false,
          false);
      leads.add(data);
    }
    return leads;
  }
}
