import 'package:flutter/material.dart';
import 'package:top_talent_agency/features/manager/widget/custom_rankcoin.dart';

import '../../../common/custom_color.dart';

class SarasRank extends StatelessWidget {
  const SarasRank({super.key});

  @override
  Widget build(BuildContext context) {
    final double sw = MediaQuery.of(context).size.width;
    final double imageSize = sw * 0.18;
    final double rankFont = sw * 0.1;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.black,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: ( Icon(Icons.arrow_back_ios, color: Colors.white, size: 18))),
        title: const Text(
          "Rank of Sarah’s Creators",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 25),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: sw * 0.08),
              child: Row(
                children: [
                  Expanded(
                    child:Column(
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200',
                                width: imageSize,
                                height: imageSize,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: -rankFont * 0.6,
                              right: -rankFont * 0.2,
                              child: Text(
                                '1',
                                style: TextStyle(
                                  fontSize: rankFont,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xff679929),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Sophie Kihm',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: sw * 0.04,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child:Column(
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200',
                                width: imageSize,
                                height: imageSize,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: -rankFont * 0.6,
                              right: -rankFont * 0.2,
                              child: Text(
                                '2',
                                style: TextStyle(
                                  fontSize: rankFont,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xffD08700),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Lisa Anderson',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: sw * 0.04,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child:Column(
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?w=200',
                                width: imageSize,
                                height: imageSize,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: -rankFont * 0.6,
                              right: -rankFont * 0.2,
                              child: Text(
                                '3',
                                style: TextStyle(
                                  fontSize: rankFont,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xff306B9C),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Van Dijk',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: sw * 0.04,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(1.5), //  border thickness
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: AppColors.primaryGradient,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            height: 520,
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(10),
            ),
              child: SingleChildScrollView(
              child: Column(
                  children: [
                    SizedBox(height: 10),
                    CustomRankcoin(
                        rank: '4', name: "Sarah Johnson",
                        hours: '5.6h', followers: '18,200 followers',
                        coins: '1,743'
                    ),
                    SizedBox(height: 20),

                    CustomRankcoin(
                        rank: '5', name: "Sarah Johnson",
                        hours: '5.6h', followers: '18,200 followers',
                        coins: '1,743'
                    ),
                    SizedBox(height: 20),

                    CustomRankcoin(
                        rank: '6', name: "Sarah Johnson",
                        hours: '5.6h', followers: '18,200 followers',
                        coins: '1,743'
                    ),
                    SizedBox(height: 20),

                    CustomRankcoin(
                        rank: '7', name: "Sarah Johnson",
                        hours: '5.6h', followers: '18,200 followers',
                        coins: '1,743'
                    ),
                    SizedBox(height: 20),

                    CustomRankcoin(
                        rank: '8', name: "Sarah Johnson",
                        hours: '5.6h', followers: '18,200 followers',
                        coins: '1,743'
                    ),
                    SizedBox(height: 20),

                    CustomRankcoin(
                        rank: '9', name: "Sarah Johnson",
                        hours: '5.6h', followers: '18,200 followers',
                        coins: '1,743'
                    ),
                    SizedBox(height: 20),

                    CustomRankcoin(
                        rank: '10', name: "Sarah Johnson",
                        hours: '5.6h', followers: '18,200 followers',
                        coins: '1,743'
                    ),
                    SizedBox(height: 20),

                    CustomRankcoin(
                        rank: '11', name: "Sarah Johnson",
                        hours: '5.6h', followers: '18,200 followers',
                        coins: '1,743'
                    ),
                    SizedBox(height: 20),

                    CustomRankcoin(
                        rank: '12', name: "Sarah Johnson",
                        hours: '5.6h', followers: '18,200 followers',
                        coins: '1,743'
                    ),
                    SizedBox(height: 20),

                    CustomRankcoin(
                        rank: '13', name: "Sarah Johnson",
                        hours: '5.6h', followers: '18,200 followers',
                        coins: '1,743'
                    ),
                    SizedBox(height: 20),
                  ]
                ),
              ),
            ),
        ),
          ],
        ),
      ),
    );
  }
}
