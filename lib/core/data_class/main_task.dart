import 'package:pran_rfl_erp/app_data/models/department_list_response.dart';
import 'package:pran_rfl_erp/app_data/models/parent_task_list.dart';
import 'package:pran_rfl_erp/app_data/models/po_job_list_response.dart';
import 'package:pran_rfl_erp/app_data/models/project_list_response.dart';
import 'package:pran_rfl_erp/app_data/models/qr_user_response.dart';

import '../../presentations/forms/project_forms/project_c_8_screen/project_c_8_screen.dart';

class MainTask {
  final String? taskName;
  final String? taskDesc;
  final Project? projectId;
  final QrUserData? assignee;
  final String? stDate;
  final String? enDate;
  final String? man;
  final String? hr;
  final Department? taskDept;
  final TaskType? taskType;
  final ParentTask? taskparentid;
  final PoJob? jobNo;
  MainTask({
    this.taskName,
    this.taskDesc,
    this.projectId,
    this.assignee,
    this.stDate,
    this.enDate,
    this.man,
    this.hr,
    this.taskDept,
    this.taskType,
    this.taskparentid,
    this.jobNo,
  });

  MainTask copyWith({
    String? taskName,
    String? taskDesc,
    Project? projectId,
    QrUserData? assignee,
    String? stDate,
    String? enDate,
    String? man,
    String? hr,
    TaskType? taskType,
    Department? taskDept,
    ParentTask? taskparentid,
    PoJob? jobNo,
  }) {
    return MainTask(
      taskName: taskName ?? this.taskName,
      taskDesc: taskDesc ?? this.taskDesc,
      projectId: projectId ?? this.projectId,
      assignee: assignee ?? this.assignee,
      man: man ?? this.man,
      hr: hr ?? this.hr,
      stDate: stDate ?? this.stDate,
      enDate: enDate ?? this.enDate,
      taskType: taskType ?? this.taskType,
      taskDept: taskDept ?? this.taskDept,
      taskparentid: taskparentid,
      jobNo: jobNo ?? this.jobNo,
    );
  }
}
