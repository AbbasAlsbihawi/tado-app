import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo/controllers/task_controller.dart';
import 'package:todo/models/task.dart';
import 'package:todo/ui/theme.dart';
import 'package:todo/ui/widgets/button.dart';
import 'package:todo/ui/widgets/input_field.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final DateTime _selectedDate = DateTime.now();
  final String _startTime =
      DateFormat('hh:mma').format(DateTime.now()).toString();
  final String _endTime = DateFormat('hh:mma')
      .format(DateTime.now().add(const Duration(minutes: 15)))
      .toString();
  int _selectedRemind = 5;
  List<int> remindList = [5, 10, 15, 20];
  String _selectedRepeat = 'None';
  final List<String> _repeatList = ['None', 'Daily', 'Weekly', 'Monthly'];
  int _selectedColor = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: SingleChildScrollView(
            child: Column(
          children: [
            // Text(
            //   'Add Task',
            //   style: headingStyle,
            // ),
            // const SizedBox(height: 10),
            InputField(
              title: 'Title',
              hint: 'Enter Title here',
              // widget: Icon(Icons.alarm),
              controller: _titleController,
            ),
            const SizedBox(height: 10),
            InputField(
              title: 'Note',
              hint: 'Enter note here',
              // widget: Icon(Icons.alarm),
              controller: _noteController,
            ),
            const SizedBox(height: 10),
            InputField(
              title: 'Date',
              hint: DateFormat.yMd().format(_selectedDate),
              widget: IconButton(
                padding: const EdgeInsets.all(0),
                alignment: Alignment.centerRight,
                icon: const Icon(Icons.calendar_today_outlined),
                onPressed: () {},
              ),
              // controller: _titleController,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: InputField(
                    title: 'Start Time',
                    hint: _startTime,
                    widget: IconButton(
                      padding: const EdgeInsets.all(0),
                      alignment: Alignment.centerRight,
                      icon: const Icon(Icons.access_time),
                      onPressed: () {},
                    ),
                    // controller: _titleController,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: InputField(
                    title: 'End Time',
                    hint: _endTime,
                    widget: IconButton(
                      padding: const EdgeInsets.all(0),
                      alignment: Alignment.centerRight,
                      icon: const Icon(Icons.access_time),
                      onPressed: () {},
                    ),
                    // controller: _titleController,
                  ),
                ),
              ],
            ),
            InputField(
              title: 'Remind',
              hint: '$_selectedRemind minutes early',
              widget: DropdownButton(
                items: remindList
                    .map(
                      (item) => DropdownMenuItem(
                        value: item,
                        child: Text('$item'),
                      ),
                    )
                    .toList(),
                onChanged: (int? val) {
                  setState(() {
                    _selectedRemind = val!;
                  });
                },
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  size: 32,
                ),
                elevation: 4,
                underline: Container(height: 0),
              ),
              // controller: _titleController,
            ),
            const SizedBox(height: 10),
            InputField(
              title: 'Remind',
              hint: _selectedRepeat,
              widget: DropdownButton(
                // value: _selectedRepeat,
                items: _repeatList
                    .map(
                      (String item) => DropdownMenuItem(
                        value: item,
                        child: Text(item),
                      ),
                    )
                    .toList(),
                onChanged: (String? val) {
                  setState(() {
                    _selectedRepeat = val!;
                  });
                },
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  size: 32,
                ),
                elevation: 4,
                underline: Container(height: 0),
              ),
              // controller: _titleController,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _colorPalette(),
                Column(
                  children: [
                    const SizedBox(height: 10),
                    MyButton(
                        label: 'Create Task', onTab: () => _validationData()),
                  ],
                )
              ],
            ),
            const SizedBox(height: 10),
          ],
        )),
      ),
    );
  }

  _validationData() async {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      await _addTasksToDb();
      Get.back();
    } else if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      Get.snackbar('require', 'Title and note is require !',
          colorText: pinkClr,
          backgroundColor: Colors.white,
          icon: const Icon(
            Icons.warning_amber_rounded,
            color: Colors.red,
          ));
    }
  }

  _addTasksToDb() async {
    int val = await _taskController.addTask(
      task: Task(
        title: _titleController.text,
        note: _noteController.text,
        date: DateFormat.yMd().format(_selectedDate),
        isCompleted: 0,
        color: _selectedColor,
        startTime: _startTime,
        endTime: _endTime,
        remind: _selectedRemind,
        repeat: _selectedRepeat,
      ),
    );
    print(val);
  }

  AppBar _appBar() => AppBar(
        elevation: 0,
        title: Center(
          child: Text(
            'Add Task',
            style: headingStyle,
          ),
        ),
        backgroundColor: context.theme.backgroundColor,
        actions: [
          IconButton(
              onPressed: () => {},
              icon: const Icon(
                Icons.add,
                color: primaryClr,
                size: 35,
              ))
        ],
        leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(
              Icons.arrow_back_ios,
              color: primaryClr,
              size: 24,
            )),
      );

  Column _colorPalette() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Color',
          style: titleStyle,
        ),
        const SizedBox(height: 10),
        Wrap(
          children: List.generate(
            3,
            (index) => GestureDetector(
              onTap: () {
                setState(() {
                  _selectedColor = index;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: index == 0
                      ? primaryClr
                      : index == 1
                          ? pinkClr
                          : orangeClr,
                  child: Icon(
                    color: Colors.white,
                    _selectedColor == index ? Icons.done : null,
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
