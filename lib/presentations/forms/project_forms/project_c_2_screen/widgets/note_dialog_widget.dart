import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/task_info_response.dart';
import 'package:pran_rfl_erp/app_dependency/di_container.dart';
import 'package:pran_rfl_erp/common_widgets/common_dialog_header.dart';
import 'package:pran_rfl_erp/common_widgets/common_text_field_widget.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/presentations/forms/project_forms/project_c_2_screen/bloc/add_task_note_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/project_forms/project_c_2_screen/bloc/task_note_list_bloc.dart';

class NoteDialogWidget extends StatelessWidget {
  const NoteDialogWidget({
    super.key,
    required this.taskInfo,
    required this.userId,
  });
  final TaskInfo taskInfo;
  final String userId;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AddTaskNoteBloc(getService()),
        ),
        BlocProvider(
          create: (context) => TaskNoteListBloc(getService())
            ..add(
                TaskNoteListGet(userId: userId, taskId: taskInfo.tasksid ?? 0)),
        ),
      ],
      child: NoteDialogContent(taskInfo: taskInfo, userId: userId),
    );
  }
}

class NoteDialogContent extends StatefulWidget {
  const NoteDialogContent({
    super.key,
    required this.taskInfo,
    required this.userId,
  });
  final TaskInfo taskInfo;
  final String userId;
  @override
  State<NoteDialogContent> createState() => _NoteDialogContentState();
}

class _NoteDialogContentState extends State<NoteDialogContent> {
  final GlobalKey<FormState> _fromKey = GlobalKey<FormState>();
  late TextEditingController _noteController;
  late FocusNode _noteFocusNode;
  @override
  void initState() {
    _noteController = TextEditingController();
    _noteFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _noteController.dispose();
    _noteFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddTaskNoteBloc, AddTaskNoteState>(
      listener: (context, state) {
        if (state is AddTaskNoteSuccess) {
          _noteController.clear();
          context.read<TaskNoteListBloc>().add(
                TaskNoteListGet(
                  userId: widget.userId,
                  taskId: widget.taskInfo.tasksid ?? 0,
                ),
              );
        }
      },
      child: Container(
        constraints: const BoxConstraints(
          maxHeight: 400,
        ),
        padding: const EdgeInsets.all(5),
        child: Form(
          key: _fromKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              CommonDialogHeader(
                title: widget.taskInfo.taskName ?? "",
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 65,
                child: CommonTextFieldWidget(
                  focusNode: _noteFocusNode,
                  controller: _noteController,
                  labelText: "New Note",
                  expands: true,
                  maxLines: null,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Note can't be empty";
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              BlocBuilder<AddTaskNoteBloc, AddTaskNoteState>(
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: () {
                      if (_fromKey.currentState!.validate()) {
                        context.read<AddTaskNoteBloc>().add(
                              AddTaskNote(
                                userId: widget.userId,
                                taskNote: _noteController.text,
                                taskId: widget.taskInfo.tasksid ?? 0,
                              ),
                            );
                      }
                    },
                    child: Text(
                      state is AddTaskNoteLoading ? "Adding..." : "Add Note",
                      style: textTheme.bodyMedium!.copyWith(
                        color: appTheme.white,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 5,
              ),
              Divider(
                color: appTheme.dividerColor,
                height: 2,
                indent: 5,
                endIndent: 5,
              ),
              const SizedBox(
                height: 5,
              ),
              Expanded(
                child: BlocBuilder<TaskNoteListBloc, TaskNoteListState>(
                  builder: (context, state) {
                    if (state is TaskNoteListLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (state is TaskNoteListSuccess) {
                      return Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: appTheme.primary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: ListView.separated(
                          itemBuilder: (context, index) {
                            var data = state.taskNoteList[index];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${index + 1}. ${data.noteContent}",
                                  style: textTheme.bodyMedium!.copyWith(
                                    color: appTheme.primary,
                                  ),
                                ),
                              ],
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox(
                              height: 5,
                            );
                          },
                          itemCount: state.taskNoteList.length,
                        ),
                      );
                    }
                    return Container();
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
