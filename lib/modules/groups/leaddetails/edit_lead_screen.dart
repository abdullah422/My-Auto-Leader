import 'package:easy_localization/easy_localization.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mal/model/address_model.dart';
import 'package:mal/model/contact_model.dart';
import 'package:mal/model/email_model.dart';
import 'package:mal/model/phone_model.dart';
import 'package:mal/modules/groups/leaddetails/bloc/birthday_cubit.dart';
import 'package:mal/modules/groups/leaddetails/bloc/bloc.dart';
import 'package:mal/translations/locale_keys.g.dart';
import 'package:uuid/uuid.dart';

import '../../../shared/styles/colors.dart';
import '../../../shared/styles/text_styles.dart';
import '../contacts/bloc/contact_state.dart';
import '../contacts/bloc/upload_contacts_cubit.dart';
import '../leads/bloc/leads_state.dart';
import 'bloc/image_cubit.dart';
import 'create_address_dialog.dart';
import 'create_email_dialog.dart';
import 'create_phone_dialog.dart';
import 'date_picker.dart';
import 'models/status_item_model.dart';

class EditLeadScreen extends StatefulWidget {
  const EditLeadScreen(this.leadId, this.groupId, {Key? key}) : super(key: key);
  final int? leadId;
  final int groupId;

  @override
  State<EditLeadScreen> createState() => _EditLeadScreenState();
}

class _EditLeadScreenState extends State<EditLeadScreen> {
  late LeadDetailsCubit leadDetailsCubit;
  late ImageCubit imageCubit;
  late BirthdayCubit birthdayCubit;
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController companyController;
  late TextEditingController jobTitleController;
  late UploadContactsCubit uploadContactsCubit;
  late List<StatusItemModel> statuses;
  late List<PhoneModel> phones;
  late List<EmailModel> emails;
  late List<AddressModel> addresses;
  late RefreshCubit refreshCubit;

  @override
  void initState() {
    super.initState();
    statuses = <StatusItemModel>[];
    statuses.add(StatusItemModel(false, LocaleKeys.cold.tr(), "cold"));
    statuses.add(StatusItemModel(false, LocaleKeys.warm.tr(), "warm"));
    statuses.add(StatusItemModel(false, LocaleKeys.hot.tr(), "hot"));
    statuses
        .add(StatusItemModel(false, LocaleKeys.no_status.tr(), "no status"));
    phones = <PhoneModel>[];
    emails = <EmailModel>[];
    addresses = <AddressModel>[];

    leadDetailsCubit = LeadDetailsCubit();
    imageCubit = ImageCubit();
    birthdayCubit = BirthdayCubit();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    companyController = TextEditingController();
    jobTitleController = TextEditingController();
    refreshCubit = RefreshCubit(const Uuid());

    uploadContactsCubit = UploadContactsCubit();
    leadDetailsCubit.getContactDetails(widget.leadId);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.leadId == null
              ? LocaleKeys.add_contact.tr()
              : LocaleKeys.edit_information.tr(),
          style: titleBlackStyle,
        ),
        titleTextStyle: titleBlackStyle,
        centerTitle: true,
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
          BlocListener<UploadContactsCubit, ContactState>(
            bloc: uploadContactsCubit,
            listener: (context, state) {
              if (state is UploadedContactsState) {
                if (state.success) {
                  Navigator.of(context).pop();
                }
              }
            },
            child: BlocBuilder<UploadContactsCubit, ContactState>(
              bloc: uploadContactsCubit,
              builder: (context, state) {
                if (state is UploadingContactsState) {
                  return Container(
                    margin: const EdgeInsetsDirectional.only(top: 8, end: 8),
                    alignment: Alignment.center,
                    child: const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                  );
                }
                return InkWell(
                  onTap: () {
                    ContactModel model = ContactModel();
                    model.addresses = addresses;
                    model.emails = emails;
                    model.phones = phones;
                    model.groupId = widget.groupId;
                    model.birthday = birthdayCubit.state.birthday;
                    model.givenName = firstNameController.text;
                    model.familyName = lastNameController.text;
                    model.company = companyController.text;
                    model.jobTitle = jobTitleController.text;
                    model.id = widget.leadId;
                    model.userId = widget.leadId;
                    model.displayName = firstNameController.text +
                        " " +
                        lastNameController.text;
                    String s = "";
                    for (int i = 0; i < 4; i++) {
                      if (statuses[i].isSelected) {
                        s = statuses[i].slug;
                      }
                    }
                    model.status = s;
                    if (widget.leadId == null) {
                      uploadContactsCubit.addContactModelToGroup(
                          widget.groupId, model);
                    } else {
                      uploadContactsCubit.editContactModelToGroup(
                          widget.groupId, model);
                    }
                  },
                  child: Container(
                    alignment: AlignmentDirectional.center,
                    margin: const EdgeInsetsDirectional.only(end: 16),
                    child: Text(
                      LocaleKeys.done.tr(),
                      style: doneBlackStyle,
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
      body: BlocBuilder<LeadDetailsCubit, LeadDetailsState>(
        bloc: leadDetailsCubit,
        builder: (context, state) {
          if (state is LoadedLeadDetailsState) {
            if (state.data != null) {
              String firstName =
                  state.data?.givenName?.substring(0, 1).toUpperCase() ?? "";
              String lastName =
                  state.data?.familyName?.substring(0, 1).toUpperCase() ?? "";
              imageCubit.changeImage(firstName, lastName);
              birthdayCubit.changeBirthday(state.data?.birthday);
              firstNameController.text = state.data?.givenName ??"";
              lastNameController.text = state.data?.familyName ??"";
              jobTitleController.text = state.data?.jobTitle ??"";
              companyController.text = state.data?.company ??"";
              emails = state.data?.emails??<EmailModel>[];
              phones = state.data?.phones??<PhoneModel>[];
              addresses = state.data?.addresses??<AddressModel>[];
              for (int i = 0; i < 4; i++) {
                if (state.data?.status == statuses[i].slug) {
                  statuses[i].isSelected = true;
                }
              }
            }
            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin:
                        const EdgeInsetsDirectional.only(start: 18, top: 16),
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      LocaleKeys.basic_information.tr(),
                      style: headingStyle,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsetsDirectional.only(
                        top: 12, start: 16, end: 16),
                    height: 150,
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: kGray,
                        borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          margin: const EdgeInsetsDirectional.only(
                              top: 16, start: 24),
                          alignment: AlignmentDirectional.center,
                          decoration: BoxDecoration(
                              color: Colors.grey[300], shape: BoxShape.circle),
                          child: BlocBuilder<ImageCubit, ChangedImageState>(
                            bloc: imageCubit,
                            builder: (context, state) {
                              return Text(
                                "${state.firstName ?? ""}${state.lastName ?? ""}",
                                style: GoogleFonts.almarai(
                                    fontSize: 21,
                                    color: kBlack,
                                    fontWeight: FontWeight.bold),
                              );
                            },
                          ),
                        ),
                        Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                              ),
                              margin: const EdgeInsetsDirectional.only(
                                  top: 16, start: 24, end: 16),
                              width: MediaQuery.of(context).size.width - 160,
                              height: 32,
                              child: TextFormField(
                                keyboardType: TextInputType.name,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.person,
                                    size: 16,
                                  ),
                                  prefixIconConstraints: const BoxConstraints(
                                    maxHeight: 30,
                                    minHeight: 30,
                                    maxWidth: 28,
                                    minWidth: 28,
                                  ),
                                  hintText: LocaleKeys.first_name.tr(),
                                  hintStyle: hintForTextFieldStyle,
                                  isDense: true,
                                  contentPadding:
                                      const EdgeInsetsDirectional.only(
                                    top: 8,
                                  ),
                                  border: InputBorder.none,
                                ),
                                controller: firstNameController,
                                onChanged: (value) {
                                  if (value.isNotEmpty) {
                                    String firstName =
                                        value.substring(0, 1).toUpperCase();
                                    imageCubit.changeImage(firstName, null);
                                  }
                                },
                                style: inputDataForTextFieldStyle,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                              ),
                              margin: const EdgeInsetsDirectional.only(
                                  top: 8, start: 24, end: 16),
                              width: MediaQuery.of(context).size.width - 160,
                              height: 32,
                              alignment: AlignmentDirectional.topStart,
                              child: TextFormField(
                                keyboardType: TextInputType.name,
                                controller: lastNameController,
                                onChanged: (value) {
                                  if (value.isNotEmpty) {
                                    String lastName =
                                        value.substring(0, 1).toUpperCase();
                                    imageCubit.changeImage(null, lastName);
                                  }
                                },
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.person,
                                    size: 16,
                                  ),
                                  prefixIconConstraints: const BoxConstraints(
                                    maxHeight: 30,
                                    minHeight: 30,
                                    maxWidth: 28,
                                    minWidth: 28,
                                  ),
                                  hintText: LocaleKeys.last_name.tr(),
                                  hintStyle: hintForTextFieldStyle,
                                  isDense: true,
                                  contentPadding:
                                      const EdgeInsetsDirectional.only(
                                    top: 8,
                                  ),
                                  border: InputBorder.none,
                                ),
                                style: inputDataForTextFieldStyle,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                AlertDialog dialog = AlertDialog(
                                  shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                  ),
                                  insetPadding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  contentPadding: EdgeInsets.zero,
                                  content: DatePicker(
                                    (
                                      dateStr,
                                    ) {
                                      Navigator.of(context).pop();
                                      birthdayCubit.changeBirthday(dateStr);
                                    },
                                  ),
                                );
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) => dialog);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                ),
                                margin: const EdgeInsetsDirectional.only(
                                    top: 8, start: 24, end: 16),
                                width: MediaQuery.of(context).size.width - 160,
                                height: 32,
                                child: Row(
                                  children: [
                                    const SizedBox(
                                      width: 7,
                                    ),
                                    const Icon(
                                      Icons.calendar_month,
                                      size: 16,
                                    ),
                                    const SizedBox(
                                      width: 6,
                                    ),
                                    BlocBuilder<BirthdayCubit,
                                        ChangedBirthdayState>(
                                      bloc: birthdayCubit,
                                      builder: (context, state) {
                                        return Text(
                                          state.birthday ??
                                              LocaleKeys.birthday.tr(),
                                          style: state.birthday == null
                                              ? hintForTextFieldStyle
                                              : inputDataForTextFieldStyle,
                                        );
                                      },
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin:
                        const EdgeInsetsDirectional.only(start: 18, top: 16),
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      LocaleKeys.work_information.tr(),
                      style: headingStyle,
                    ),
                  ),
                  Container(
                    height: 58.h,
                    margin: const EdgeInsetsDirectional.only(
                        top: 16, start: 16, end: 16),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: kGray, borderRadius: BorderRadius.circular(8)),
                    alignment: AlignmentDirectional.centerStart,
                    child: TextFormField(
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        hintText: LocaleKeys.job_title.tr(),
                        hintStyle: bigHintForTextFieldStyle,
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4.sp)),
                          borderSide:
                              const BorderSide(color: Colors.red, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4.sp)),
                          borderSide: BorderSide(color: kGray, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4.sp)),
                          borderSide: BorderSide(color: kGray, width: 2),
                        ),
                        errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 2),
                        ),
                        errorStyle: errorValidationStyle,
                        filled: true,
                        fillColor: kGray,
                        isDense: true,
                        contentPadding: EdgeInsetsDirectional.only(
                            start: 8.w, top: 8.h, bottom: 8.h, end: 8.w),
                      ),
                      cursorColor: Colors.black,
                      maxLines: 1,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return LocaleKeys.required_field.tr();
                        }
                        return null;
                      },
                      controller: jobTitleController,
                      style: TextStyle(fontSize: 20.sp),
                    ),
                  ),
                  Container(
                    height: 58.h,
                    margin: const EdgeInsetsDirectional.only(
                        top: 16, start: 16, end: 16),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: kGray, borderRadius: BorderRadius.circular(8)),
                    alignment: AlignmentDirectional.centerStart,
                    child: TextFormField(
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        hintText: LocaleKeys.company.tr(),
                        hintStyle: bigHintForTextFieldStyle,
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4.sp)),
                          borderSide:
                              const BorderSide(color: Colors.red, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4.sp)),
                          borderSide: BorderSide(color: kGray, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4.sp)),
                          borderSide: BorderSide(color: kGray, width: 2),
                        ),
                        errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 2),
                        ),
                        errorStyle: errorValidationStyle,
                        filled: true,
                        fillColor: kGray,
                        isDense: true,
                        contentPadding: EdgeInsetsDirectional.only(
                            start: 8.w, top: 8.h, bottom: 8.h, end: 8.w),
                      ),
                      cursorColor: Colors.black,
                      maxLines: 1,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return LocaleKeys.required_field.tr();
                        }
                        return null;
                      },
                      controller: companyController,
                      style: TextStyle(fontSize: 20.sp),
                    ),
                  ),
                  Container(
                    margin:
                        const EdgeInsetsDirectional.only(start: 18, top: 16),
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      LocaleKeys.contact_information.tr(),
                      style: headingStyle,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsetsDirectional.only(
                        start: 24, top: 16, end: 16),
                    child: ExpandableNotifier(
                      child: ScrollOnExpand(
                        child: ExpandablePanel(
                          header: Row(
                            children: [
                              Container(
                                child: const Icon(Icons.phone),
                                margin:
                                    const EdgeInsetsDirectional.only(top: 8),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Container(
                                margin:
                                    const EdgeInsetsDirectional.only(top: 4),
                                child: Text(
                                  LocaleKeys.phones.tr(),
                                  style: doneBlackStyle,
                                ),
                              ),
                              Expanded(child: Container()),
                              InkWell(
                                onTap: () {
                                  TextEditingController labelController =
                                      TextEditingController();
                                  TextEditingController valueController =
                                      TextEditingController();
                                  AlertDialog alert = AlertDialog(
                                    content: CreatePhoneDialog(
                                        LocaleKeys.phone.tr(),
                                        labelController,
                                        valueController),
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0))),
                                    insetPadding:
                                        EdgeInsets.symmetric(horizontal: 16.w),
                                    actionsPadding:
                                        const EdgeInsetsDirectional.only(
                                            end: 4, bottom: 8),
                                    contentPadding:
                                        const EdgeInsetsDirectional.only(
                                            start: 12,
                                            end: 12,
                                            top: 16,
                                            bottom: 16),
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
                                      InkWell(
                                        onTap: () {
                                          phones.add(PhoneModel(
                                              value: valueController.text,
                                              label: labelController.text));
                                          refreshCubit.refresh();
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          LocaleKeys.create.tr(),
                                          style: titleForActionFieldStyle,
                                        ),
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
                                child: Container(
                                  margin:
                                      const EdgeInsetsDirectional.only(top: 8),
                                  child: const Icon(Icons.add),
                                ),
                              ),
                            ],
                          ),
                          collapsed: Container(),
                          expanded: BlocBuilder<RefreshCubit, RefreshState>(
                            bloc: refreshCubit,
                            builder: (context, state) {
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: phones.length,
                                itemBuilder: (context, index) {
                                  return Row(
                                    children: [
                                      Text(
                                        phones[index].label ?? "",
                                        style: valueBlackStyle,
                                      ),
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      Expanded(
                                        child: Text(
                                          phones[index].value ?? "",
                                          style: valueBlackStyle,
                                        ),
                                      ),
                                      Expanded(child: Container()),
                                      InkWell(
                                        onTap: () {
                                          TextEditingController
                                              labelController =
                                              TextEditingController(
                                                  text: phones[index].label ??
                                                      "");
                                          TextEditingController
                                              valueController =
                                              TextEditingController(
                                                  text: phones[index].value ??
                                                      "");
                                          AlertDialog alert = AlertDialog(
                                            content: CreatePhoneDialog(
                                                LocaleKeys.edit.tr(),
                                                labelController,
                                                valueController),
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(8.0))),
                                            insetPadding: EdgeInsets.symmetric(
                                                horizontal: 16.w),
                                            actionsPadding:
                                                const EdgeInsetsDirectional
                                                    .only(end: 4, bottom: 8),
                                            contentPadding:
                                                const EdgeInsetsDirectional
                                                        .only(
                                                    start: 12,
                                                    end: 12,
                                                    top: 16,
                                                    bottom: 16),
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
                                              InkWell(
                                                onTap: () {
                                                  phones[index].value =
                                                      valueController.text;
                                                  phones[index].label =
                                                      labelController.text;
                                                  refreshCubit.refresh();
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text(
                                                  LocaleKeys.edit.tr(),
                                                  style:
                                                      titleForActionFieldStyle,
                                                ),
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
                                        child: const Icon(Icons.edit),
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      )
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsetsDirectional.only(
                        start: 24, top: 4, end: 16),
                    child: ExpandableNotifier(
                      child: ScrollOnExpand(
                        child: ExpandablePanel(
                          header: Row(
                            children: [
                              Container(
                                child: const Icon(Icons.mail),
                                margin:
                                    const EdgeInsetsDirectional.only(top: 8),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Container(
                                margin:
                                    const EdgeInsetsDirectional.only(top: 4),
                                child: Text(
                                  LocaleKeys.emails.tr(),
                                  style: doneBlackStyle,
                                ),
                              ),
                              Expanded(child: Container()),
                              InkWell(
                                onTap: () {
                                  TextEditingController labelController =
                                      TextEditingController();
                                  TextEditingController valueController =
                                      TextEditingController();
                                  AlertDialog alert = AlertDialog(
                                    content: CreateEmailDialog(
                                        LocaleKeys.email.tr(),
                                        labelController,
                                        valueController),
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0))),
                                    insetPadding:
                                        EdgeInsets.symmetric(horizontal: 16.w),
                                    actionsPadding:
                                        const EdgeInsetsDirectional.only(
                                            end: 4, bottom: 8),
                                    contentPadding:
                                        const EdgeInsetsDirectional.only(
                                            start: 12,
                                            end: 12,
                                            top: 16,
                                            bottom: 16),
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
                                      InkWell(
                                        onTap: () {
                                          emails.add(EmailModel(
                                              value: valueController.text,
                                              label: labelController.text));
                                          refreshCubit.refresh();
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          LocaleKeys.create.tr(),
                                          style: titleForActionFieldStyle,
                                        ),
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
                                child: Container(
                                  margin:
                                      const EdgeInsetsDirectional.only(top: 8),
                                  child: const Icon(Icons.add),
                                ),
                              ),
                            ],
                          ),
                          collapsed: Container(),
                          expanded: BlocBuilder<RefreshCubit, RefreshState>(
                            bloc: refreshCubit,
                            builder: (context, state) {
                              return ListView.builder(
                                shrinkWrap: true,
                                itemCount: emails.length,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Row(
                                    children: [
                                      Text(
                                        emails[index].label ?? "",
                                        style: valueBlackStyle,
                                      ),
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      Expanded(
                                        child: Text(
                                          emails[index].value ?? "",
                                          style: valueBlackStyle,
                                        ),
                                      ),
                                      Expanded(child: Container()),
                                      InkWell(
                                        onTap: () {
                                          TextEditingController
                                              labelController =
                                              TextEditingController(
                                                  text: emails[index].label ??
                                                      "");
                                          TextEditingController
                                              valueController =
                                              TextEditingController(
                                                  text: emails[index].value ??
                                                      "");
                                          AlertDialog alert = AlertDialog(
                                            content: CreateEmailDialog(
                                                LocaleKeys.edit.tr(),
                                                labelController,
                                                valueController),
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(8.0))),
                                            insetPadding: EdgeInsets.symmetric(
                                                horizontal: 16.w),
                                            actionsPadding:
                                                const EdgeInsetsDirectional
                                                    .only(end: 4, bottom: 8),
                                            contentPadding:
                                                const EdgeInsetsDirectional
                                                        .only(
                                                    start: 12,
                                                    end: 12,
                                                    top: 16,
                                                    bottom: 16),
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
                                              InkWell(
                                                onTap: () {
                                                  emails[index].value =
                                                      valueController.text;
                                                  emails[index].label =
                                                      labelController.text;
                                                  refreshCubit.refresh();
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text(
                                                  LocaleKeys.edit.tr(),
                                                  style:
                                                      titleForActionFieldStyle,
                                                ),
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
                                        child: const Icon(Icons.edit),
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      )
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsetsDirectional.only(
                        start: 24, top: 4, end: 16),
                    child: ExpandableNotifier(
                      child: ScrollOnExpand(
                        child: ExpandablePanel(
                          header: Row(
                            children: [
                              Container(
                                child: const Icon(Icons.location_on),
                                margin:
                                    const EdgeInsetsDirectional.only(top: 8),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Container(
                                margin:
                                    const EdgeInsetsDirectional.only(top: 4),
                                child: Text(
                                  LocaleKeys.addresses.tr(),
                                  style: doneBlackStyle,
                                ),
                              ),
                              Expanded(child: Container()),
                              Container(
                                margin:
                                    const EdgeInsetsDirectional.only(top: 8),
                                child: InkWell(
                                  onTap: () {
                                    TextEditingController labelController =
                                        TextEditingController();
                                    TextEditingController streetController =
                                        TextEditingController();
                                    TextEditingController regionController =
                                        TextEditingController();
                                    TextEditingController cityController =
                                        TextEditingController();
                                    TextEditingController countryController =
                                        TextEditingController();
                                    TextEditingController postCodeController =
                                        TextEditingController();
                                    AlertDialog alert = AlertDialog(
                                      content: CreateAddressDialog(
                                          LocaleKeys.address.tr(),
                                          labelController,
                                          streetController,
                                          cityController,
                                          countryController,
                                          regionController,
                                          postCodeController),
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8.0))),
                                      insetPadding: EdgeInsets.symmetric(
                                          horizontal: 16.w),
                                      actionsPadding:
                                          const EdgeInsetsDirectional.only(
                                              end: 4, bottom: 8),
                                      contentPadding:
                                          const EdgeInsetsDirectional.only(
                                              start: 12,
                                              end: 12,
                                              top: 16,
                                              bottom: 16),
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
                                        InkWell(
                                          onTap: () {
                                            addresses.add(AddressModel(
                                                label: labelController.text,
                                                street: streetController.text,
                                                region: regionController.text,
                                                city: cityController.text,
                                                country: countryController.text,
                                                postcode:
                                                    postCodeController.text));
                                            refreshCubit.refresh();
                                            Navigator.of(context).pop();
                                          },
                                          child: Text(
                                            LocaleKeys.create.tr(),
                                            style: titleForActionFieldStyle,
                                          ),
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
                                  child: const Icon(Icons.add),
                                ),
                              ),
                            ],
                          ),
                          collapsed: Container(),
                          expanded: BlocBuilder<RefreshCubit, RefreshState>(
                            bloc: refreshCubit,
                            builder: (context, state) {
                              return ListView.builder(
                                shrinkWrap: true,
                                itemCount: addresses.length,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: const EdgeInsetsDirectional.only(
                                        top: 8),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              LocaleKeys.label.tr(),
                                              style: valueBlackStyle,
                                            ),
                                            const SizedBox(
                                              width: 4,
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  116,
                                              child: Text(
                                                addresses[index].label ?? "",
                                                style: valueBlackStyle,
                                              ),
                                            ),
                                            Expanded(child: Container()),
                                            InkWell(
                                              onTap: () {
                                                TextEditingController
                                                    labelController =
                                                    TextEditingController(
                                                        text: addresses[index]
                                                            .label);
                                                TextEditingController
                                                    streetController =
                                                    TextEditingController(
                                                        text: addresses[index]
                                                            .street);
                                                TextEditingController
                                                    regionController =
                                                    TextEditingController(
                                                        text: addresses[index]
                                                            .region);
                                                TextEditingController
                                                    cityController =
                                                    TextEditingController(
                                                        text: addresses[index]
                                                            .city);
                                                TextEditingController
                                                    countryController =
                                                    TextEditingController(
                                                        text: addresses[index]
                                                            .country);
                                                TextEditingController
                                                    postCodeController =
                                                    TextEditingController(
                                                        text: addresses[index]
                                                            .postcode);
                                                AlertDialog alert = AlertDialog(
                                                  content: CreateAddressDialog(
                                                      LocaleKeys.edit.tr(),
                                                      labelController,
                                                      streetController,
                                                      cityController,
                                                      countryController,
                                                      regionController,
                                                      postCodeController),
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          8.0))),
                                                  insetPadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 16.w),
                                                  actionsPadding:
                                                      const EdgeInsetsDirectional
                                                              .only(
                                                          end: 4, bottom: 8),
                                                  contentPadding:
                                                      const EdgeInsetsDirectional
                                                              .only(
                                                          start: 12,
                                                          end: 12,
                                                          top: 16,
                                                          bottom: 16),
                                                  actions: [
                                                    InkWell(
                                                      onTap: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text(
                                                        LocaleKeys.cancel.tr(),
                                                        style: cancelStyle,
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        addresses[index].label =
                                                            labelController
                                                                .text;
                                                        addresses[index]
                                                                .street =
                                                            streetController
                                                                .text;
                                                        addresses[index]
                                                                .region =
                                                            regionController
                                                                .text;
                                                        addresses[index].city =
                                                            cityController.text;
                                                        addresses[index]
                                                                .country =
                                                            countryController
                                                                .text;
                                                        addresses[index]
                                                                .postcode =
                                                            postCodeController
                                                                .text;
                                                        refreshCubit.refresh();
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text(
                                                        LocaleKeys.edit.tr(),
                                                        style:
                                                            titleForActionFieldStyle,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 4,
                                                    ),
                                                  ],
                                                );
                                                showDialog(
                                                  context: context,
                                                  barrierDismissible: true,
                                                  builder:
                                                      (BuildContext context) {
                                                    return alert;
                                                  },
                                                );
                                              },
                                              child: const Icon(
                                                Icons.edit,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 8,
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              LocaleKeys.street.tr(),
                                              style: valueBlackStyle,
                                            ),
                                            const SizedBox(
                                              width: 4,
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  116,
                                              child: Text(
                                                addresses[index].street ?? "",
                                                style: valueBlackStyle,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 8,
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              LocaleKeys.city.tr(),
                                              style: valueBlackStyle,
                                            ),
                                            const SizedBox(
                                              width: 4,
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  116,
                                              child: Text(
                                                addresses[index].city ?? "",
                                                style: valueBlackStyle,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 8,
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              LocaleKeys.country.tr(),
                                              style: valueBlackStyle,
                                            ),
                                            const SizedBox(
                                              width: 4,
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  116,
                                              child: Text(
                                                addresses[index].country ?? "",
                                                style: valueBlackStyle,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 8,
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              LocaleKeys.region.tr(),
                                              style: valueBlackStyle,
                                            ),
                                            const SizedBox(
                                              width: 4,
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  116,
                                              child: Text(
                                                addresses[index].region ?? "",
                                                style: valueBlackStyle,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 8,
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              LocaleKeys.postcode.tr(),
                                              style: valueBlackStyle,
                                            ),
                                            const SizedBox(
                                              width: 4,
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  116,
                                              child: Text(
                                                addresses[index].postcode ?? "",
                                                style: valueBlackStyle,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 8,
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsetsDirectional.only(start: 18, top: 8),
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      LocaleKeys.status.tr(),
                      style: headingStyle,
                    ),
                  ),
                  Container(
                      margin: const EdgeInsetsDirectional.only(
                          start: 24, top: 4, end: 16),
                      child: BlocBuilder<RefreshCubit, RefreshState>(
                        bloc: refreshCubit,
                        builder: (context, state) {
                          return ListView.builder(
                            itemCount: 4,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  for (int i = 0; i < 4; i++) {
                                    statuses[i].isSelected = false;
                                  }
                                  statuses[index].isSelected = true;
                                  refreshCubit.refresh();
                                },
                                child: Container(
                                  margin:
                                      const EdgeInsetsDirectional.only(top: 8),
                                  child: Row(
                                    children: [
                                      Icon(
                                        statuses[index].isSelected
                                            ? Icons.radio_button_on
                                            : Icons.radio_button_off,
                                        size: 16,
                                      ),
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        statuses[index].name,
                                        style: valueBlackStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      )),
                  Container(
                    height: 32,
                  )
                ],
              ),
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
      backgroundColor: Colors.white,
    );
  }
}
