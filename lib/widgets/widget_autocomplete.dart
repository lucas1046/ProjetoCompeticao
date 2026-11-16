import 'package:flutter/material.dart';

class AutocompleteItem {
  final dynamic id;
  final String label;

  AutocompleteItem(this.id, this.label);

  @override
  String toString() => label;
}

class WidgetAutocomplete extends StatefulWidget {
  final String rotulo;
  final List<AutocompleteItem> itens;
  final dynamic initialValue;
  final void Function(dynamic) onSelected;

  const WidgetAutocomplete({
    super.key,
    required this.rotulo,
    required this.itens,
    this.initialValue,
    required this.onSelected,
  });

  @override
  State<WidgetAutocomplete> createState() => _WidgetAutocompleteState();
}

class _WidgetAutocompleteState extends State<WidgetAutocomplete> {
  TextEditingController? _controller;
  dynamic _lastInitialValue;

  @override
  Widget build(BuildContext context) {
    // Buscar o item inicial a partir do ID (comparando string pra aceitar int ou String)
    final initialItem = widget.initialValue != null
        ? widget.itens.cast<AutocompleteItem?>().firstWhere(
            (i) => i?.id.toString() == widget.initialValue.toString(),
            orElse: () => null)
        : null;

    if (_controller != null && initialItem != null) {
      if (_controller!.text.isEmpty || _lastInitialValue != widget.initialValue) {
        _lastInitialValue = widget.initialValue;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && _controller != null && _controller!.text.isEmpty) {
            _controller!.text = initialItem.label;
          }
        });
      }
    }

    return Autocomplete<AutocompleteItem>(
      displayStringForOption: (AutocompleteItem option) => option.label,
      initialValue: initialItem != null
          ? TextEditingValue(text: initialItem.label)
          : null,
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return widget.itens;
        }
        return widget.itens.where((AutocompleteItem option) {
          return option.label
              .toLowerCase()
              .contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: (AutocompleteItem selection) {
        widget.onSelected(selection.id);
      },
      fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
        _controller = textEditingController;
        if (initialItem != null && textEditingController.text.isEmpty) {
          textEditingController.text = initialItem.label;
        }
        return TextFormField(
          controller: textEditingController,
          focusNode: focusNode,
          onChanged: (val) {
            // Se o usuário limpar o campo, desfazemos a seleção do ID
            if (val.isEmpty) {
              widget.onSelected(null);
            }
          },
          style: const TextStyle(
            color: Colors.black,
            backgroundColor: Colors.white,
            fontSize: 18,
          ),
          decoration: InputDecoration(
            labelText: widget.rotulo,
            hintText: 'Digite para buscar',
            border: const OutlineInputBorder(),
          ),
        );
      },
    );
  }
}
