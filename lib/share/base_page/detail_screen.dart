import 'package:provider/provider.dart';

import '../app_imports.dart';

abstract class BaseDetailViewModel with ChangeNotifier {
  void fetchData();
}


class DetailScreen<T extends BaseDetailViewModel> extends StatelessWidget {
  final List<String> ids;
  final T viewModel;
  final Widget Function(BuildContext, T) contentBuilder;

  DetailScreen({Key? key, required this.ids, required this.viewModel, required this.contentBuilder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    viewModel.fetchData();
    return ChangeNotifierProvider<T>.value(
      value: viewModel,
      child: Consumer<T>(
        builder: (context, vm, _) => contentBuilder(context, vm),
      ),
    );
  }
}


