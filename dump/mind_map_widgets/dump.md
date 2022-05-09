```dart
 Widget buildView() {
    if (isRoot) {
      if (status == MindMapNodeWidgetStatus.read) {
        return Container(
          constraints: const BoxConstraints(minHeight: 20, minWidth: 40),
          padding:
              const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
          child: Text(widget.mindMapNodeV2.label ?? "new node"),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular((20.0)),
              border: Border.all(color: Colors.blue, width: 0.5)),
        );
      } else if (status == MindMapNodeWidgetStatus.add) {
        return Row(
          children: [
            Container(
              constraints: const BoxConstraints(minHeight: 20, minWidth: 40),
              padding: const EdgeInsets.only(
                  top: 10, bottom: 10, left: 20, right: 20),
              child: Text(widget.mindMapNodeV2.label ?? "new node"),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular((20.0)),
                  border: Border.all(color: Colors.blue, width: 0.5)),
            ),
            const SizedBox(
              width: 3,
            ),
            IconButton(
                onPressed: () {
                  debugPrint("[debug MindMapPage]: left add button clicked");
                  widget.createChild();
                  setState(() {
                    status = MindMapNodeWidgetStatus.read;
                  });
                },
                icon: const Icon(Icons.add)),
          ],
        );
      } else {
        return Container(
          constraints: const BoxConstraints(minHeight: 20, minWidth: 40),
          padding:
              const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular((20.0)),
              border: Border.all(color: Colors.blue, width: 0.5)),
        );
      }
    } else {
      return Container(
        constraints: const BoxConstraints(minHeight: 20, minWidth: 40),
        padding:
            const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
        child: Text(widget.mindMapNodeV2.label ?? "new node"),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular((20.0)),
            border: Border.all(color: Colors.blue, width: 0.5)),
      );
    }
  }


```