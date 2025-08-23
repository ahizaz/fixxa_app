import 'package:fixxa_app/core/utils/constants/image_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Client extends StatelessWidget {
  const Client({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(3, (index) {
        return Container(
        width: double.infinity,
        height: 98.h,
          decoration: BoxDecoration(
            color: Colors.white,
        
          border: Border.all(
            color: Color(0xffE8E8E8),
            width: 1
          )
          ),
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  CircleAvatar(
                    radius: 24.r,
                    child: Image(image: AssetImage(ImagePath.client1,),fit: BoxFit.cover,),
                  ),
                  Column(
                    children: [
                      Text("Ri")
                    ],
                  )
               
              ],
            ),
          ),
        );
      }),
    );
  }
}
