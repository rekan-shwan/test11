import 'package:flutter/material.dart';

class DropDown extends StatefulWidget {
  final double containerWidth;
  final double containerHeight;
  final List<dynamic> list;
  final TextEditingController textEditingController;
  final double itemHeight;
  final OverlayPortalController overlayPortalController;
  final String showText;
  final Function(String)? onChanged;
  final Function(String value) onChoose;
  final Function()? onCancel;
  final IconData icon;
  final String hintText;
  final Icon prefixIcon;
  final bool isSearch;
  final bool isIcon;
  final Color color;

  const DropDown({
    super.key,
    this.onCancel,
    this.showText = '',
    this.onChanged,
    this.isSearch = true,
    this.isIcon = false,
    required this.textEditingController,
    this.hintText = '',
    this.color = Colors.black,
    this.icon = Icons.arrow_drop_down,
    required this.onChoose,
    this.prefixIcon = const Icon(Icons.arrow_drop_down),
    this.itemHeight = 30,
    required this.list,
    this.containerWidth = 200,
    this.containerHeight = 30,
    required this.overlayPortalController,
  });

  @override
  State<DropDown> createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
  bool showTextField = false;
  final LayerLink _link = LayerLink();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (!widget.isIcon || showTextField)
          SizedBox(
            width: widget.containerWidth,
            height: widget.containerHeight,
            child: CompositedTransformTarget(
              link: _link,
              child: TextField(
                readOnly: !widget.isSearch ? false : true,
                controller: widget.textEditingController,
                onTap: () {
                  widget.overlayPortalController.toggle();
                },
                autocorrect: false,
                onChanged: widget.onChanged,
                decoration: InputDecoration(
                  suffix: widget.isSearch
                      ? const SizedBox(width: 10)
                      : IconButton(
                          onPressed: () {
                            if (widget.onCancel != null) {
                              widget.onCancel!();
                            }
                            widget.overlayPortalController.hide();
                            widget.textEditingController.clear();
                          },
                          icon: Icon(widget.overlayPortalController.isShowing
                              ? Icons.cancel
                              : Icons.arrow_drop_down),
                          iconSize: 15,
                        ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: const Color.fromARGB(255, 255, 17, 0), width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.black12,
                  hintStyle: const TextStyle(color: Colors.black45),
                  prefixIcon: widget.prefixIcon,
                  hintText: widget.hintText,
                  contentPadding: const EdgeInsets.all(3),
                ),
              ),
            ),
          )
        else
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              setState(() {
                showTextField = true;
              });
            },
          ),
        _overlay()
      ],
    );
  }

  OverlayPortal _overlay() {
    return OverlayPortal(
      controller: widget.overlayPortalController,
      overlayChildBuilder: (context) {
        return Positioned(
          top: 20,
          left: 200,
          child: CompositedTransformFollower(
            link: _link,
            offset: Offset(0, widget.containerHeight + 5),
            child: Container(
              width: widget.containerWidth,
              decoration: BoxDecoration(
                color: widget.color,
                borderRadius: BorderRadius.circular(10),
              ),
              height: widget.list.length > 4
                  ? widget.containerHeight * 4
                  : widget.containerHeight * widget.list.length + 40,
              child: ListView.builder(
                itemCount: widget.list.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      widget.onChoose(widget.list[index]);
                    },
                    child: Container(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          widget.isSearch
                              ? const SizedBox(width: 10)
                              : Icon(
                                  widget.icon,
                                  color: Colors.white38,
                                ),
                          SizedBox(
                            height: 20,
                            child: Text(
                              '${widget.list[index]}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white54),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
