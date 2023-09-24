import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:library_management/models/custom_error.dart';
import 'package:library_management/models/student_model.dart';
import 'package:library_management/repositories/student_list_repository.dart';

part 'student_list_event.dart';
part 'student_list_state.dart';

class StudentListBloc extends Bloc<StudentListEvent, StudentListState> {
  final StudentRepository _studentRepository;
  StudentListBloc({required StudentRepository studentRepository})
      : _studentRepository = studentRepository,
        super(StudentListState.initial()) {
    on<LoadListFirstTimeEvent>((event, emit) async {
      emit(state.copyWith(status: StudentListLoadingStatus.loadingList));
      try {
        List<Student> students = await _studentRepository.fetchStudentList();
        emit(state.copyWith(
          status: StudentListLoadingStatus.loadedList,
          students: students,
        ));
      } catch (e) {
        log('caught error on loading');
        emit(state.copyWith(
          error: CustomError(message: e.toString()),
          status: StudentListLoadingStatus.error,
        ));
      }
    });
    on<AddStudentEvent>(
      (event, emit) async {
        log('here123');
        emit(
          state.copyWith(
            addStatus: StudentAddingStatus.addding,
          ),
        );
        log('waiting for 3 seconds');
        await Future.delayed(const Duration(seconds: 3));
        try {
          await _studentRepository.addStudent(event.student);
        } catch (e) {
          emit(state.copyWith(
            error: CustomError(message: e.toString()),
            addStatus: StudentAddingStatus.error,
          ));
        }
        List<Student> students = state.students;
        students.add(event.student);
        emit(state.copyWith(
          students: students,
          addStatus: StudentAddingStatus.added,
        ));
      },
    );
    on<RefreshListEvent>((event, emit) async {
      emit(state.copyWith(status: StudentListLoadingStatus.refreshing));
      try {
        List<Student> students = await _studentRepository.fetchStudentList();
        emit(state.copyWith(
          status: StudentListLoadingStatus.loadedList,
          students: students,
        ));
      } catch (e) {
        log('caught error on refreshing');
        emit(state.copyWith(
          error: CustomError(message: e.toString()),
          status: StudentListLoadingStatus.error,
        ));
      }
    });
    on<AddStudentEventInitial>(
      (event, emit) {
        emit(state.copyWith(addStatus: StudentAddingStatus.initial));
      },
    );
  }
}
