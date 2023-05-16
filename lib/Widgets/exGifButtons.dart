import 'package:flutter/material.dart';

class GifGrid extends StatelessWidget {
  final List<bool> selectedItems;
  final bool disabled;
  final List<String> exDict;
  final Function onPressed;

  const GifGrid({
    required this.selectedItems,
    this.disabled = false,
    required this.exDict,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.extent(
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      maxCrossAxisExtent: 85,
      padding: EdgeInsets.all(16.0),
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: () {
            if (disabled) return;
            onPressed(index);
          },
          child: ElevatedButton(
            onPressed: null,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      if (selectedItems[index]) {
                        return Theme.of(context).colorScheme.primary;
                      }
                      return Theme.of(context).colorScheme.secondary;
                    },
              ),
              elevation: MaterialStateProperty.resolveWith<double>(
                    (Set<MaterialState> states) {
                  if (selectedItems[index]) {
                    return 10.0;
                  }
                  return 0.0;
                },
              ),
            ),
            child: Image.asset(
              'assets/${exDict[index]}.gif',
              fit: BoxFit.cover,
            ),
          ),
        );
      }),
    );
  }
}