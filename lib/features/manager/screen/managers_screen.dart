import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:top_talent_agency/features/manager/screen/manager_rank.dart';
import 'package:top_talent_agency/features/manager/widget/custom_sortview.dart';
import '../widget/custom_search.dart';

class ManagersScreen extends StatelessWidget {
  const ManagersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Managers",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 15),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              const SizedBox(height: 20),
              CustomSearch(),

              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Showing 20 of 20 managers",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ManagerRank(),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: SvgPicture.asset(
                        'assets/soil.svg',
                        color: Colors.white,
                        width: 25,
                        height: 25,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              CustomSortview(),

              SizedBox(height: 20),
              CustomSortview(),

              SizedBox(height: 20),
              CustomSortview(),
            ],
          ),
        ),
      ),
    );
  }
}


