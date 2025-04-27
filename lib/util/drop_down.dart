

import 'package:flutter/material.dart';

class DropDown extends StatefulWidget {
  final double containerWidth;
  final double containerHieght;
  final Future<List<dynamic>> Function() fetchData;
  final TextEditingController textEditingController;
  final double itemHeight;
  final OverlayPortalController overlayPortalController;
  final String showText;
  final Function(String)? onChanged;
  final Function(dynamic) onChoose;
  final Function()? onCanle;
  final IconData icon;
  final String hintText;
  final Icon prefixIcon;
  final bool isSearch;
  final bool isIcon;
  final Color color;
  const DropDown({
    super.key,
    this.onCanle,
    this.showText = '',
    this.onChanged,
    this.isSearch = true,
    this.isIcon = false,
    required this.textEditingController,
    this.hintText = '',
    this.color = Colors.black,
    this.icon = Icons.arrow_drop_down,
    required this.onChoose,
    this.prefixIcon = const Icon(Icons.search),
    this.itemHeight = 30,
    required this.fetchData,
    this.containerWidth = 200,
    this.containerHieght = 30,
    required this.overlayPortalController,
  });
  @override
  State<DropDown> createState() => _DropDownState();
}

class _DropDownState extends State<DropDown>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final LayerLink _link = LayerLink();
  bool showTextField = false;
  List<dynamic> _list = [];
  List<dynamic> _originalList = []; 
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    _originalList = await widget.fetchData();
    _list = List.from(_originalList); 
    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  bool _fieldContainsQuery(dynamic item, String field, String query) {
    if (item == null || !item.containsKey(field) || item[field] == null) {
      return false;
    }
    return item[field].toString().toLowerCase().contains(query.toLowerCase());
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: widget.containerWidth,
          height: widget.containerHieght,
          child: CompositedTransformTarget(
            link: _link,
            child: widget.isIcon && !showTextField
                ? IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      setState(() {
                        showTextField = true;
                      });
                    },
                  )
                : Row(
                    children: [
                      Expanded(
                        child: TextField(
                          readOnly: !widget.isSearch,
                          controller: widget.textEditingController,
                          onTap: () {
                            widget.overlayPortalController.show();
                          },
                          autocorrect: false,
                          onChanged: (query) {
                            setState(() {
                              if (query.isEmpty) {
                                _list = List.from(
                                    _originalList); 
                              } else {
                                _list = _originalList.where((patient) {
                               
                                  return _fieldContainsQuery(
                                          patient, 'pname', query) ||
                                      _fieldContainsQuery(
                                          patient, 'psecondName', query) ||
                                      _fieldContainsQuery(
                                          patient, 'pphone', query);
                                }).toList();
                              }
                            });
                            
                            if (widget.onChanged != null) {
                              widget.onChanged!(query);
                            }
                          },
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () {
                                widget.onCanle?.call();
                                setState(() {
                                  showTextField = false;
                                  widget.textEditingController.clear();
                                  widget.overlayPortalController.hide();
                                });
                              },
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.transparent, width: 2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xFF47AEC6), width: 2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            filled: true,
                            fillColor: Colors.black12,
                            hintStyle: TextStyle(
                              color: Colors.black45,
                            ),
                            prefixIcon: widget.prefixIcon,
                            hintText: widget.hintText,
                            contentPadding: EdgeInsets.all(3),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        _overlay(),
      ],
    );
  }

  OverlayPortal _overlay() {
    return OverlayPortal(
      controller: widget.overlayPortalController,
      overlayChildBuilder: (context) {
        return Positioned(
          width: widget.containerWidth,
          child: CompositedTransformFollower(
            link: _link,
            offset: Offset(0, widget.containerHieght + 5),
            child: Container(
              width: widget.containerWidth,
              decoration: BoxDecoration(
                color: widget.color,
                borderRadius: BorderRadius.circular(10),
              ),
              height: _isLoading
                  ? 50
                  : (_list.isEmpty
                      ? 50 
                      : (_list.length > 4
                          ? widget.containerHieght * 4
                          : widget.containerHieght * _list.length + 40)),
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _list.isEmpty
                      ? Center(
                          child: Text(
                            'No results found',
                            style: TextStyle(color: Colors.white54),
                          ),
                        )
                      : ListView.builder(
                          itemCount: _list.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                widget.onChoose(_list[index]);

                                setState(() {
                                  showTextField = false;
                                  widget.overlayPortalController.hide();
                                });
                              },
                              child: SizedBox(
                                height: 50,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      widget.icon,
                                      color: Colors.white38,
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${_list[index]['pname'] ?? ''} ${_list[index]['psecondName'] ?? ''}',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                color: Colors.white54),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          if (_list[index]['pphone'] != null)
                                            Text(
                                              '${_list[index]['pphone']}',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  color: Colors.white38,
                                                  fontSize: 12),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                        ],
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
