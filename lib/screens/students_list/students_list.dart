import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_management/blocs/student_list/student_list_bloc.dart';
import 'package:library_management/screens/students_list/student_detail_widget.dart';
import 'package:library_management/utils/error_dialog.dart';

class StudentList extends StatefulWidget {
  const StudentList({super.key});

  @override
  State<StudentList> createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  int homePageBuilt = 0;
  @override
  void initState() {
    super.initState();
    context.read<StudentListBloc>().add(LoadListFirstTimeEvent());
  }

  @override
  Widget build(BuildContext context) {
    homePageBuilt++;
    log('Homepage was built this many times $homePageBuilt');
    return BlocListener<StudentListBloc, StudentListState>(
      listener: (context, state) {
        if (state.status == StudentListLoadingStatus.error) {
          errorDialog(context, state.error);
        }
      },
      child: const StudentListView(),
    );
  }
}

class StudentListView extends StatelessWidget {
  const StudentListView({super.key});

  @override
  Widget build(BuildContext context) {
    switch (context.watch<StudentListBloc>().state.status) {
      case StudentListLoadingStatus.loadingList:
        return const Center(
          child: CircularProgressIndicator.adaptive(),
        );

      default:
        return RefreshIndicator.adaptive(
          onRefresh: () async {
            context.read<StudentListBloc>().add(RefreshListEvent());
            await Future.delayed(const Duration(seconds: 2));
          },
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: context.watch<StudentListBloc>().state.students.length,
            itemBuilder: (BuildContext context, int index) {
              final student =
                  context.watch<StudentListBloc>().state.students[index];

              return StudentDetailsCard(student: student);
            },
          ),
        );
    }
  }
}
