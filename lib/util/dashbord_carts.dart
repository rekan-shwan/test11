import 'package:flutter/material.dart';

class DashbordCarts extends StatefulWidget {
  final String title;
  final int number;
  final Color color;
  final IconData icon;
  final double hieght;
  final double width;
  final double fontSize;

  const DashbordCarts({
    super.key,
    this.hieght = 140,
    this.fontSize = 20,
    this.width = 200,
    this.title = '',
    this.number = 0,
    this.color = const Color(0xFFDEEAEA),
    this.icon = Icons.not_interested_rounded,
  });

  @override
  State<DashbordCarts> createState() => _CardsState();
}

class _CardsState extends State<DashbordCarts> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      width: widget.width,
      height: widget.hieght,
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.title,
            style: TextStyle(fontSize: widget.fontSize),
          ),
          Divider(color: Colors.black26),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${widget.number}',
                style: TextStyle(fontSize: 25),
              ),
              Icon(widget.icon, size: 40),
            ],
          ),
        ],
      ),
    );
  }
}
