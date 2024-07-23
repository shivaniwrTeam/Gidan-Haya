import 'package:ebroker/data/model/project_model.dart';
import 'package:ebroker/data/repositories/project_repository.dart';

import 'package:ebroker/exports/main_export.dart';

abstract class ManageProjectState {}

class ManageProjectIntial extends ManageProjectState {}

class ManageProjectInProgress extends ManageProjectState {}

class ManageProjectInSuccess extends ManageProjectState {
  final ProjectModel project;
  ManageProjectInSuccess(this.project);
}

class ManageProjectInFail extends ManageProjectState {
  final dynamic error;
  ManageProjectInFail(this.error);
}

enum ManageProjectType { create, update }

class ManageProjectCubit extends Cubit<ManageProjectState> {
  ManageProjectCubit() : super(ManageProjectIntial());
  final ProjectRepository _projectRepository = ProjectRepository();
  void manage(
      {required ManageProjectType type,
      required Map<String, dynamic> data,
      required CallInfo callInfo}) async {
    try {
      emit(ManageProjectInProgress());
      var reposnse =
          await _projectRepository.createProject(data, callInfo: callInfo);
      emit(ManageProjectInSuccess(ProjectModel.fromMap(reposnse['data'][0])));
    } catch (e, st) {
      emit(ManageProjectInFail(
        st,
      ));
    }
  }
}
