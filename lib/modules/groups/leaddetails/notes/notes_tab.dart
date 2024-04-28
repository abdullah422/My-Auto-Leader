

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mal/model/note_model.dart';
import 'package:mal/modules/groups/leaddetails/add_item.dart';
import 'package:mal/modules/groups/leaddetails/notes/bloc/bloc.dart';
import 'package:mal/modules/groups/leaddetails/notes/create_note_dialog.dart';
import 'package:uuid/uuid.dart';

import '../../../../shared/styles/colors.dart';
import '../../../../shared/styles/text_styles.dart';
import '../../../../translations/locale_keys.g.dart';
import '../../confirm_delete_dialog.dart';
import 'note_item.dart';

class NotesTab extends StatefulWidget {
  const NotesTab(this.leaderId, {Key? key}) : super(key: key);
  final int leaderId;
  @override
  State<NotesTab> createState() => _NotesTabState();
}

class _NotesTabState extends State<NotesTab> with  AutomaticKeepAliveClientMixin<NotesTab> {

  late NotesCubit notesCubit;
  late NotesCrudCubit notesCrudCubit;
  late TextEditingController titleController;
  late TextEditingController contentController;

  @override
  void initState() {
    super.initState();
    var uuid = const Uuid();
    notesCubit = NotesCubit(uuid);
    notesCrudCubit = NotesCrudCubit(uuid);
    notesCubit.getNotes(widget.leaderId);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: BlocBuilder<NotesCubit, NotesState>(
        bloc: notesCubit,
        builder:(context, state) {
          if(state is LoadedNotesState){
            if(state.success){
              return ListView.builder(
                itemCount: (state.notes?.length??0) + 1,
                padding: const EdgeInsets.only(bottom: 24),
                itemBuilder: (context, i) {
                  if(i == 0){
                    return AddItem(LocaleKeys.add_note.tr(), (){
                      titleController = TextEditingController();
                      contentController = TextEditingController();
                      AlertDialog alert = AlertDialog(
                        content: CreateNoteDialog(false, titleController, contentController),
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
                              LocaleKeys.cancel.tr(),
                              style: cancelStyle,
                            ),
                          ),
                          BlocListener<NotesCrudCubit, NotesState>(
                            listener: (context, state) {
                              if (state is LoadedCrudNotesState) {
                                Navigator.of(context).pop();
                                notesCubit.getNotes(widget.leaderId);
                              }
                            },
                            bloc: notesCrudCubit,
                            child: BlocBuilder<NotesCrudCubit, NotesState>(
                                bloc: notesCrudCubit,
                                builder: (context, state) {
                                  if (state is LoadingCrudNotesState) {
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
                                      if(titleController.text.isNotEmpty &&
                                      contentController.text.isNotEmpty){
                                        NoteModel model = NoteModel();
                                        model.title = titleController.text;
                                        model.content = contentController.text;
                                        model.userId = widget.leaderId;
                                        notesCrudCubit.add(model);
                                      }

                                    },
                                    child: Text(
                                      LocaleKeys.save.tr(),
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
                    });
                  }
                  int index = i -1;
                  return NoteItem(state.notes![index], (action) {
                    if(action == 0){
                      int id = state.notes![index].id??0;
                      AlertDialog alert = AlertDialog(
                        content: const ConfirmDeleteDialog(1),
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
                          BlocListener<NotesCrudCubit, NotesState>(
                            listener: (context, state) {
                              if (state is LoadedCrudNotesState) {
                                Navigator.of(context).pop();
                                notesCubit.getNotes(widget.leaderId);
                              }
                            },
                            bloc: notesCrudCubit,
                            child: BlocBuilder<NotesCrudCubit, NotesState>(
                                bloc: notesCrudCubit,
                                builder: (context, state) {
                                  if (state is LoadingCrudNotesState) {
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
                                      notesCrudCubit.delete(id);
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

                    } else if(action == 1) {
                      titleController = TextEditingController(text: state.notes![index].title??"");
                      contentController = TextEditingController(text: state.notes![index].content??"");
                      int id = state.notes![index].id??0;
                      AlertDialog alert = AlertDialog(
                        content: CreateNoteDialog(true, titleController, contentController),
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
                              LocaleKeys.cancel.tr(),
                              style: cancelStyle,
                            ),
                          ),
                          BlocListener<NotesCrudCubit, NotesState>(
                            listener: (context, state) {
                              if (state is LoadedCrudNotesState) {
                                Navigator.of(context).pop();
                                notesCubit.getNotes(widget.leaderId);
                              }
                            },
                            bloc: notesCrudCubit,
                            child: BlocBuilder<NotesCrudCubit, NotesState>(
                                bloc: notesCrudCubit,
                                builder: (context, state) {
                                  if (state is LoadingCrudNotesState) {
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
                                      if(titleController.text.isNotEmpty &&
                                          contentController.text.isNotEmpty){
                                        NoteModel model = NoteModel();
                                        model.title = titleController.text;
                                        model.content = contentController.text;
                                        model.id = id;
                                        notesCrudCubit.edit(model, id);
                                      }

                                    },
                                    child: Text(
                                      LocaleKeys.save.tr(),
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
                  },);
                },
              );
            }
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
}
