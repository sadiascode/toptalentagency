import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:top_talent_agency/core/roles.dart';

class CustomAlert extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String priorityLabel;
  final Color priorityConColor;
  final Color priorityColor;
  final String categoryLabel;
  final Color categoryLabelCo;
  final String name;
  final String description;
  final String date;
  final Color containerColor;
  final Color containerBorderColor;
  final UiUserRole? userRole;

  const CustomAlert({
    super.key,
    this.icon = Icons.trending_down,
    this.iconColor = Colors.red,
    this.iconBgColor = const Color(0xFFFFE5E5),
    required this.priorityLabel ,
    required this. priorityConColor,
    required this.priorityColor ,
    required this.categoryLabel,
    required this.categoryLabelCo,
    required this.name,
    required this.description,
    required this.date,
    required this.containerColor ,
    required this.containerBorderColor,
    this.userRole,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 159,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: containerColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: containerBorderColor,
            width: 1,
          ),
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Icon
                  Container(
                    width: 37,
                    height: 37,
                    decoration: BoxDecoration(
                      color: iconBgColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      color: iconColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),

                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: priorityConColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      priorityLabel,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 17, vertical: 7),
                    decoration: BoxDecoration(
                      color: priorityColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      categoryLabel,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: categoryLabelCo,
                      ),
                    ),
                  ),
                  Spacer(),
                  // Show notification icon only for admin and manager
                  if (userRole == UiUserRole.admin || userRole == UiUserRole.manager)
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            final TextEditingController _textController = TextEditingController();

                            return Dialog(
                              insetPadding: const EdgeInsets.symmetric(horizontal: 35), //dialog wider
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      "Create notification",
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: const Text(
                                        "Message",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    // TextField
                                    TextField(
                                      controller: _textController,
                                      maxLines: 4, //height
                                      decoration: InputDecoration(
                                        hintText: 'Type your message',
                                        contentPadding: const EdgeInsets.all(16),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(21),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 20),

                                    //   button
                                    GestureDetector(
                                      onTap: () {
                                        final reason = _textController.text.trim();
                                        if (reason.isNotEmpty) {
                                          print("Reason: $reason");
                                        }
                                        Navigator.of(context).pop();
                                      },
                                      child: Container(
                                        height: 50,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius: BorderRadius.circular(22),
                                        ),
                                        alignment: Alignment.center,
                                        child: const Text(
                                          "Send notification",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: SvgPicture.asset(
                        'assets/notification.svg',
                        width: 24,
                        height: 24,
                        color: Colors.white,
                      ),
                    )
                ],
              ),

              const SizedBox(height: 5),
              Expanded(
              child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 57),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      date,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              )
             )
            )
          ]
        )
    );
  }
}