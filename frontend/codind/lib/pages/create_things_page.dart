import 'package:codind/pages/_mobile_base_page.dart';
import 'package:flutter/material.dart';

class CreateKnowledgeBasePage extends MobileBasePage {
  CreateKnowledgeBasePage({Key? key, required pageName})
      : super(key: key, pageName: pageName);

  @override
  MobileBasePageState<MobileBasePage> getState() {
    return _CreateKnowledgePageState();
  }
}

class _CreateKnowledgePageState<T>
    extends MobileBasePageState<CreateKnowledgeBasePage> {
  @override
  baseBuild(BuildContext context) {
    return super.baseBuild(context);
  }
}
