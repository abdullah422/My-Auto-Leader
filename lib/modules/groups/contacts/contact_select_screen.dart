import 'package:contacts_service/contacts_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mal/modules/groups/contacts/bloc/contact_cubit.dart';
import 'package:mal/modules/groups/contacts/bloc/contact_state.dart';
import 'package:mal/modules/groups/contacts/bloc/upload_contacts_cubit.dart';
import 'package:mal/modules/groups/contacts/select_all_item.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:uuid/uuid.dart';

import '../../../shared/styles/colors.dart';
import '../../../shared/styles/text_styles.dart';
import '../../../translations/locale_keys.g.dart';
import 'bloc/search_visibility_cubit.dart';
import 'contact_data.dart';
import 'item_contact.dart';

class ContactSelectScreen extends StatefulWidget {
  const ContactSelectScreen(this.groupId, {Key? key}) : super(key: key);
  final int groupId;

  @override
  State<ContactSelectScreen> createState() => _ContactSelectScreenState();
}

class _ContactSelectScreenState extends State<ContactSelectScreen> {
  late UploadContactsCubit uploadContactsCubit;
  List<ContactData>? data;
  late List<ContactData> filter;
  late ContactCubit contactCubit;
  late SearchVisibilityCubit searchVisibilityCubit;
  late String searchKeyword;
  ProgressDialog? pr;

  @override
  void initState() {
    super.initState();
    Uuid uuid = const Uuid();
    contactCubit = ContactCubit(uuid);
    searchVisibilityCubit = SearchVisibilityCubit(uuid);
    uploadContactsCubit = UploadContactsCubit();
    filter = [];
    searchKeyword = "";
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UploadContactsCubit, ContactState>(
      bloc: uploadContactsCubit,
      listener: (context, state) async {
        if (state is UploadingContactsState) {
          pr = ProgressDialog(context,
              type: ProgressDialogType.normal,
              isDismissible: false,
              showLogs: false);
          pr?.style(
              message: LocaleKeys.loading,
              borderRadius: 10.0,
              backgroundColor: Colors.white,
              // progressWidget: const CircularProgressIndicator(),
              elevation: 10.0,
              insetAnimCurve: Curves.easeInOut,
              textAlign: TextAlign.start,
              messageTextStyle: headingStyle);
          await pr?.show();
        } else {
          await pr?.hide();
        }
        if (state is UploadedContactsState) {
          if (state.success) {
            Navigator.of(context).pop();
          }
        }
      },
      child: Scaffold(
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
            InkWell(
              onTap: () {
                List<ContactData> selectedContacts = [];
                for (int i = 0; i < (data?.length ?? 0); i++) {
                  if (data![i].isSelected) {
                    selectedContacts.add(data![i]);
                  }
                }
                if (selectedContacts.isNotEmpty) {
                  uploadContactsCubit.addContactToGroup(
                      widget.groupId, selectedContacts);
                }
              },
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  LocaleKeys.done.tr(),
                  style: titleBlackStyle,
                ),
              ),
            ),
            BlocBuilder<SearchVisibilityCubit, ContactState>(
              bloc: searchVisibilityCubit,
              builder: (context, state) {
                if (state is SearchVisibilityState) {
                  if (state.visibility == true) {
                    return IconButton(
                        onPressed: () async {
                          searchVisibilityCubit.hide();
                        },
                        icon: const Icon(
                          Icons.close,
                          color: Colors.black,
                        ));
                  }
                }
                return IconButton(
                    onPressed: () async {
                      searchVisibilityCubit.show();
                    },
                    icon: const Icon(
                      Icons.search,
                      color: Colors.black,
                    ));
              },
            ),
          ],
        ),
        body: Column(
          children: [
            BlocBuilder<SearchVisibilityCubit, ContactState>(
              bloc: searchVisibilityCubit,
              builder: (context, state) {
                if (state is SearchVisibilityState) {
                  if (state.visibility == true) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      padding:
                          EdgeInsetsDirectional.only(start: 16.w, end: 16.w),
                      margin:
                          EdgeInsetsDirectional.only(top: 12.h, bottom: 12.h),
                      child: TextFormField(
                        autocorrect: false,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          suffixIcon: Icon(
                            Icons.search,
                            color: kIconGray,
                          ),
                          hintText: LocaleKeys.name.tr(),
                          hintStyle: hintForTextFieldStyle,
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.sp)),
                            borderSide: BorderSide(color: kGray, width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.sp)),
                            borderSide: BorderSide(color: kGray, width: 2),
                          ),
                          border: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15)),
                            borderSide: BorderSide(color: kBorder, width: 2),
                          ),
                          filled: true,
                          fillColor: kWhiteForTextField,
                          isDense: true,
                          contentPadding: EdgeInsetsDirectional.only(
                              top: 5.h, bottom: 5.h, start: 12.w),
                        ),
                        cursorColor: Colors.black,
                        maxLines: 1,
                        onChanged: (value) {
                          searchKeyword = value;
                          filterData(value);
                        },
                        style: TextStyle(fontSize: 18.sp),
                      ),
                    );
                  }
                }
                return Container();
              },
            ),
            Expanded(
              child: FutureBuilder<List<Contact>>(
                future: getContacts(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      break;
                    case ConnectionState.waiting:
                      break;
                    case ConnectionState.active:
                      break;
                    case ConnectionState.done:
                      data = snapshot.data
                          ?.map((e) => ContactData(false, e))
                          .toList();
                      data?.insert(0, ContactData(false, null));
                      return BlocBuilder<ContactCubit, ContactState>(
                        bloc: contactCubit,
                        builder: (context, state) {
                          List<ContactData> generalData = [];
                          if (filter.isNotEmpty == true) {
                            generalData = filter;
                          } else if (searchKeyword.isNotEmpty) {
                            generalData = [];
                          } else {
                            generalData = data ?? [];
                          }
                          return ListView.builder(
                            itemCount: generalData.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              if (index == 0 && searchKeyword.isEmpty == true) {
                                return SelectAllItem(
                                  generalData[0],
                                  (selected) {
                                    for (int i = 0;
                                        i < (data?.length ?? 0);
                                        i++) {
                                      data![i].isSelected = selected;
                                    }
                                    contactCubit.refresh();
                                  },
                                  key: UniqueKey(),
                                );
                              }
                              return ItemContact(
                                generalData[index],
                                key: UniqueKey(),
                              );
                            },
                          );
                        },
                      );
                  }
                  return Container(
                    alignment: AlignmentDirectional.center,
                    child: Text(LocaleKeys.loading_contacts.tr()),
                  );
                },
              ),
            ),
          ],
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: setResult,
        //   tooltip: 'Select',
        //   child: const Icon(Icons.mark_chat_read),
        // ),
      ),
    );
  }

  Future<List<Contact>> getContacts() async {
    return await ContactsService.getContacts();
  }

  void setResult() {
    Navigator.pop(
        context, data?.where((element) => element.isSelected).toList());
  }

  void filterData(String name) {
    filter.clear();
    for (int i = 0; i < (data?.length ?? 0); i++) {
      if (((data![i]
                      .contact
                      ?.displayName
                      ?.toLowerCase()
                      .contains(name.toLowerCase()) ==
                  true) ||
              (data![i]
                      .contact
                      ?.givenName
                      ?.toLowerCase()
                      .contains(name.toLowerCase()) ==
                  true)) &&
          (name.isNotEmpty)) {
        filter.add(data![i]);
      }
    }
    contactCubit.refresh();
  }
}
