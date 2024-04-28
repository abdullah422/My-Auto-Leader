import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mal/model/task_model.dart';
import 'package:mal/modules/groups/leaddetails/tasks/create_task_dialog.dart';
import 'package:mal/modules/groups/leaddetails/tasks/task_item.dart';
import 'package:uuid/uuid.dart';

import '../../../../shared/styles/colors.dart';
import '../../../../shared/styles/text_styles.dart';
import '../../../../translations/locale_keys.g.dart';
import '../../confirm_delete_dialog.dart';
import '../add_item.dart';
import 'bloc/bloc.dart';
import 'confirm_task_status.dart';

class TasksTab extends StatefulWidget {
  const TasksTab(this.leaderId, {Key? key}) : super(key: key);
  final int leaderId;

  @override
  State<TasksTab> createState() => _TasksTabState();
}

class _TasksTabState extends State<TasksTab>
    with AutomaticKeepAliveClientMixin<TasksTab> {
  late TasksCubit tasksCubit;
  late TasksCrudCubit tasksCrudCubit;
  late TextEditingController titleController;

  @override
  void initState() {
    super.initState();
    var uuid = const Uuid();
    tasksCubit = TasksCubit(uuid);
    tasksCrudCubit = TasksCrudCubit(uuid);
    tasksCubit.getTasks(widget.leaderId);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: BlocBuilder<TasksCubit, TasksState>(
        bloc: tasksCubit,
        builder: (context, state) {
          if (state is LoadedTasksState) {
            if (state.success) {
              return ListView.builder(
                itemCount: (state.tasks?.length??0) + 1,
                padding: const EdgeInsets.only(bottom: 24),
                itemBuilder: (context, i) {
                  if(i == 0){
                    return AddItem(LocaleKeys.add_task.tr(), (){
                      titleController = TextEditingController();
                      AlertDialog alert = AlertDialog(
                        content: CreateTaskDialog(false, titleController,),
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
                          BlocListener<TasksCrudCubit, TasksState>(
                            listener: (context, state) {
                              if (state is LoadedCrudTasksState) {
                                Navigator.of(context).pop();
                                tasksCubit.getTasks(widget.leaderId);
                              }
                            },
                            bloc: tasksCrudCubit,
                            child: BlocBuilder<TasksCrudCubit, TasksState>(
                                bloc: tasksCrudCubit,
                                builder: (context, state) {
                                  if (state is LoadingCrudTasksState) {
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
                                      if(titleController.text.isNotEmpty){
                                        TaskModel model = TaskModel();
                                        model.title = titleController.text;
                                        model.userId = widget.leaderId;
                                        tasksCrudCubit.add(model);
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
                  return TaskItem(state.tasks![index], (action) {
                    if(action == 0){
                      int id = state.tasks![index].id??0;
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
                          BlocListener<TasksCrudCubit, TasksState>(
                            listener: (context, state) {
                              if (state is LoadedCrudTasksState) {
                                Navigator.of(context).pop();
                                tasksCubit.getTasks(widget.leaderId);
                              }
                            },
                            bloc: tasksCrudCubit,
                            child: BlocBuilder<TasksCrudCubit, TasksState>(
                                bloc: tasksCrudCubit,
                                builder: (context, state) {
                                  if (state is LoadingCrudTasksState) {
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
                                      tasksCrudCubit.delete(id);
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
                      titleController = TextEditingController(text: state.tasks![index].title??"");
                      int id = state.tasks![index].id??0;
                      AlertDialog alert = AlertDialog(
                        content: CreateTaskDialog(true, titleController, ),
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
                          BlocListener<TasksCrudCubit, TasksState>(
                            listener: (context, state) {
                              if (state is LoadedCrudTasksState) {
                                Navigator.of(context).pop();
                                tasksCubit.getTasks(widget.leaderId);
                              }
                            },
                            bloc: tasksCrudCubit,
                            child: BlocBuilder<TasksCrudCubit, TasksState>(
                                bloc: tasksCrudCubit,
                                builder: (context, state) {
                                  if (state is LoadingCrudTasksState) {
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
                                      if(titleController.text.isNotEmpty){
                                        TaskModel model = TaskModel();
                                        model.title = titleController.text;
                                        model.id = id;
                                        tasksCrudCubit.edit(model, id);
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
                    } else if(action == 2){
                      int id = state.tasks![index].id??0;
                      TaskModel task = state.tasks![index];
                      AlertDialog alert = AlertDialog(
                        content: ConfirmTaskStatus(
                          task.status == "complete"? LocaleKeys.confirm_incomplete.tr():
                          LocaleKeys.confirm_complete.tr()
                        ),
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
                          BlocListener<TasksCrudCubit, TasksState>(
                            listener: (context, state) {
                              if (state is LoadedCrudTasksState) {
                                Navigator.of(context).pop();
                                tasksCubit.getTasks(widget.leaderId);
                              }
                            },
                            bloc: tasksCrudCubit,
                            child: BlocBuilder<TasksCrudCubit, TasksState>(
                                bloc: tasksCrudCubit,
                                builder: (context, state) {
                                  if (state is LoadingCrudTasksState) {
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
                                      tasksCrudCubit.mark(task.status=="complete"?
                                          "incomplete": "complete",
                                          id);
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
