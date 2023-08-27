import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo/controllers/task_controller.dart';
import 'package:todo/services/notification_services.dart';
import 'package:todo/services/theme_services.dart';
import 'package:todo/ui/pages/add_task_page.dart';
import 'package:todo/ui/size_config.dart';
import 'package:todo/ui/theme.dart';
import 'package:todo/ui/widgets/button.dart';
import 'package:todo/ui/widgets/task_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TaskController _taskController = Get.put(TaskController());
  DateTime _selectedDate = DateTime.now();
  @override
  void initState() {
    super.initState();
    _taskController.getTask();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(),
      body: Center(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _addTaskBar(),
            _addDateBar(),
            const SizedBox(height: 8),
            _showTask(),
          ],
        ),
      ),
    );
  }

  AppBar _appBar() => AppBar(
        elevation: 0,
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
            onPressed: () {
              ThemeServices().switchModeTheme();
              NotifyHelper().displayNotification(title: 'title', body: 'body');
              // NotifyHelper().scheduledNotification(1,1,task);
            },
            icon: Icon(
              Get.isDarkMode
                  ? Icons.wb_sunny_outlined
                  : Icons.nightlight_round_outlined,
              color: Get.isDarkMode ? Colors.white : Colors.black,
              size: 24,
            )),
      );

  _addTaskBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 10, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMMd().format(DateTime.now()),
                style: subHeadingStyle,
              ),
              Text(
                'Today',
                style: subHeadingStyle,
              ),
            ],
          ),
          MyButton(
              label: '+ Add Task',
              onTab: () async {
                await Get.to(const AddTaskPage());
                _taskController.getTask();
              })
        ],
      ),
    );
  }

  _addDateBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, top: 6),
      child: DatePicker(
        DateTime.now(),
        width: 70,
        height: 100,
        initialSelectedDate: _selectedDate,
        selectionColor: primaryClr,
        selectedTextColor: Colors.white,
        // deactivatedColor: Colors.white,
        dateTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
        dayTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
              fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
        monthTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
              fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
        onDateChange: (newDateTime) {
          setState(() {
            _selectedDate = newDateTime;
          });
        },
      ),
    );
  }

  _showTask() {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: (() async {
          _taskController.getTask();
        }),
        child: Obx(
          () {
            if (_taskController.taskList.isEmpty) {
              return _noTaskMsg();
            } else {
              return ListView.builder(
                  scrollDirection:
                      SizeConfig.orientation == Orientation.landscape
                          ? Axis.horizontal
                          : Axis.vertical,
                  itemCount: _taskController.taskList.length,
                  itemBuilder: (context, index) {
                    var task = _taskController.taskList[index];
                    return Container(
                      child: GestureDetector(
                        onTap: () {
                          Get.bottomSheet(Container(
                            color: context.theme.backgroundColor,
                            child: Column(
                              children: [
                                TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    task.isCompleted == 0
                                        ? 'Completed'
                                        : 'cancel',
                                  ),
                                )
                              ],
                            ),
                          ));
                        },
                        child: TaskTile(
                          task: task,
                        ),
                      ),
                    );
                  });
            }
          },
        ),
      ),
    );
  }

  _noTaskMsg() {
    return Stack(
      children: [
        AnimatedPositioned(
          duration: const Duration(milliseconds: 2000),
          child: SingleChildScrollView(
            child: Wrap(
              direction: SizeConfig.orientation == Orientation.landscape
                  ? Axis.vertical
                  : Axis.horizontal,
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SizeConfig.orientation == Orientation.landscape
                    ? const SizedBox(height: 220)
                    : const SizedBox(height: 220),
                SvgPicture.asset(
                  'images/task.svg',
                  height: 90,
                  color: primaryClr.withOpacity(0.5),
                  semanticsLabel: 'Task ',
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 10,
                  ),
                  child: Text(
                    'Empty data task you  add new task add new task add new task ',
                    style: subTitleStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizeConfig.orientation == Orientation.landscape
                    ? const SizedBox(height: 180)
                    : const SizedBox(height: 180),
              ],
            ),
          ),
        )
      ],
    );
  }
}

_buildBottomSheet(
    {required String label,
    required Function() onTap,
    required Color clr,
    bool isClose = false}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      height: 65,
      width: SizeConfig.screenWidth * 0.9,
      decoration: BoxDecoration(
        border: Border.all(
          width: 2,
          color: isClose
              ? Get.isDarkMode
                  ? Colors.grey[600]!
                  : Colors.grey[300]!
              : clr,
        ),
        borderRadius: BorderRadius.circular(20),
        color: isClose ? Colors.transparent : clr,
      ), // BoxDecoration
    ),
  );
}
