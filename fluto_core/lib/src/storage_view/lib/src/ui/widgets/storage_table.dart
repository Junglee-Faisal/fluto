import 'dart:io';

import 'package:fluto_core/src/storage_view/lib/src/ui/controller/storage_viewer_controller.dart';
import 'package:fluto_core/src/storage_view/lib/src/ui/theme/storage_view_theme.dart';
import 'package:fluto_core/src/storage_view/lib/src/ui/widgets/forms/edit/edit_field_form.dart';
import 'package:fluto_core/src/storage_view/lib/src/ui/widgets/modals/delete/delete_confirmation_modal.dart';
import 'package:flutter/material.dart';

class StorageTable extends StatefulWidget {
  const StorageTable({
    super.key,
    required this.theme,
    required this.controller,
    required this.storageEnties,
  });

  final StorageViewerController controller;
  final StorageViewTheme theme;
  final Map<String, dynamic> storageEnties;

  @override
  State<StorageTable> createState() => _StorageTableState();
}

class _StorageTableState extends State<StorageTable> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final deleteIconTheme = widget.theme.deleteIconTheme;
    bool isSmallScreen = (Platform.isIOS || Platform.isAndroid);
    return Container(
      margin: EdgeInsets.all(isSmallScreen ? 0 : 20),
      padding: EdgeInsets.all(isSmallScreen ? 10 : 20),
      decoration: BoxDecoration(
        color: widget.theme.cardColor,
        borderRadius:
            isSmallScreen ? BorderRadius.zero : BorderRadius.circular(6),
      ),
      child: DataTable(
        showCheckboxColumn: true,
        onSelectAll: (selected) {
          widget.controller.toggleAllKeys(selected);
        },
        checkboxHorizontalMargin: 16,
        horizontalMargin: isSmallScreen ? 10 : 20,
        columnSpacing: isSmallScreen ? 20 : 40,
        border: widget.theme.tableBorder ?? _getDefaultTableBorder(),
        columns: <DataColumn>[
          DataColumn(
            label: Container(
              constraints: BoxConstraints(maxWidth: size.width * 0.1),
              child: Text(
                'Key',
                style: widget.theme.columnTitleTextStyle,
              ),
            ),
            onSort: widget.controller.cangeFilter,
          ),
          DataColumn(
            label: Text(
              'Value',
              style: widget.theme.columnTitleTextStyle,
            ),
            onSort: widget.controller.cangeFilter,
          ),
          DataColumn(
            label: Text(
              'Type',
              style: widget.theme.columnTitleTextStyle,
            ),
            onSort: widget.controller.cangeFilter,
          ),
          const DataColumn(label: Text('')),
        ],
        rows: widget.storageEnties.entries
            .map(
              (e) => DataRow(
                selected: widget.controller.selectedKeys.contains(e.key),
                onLongPress: () => _onCeilTap(e),
                onSelectChanged: (_) => widget.controller.setKeySelected(e.key),
                cells: <DataCell>[
                  DataCell(
                    Container(
                      constraints: isSmallScreen
                          ? null
                          : BoxConstraints(maxWidth: size.width * 0.2),
                      child: Text(
                        e.key,
                        style: widget.theme.cellTextStyle,
                      ),
                    ),
                    onTap: () => _onCeilTap(e),
                  ),
                  DataCell(
                    Container(
                      constraints: isSmallScreen
                          ? BoxConstraints(maxWidth: size.width * 0.7)
                          : BoxConstraints(maxWidth: size.width * 0.2),
                      child: Text(
                        '${e.value}',
                        style: widget.theme.cellTextStyle,
                      ),
                    ),
                    onTap: () => _onCeilTap(e),
                  ),
                  DataCell(
                    Container(
                      constraints: isSmallScreen
                          ? null
                          : BoxConstraints(maxWidth: size.width * 0.2),
                      child: Text(
                        '${e.value.runtimeType}',
                        style: widget.theme.cellTextStyle,
                      ),
                    ),
                    onTap: () => _onCeilTap(e),
                  ),
                  DataCell(
                    widget.theme.deleteIcon ??
                        Icon(
                          Icons.close,
                          color: deleteIconTheme?.color,
                          size: deleteIconTheme?.size,
                        ),
                    onTap: () => _deleteByKey(e),
                  ),
                ],
              ),
            )
            .toList(),
      ),
    );
  }

  Future<void> _deleteByKey(MapEntry<String, dynamic> e) async {
    final confirmDelete = await showDialog<bool>(
      context: context,
      builder: (context) => DeleteConfirmationModal(
        theme: widget.theme,
      ),
    );
    if (confirmDelete ?? false) {
      widget.controller.delete(e.key);
    }
  }

  void _onCeilTap(MapEntry<String, dynamic> e) {
    _showEditDialog(e);
  }

  void _showEditDialog(MapEntry<String, dynamic> e) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.all(0),
        backgroundColor: Colors.transparent,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          child: EditFieldForm(
            width: double.infinity,
            theme: widget.theme,
            entry: e,
            onDeleted: () {
              widget.controller.delete(e.key);
              Navigator.pop(context);
            },
            onUpdated: (value) {
              widget.controller.update(e.key, value);
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }

  TableBorder _getDefaultTableBorder() {
    return TableBorder.all(color: Colors.white.withOpacity(0.2), width: 1);
  }
}
