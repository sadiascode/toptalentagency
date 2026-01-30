import 'package:flutter/material.dart';
import 'bottom_tab_item.dart';

class CustomBottomNav extends StatelessWidget {
  final List<BottomTabItem> tabs;
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNav({
    super.key,
    required this.tabs,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final centerIndex = tabs.indexWhere((e) => e.isCenter);

    return SizedBox(
      height: 72,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 72,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: const BoxDecoration(
                color: Color(0xFF0F172A),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: List.generate(tabs.length, (i) {
                  if (i == centerIndex) {
                    return const Expanded(
                      child: SizedBox(height: 1),
                    );
                  }

                  return Expanded(
                    child: _navItem(i, tabs[i]),
                  );
                }),
              ),
            ),
          ),

          ///  Center Button (perfect center)
          Positioned(
            bottom: 25,
            child: _centerButton(centerIndex),
          ),
        ],
      ),
    );
  }

  Widget _navItem(int index, BottomTabItem tab) {
    final isSelected = index == currentIndex;

    return InkWell(
      onTap: () => onTap(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            tab.icon,
            size: 22,
            color: isSelected ? const Color(0xff386BF6) : Colors.grey,
          ),
          const SizedBox(height: 4),
          Text(
            tab.label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: isSelected ? Colors.white : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _centerButton(int index) {
    if (index < 0) return const SizedBox(); // no center button if hidden
    final isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        height: 68,
        width: 68,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF6D5DF6),
          border: isSelected
              ? Border.all(color: const Color(0xffA9C0FF), width: 4)
              : null,
          boxShadow: const [
            BoxShadow(
                color: Colors.black26, blurRadius: 12, offset: Offset(0, 6))
          ],
        ),
        child: const Icon(Icons.home_outlined, color: Colors.white, size: 26),
      ),
    );
  }
}
