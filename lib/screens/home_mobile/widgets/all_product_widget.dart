part of '../home_mobile_screen.dart';

class _AllProductWidget extends StatelessWidget {
  const _AllProductWidget({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final width = SizeConfig.screenWidth!;
    final height = SizeConfig.screenHeight!;

    return Consumer<HomeMobileScreenVm>(builder: (context, vm, child) {
      final int gridItemCount = 4;
      final List<Product?> displayProducts =
      List<Product?>.from(vm.currentProducts.reversed) // 👈 đảo ngược list
        ..addAll(
          List<Product?>.filled(
            gridItemCount - vm.currentProducts.length,
            null,
          ),
        );

      return Padding(
        padding: AppStyle.padding_LR_16().copyWith(
            left: width < 1200 ? 8 : width * 0.15,
            right: width < 1200 ? 8 : width * 0.15),
        child: Padding(
          padding: AppStyle.padding_LR_32(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    Assets.png.aa.keyName,
                    fit: BoxFit.cover,
                    // height: 500,
                    width: width < 1200 ? width : 1200,
                  ),
                ),
              ),
              SizedBox(
                key: vm.product,
                height: 128,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  KSText(
                    textAlign: TextAlign.right,
                    S.current.all_product,
                    style: KSTheme.of(context)
                        .style
                        .ts42w500
                        .copyWith(color: AppStyle.blackLite),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    width: 0.45 * width,
                    child: KSText(
                      textAlign: TextAlign.left,
                      S.current.all_product_detail,
                      style: KSTheme.of(context).style.ts14w400.copyWith(
                          color: AppStyle.primaryGrayWord,
                          fontFamily: FontFamily.roboto),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  FilterTabs(
                    filters: vm.filters,
                    selectedIndex: vm.selectedFilterIndex,
                    onSelect: (index) => vm.selectFilter(index),
                  ),

                  /// Filter buttons
                  const SizedBox(height: 48),

                  /// Refresh button (for web/desktop)
                  // if (!vm.isLoadingProducts && vm.errorMessage == null)
                  //   Align(
                  //     alignment: Alignment.centerRight,
                  //     child: IconButton(
                  //       onPressed: () => vm.refreshData(),
                  //       icon: Icon(
                  //         Icons.refresh,
                  //         color: AppStyle.primaryGreen_0_81_49,
                  //       ),
                  //       tooltip: 'Làm mới dữ liệu',
                  //     ),
                  //   ),
                  //
                  // const SizedBox(height: 16),

                  /// Product grid with animation
                  ///
                  Stack(
                    children: [
                      // Error message
                      if (vm.errorMessage != null)
                        Container(
                          height: 400,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  size: 64,
                                  color: Colors.grey[400],
                                ),
                                SizedBox(height: 16),
                                Text(
                                  vm.errorMessage!,
                                  style: KSTheme.of(context)
                                      .style
                                      .ts14w400
                                      .copyWith(
                                    color: Colors.grey[600],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () => vm.refreshData(),
                                  child: Text('Thử lại'),
                                ),
                              ],
                            ),
                          ),
                        )
                      // Loading state
                      else if (vm.isLoadingProducts)
                        Container(
                          height: 400,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                  color: AppStyle.primaryGreen_0_81_49,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Đang tải sản phẩm...',
                                  style: KSTheme.of(context)
                                      .style
                                      .ts14w400
                                      .copyWith(
                                    color: AppStyle.primaryGrayWord,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      // Product grid
                      else
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          transitionBuilder: (child, animation) {
                            // Chỉ animate child mới, child cũ biến mất luôn
                            return SlideTransition(
                              position: Tween<Offset>(
                                begin: vm.isNext
                                    ? const Offset(1, 0)
                                    : const Offset(-1, 0),
                                end: Offset.zero,
                              ).animate(animation),
                              child: child,
                            );
                          },
                          layoutBuilder: (currentChild, previousChildren) {
                            // Không giữ child cũ, chỉ show child mới
                            return currentChild ?? const SizedBox();
                          },
                          child: GridView.builder(
                            key: ValueKey<int>(vm.currentPage),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: gridItemCount,
                            gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              mainAxisExtent: 320,
                            ),
                            itemBuilder: (context, index) {
                              final product = displayProducts[index];
                              if (product == null) return const SizedBox();
                              return ProductCard(
                                  vm: vm,
                                  product: product, onTap: vm.listClick);
                            },
                          ),
                        ),

                      // Loading overlay
                      // if (vm.isLoading)
                      //   AnimatedSwitcher(
                      //     duration: const Duration(milliseconds: 300),
                      //     child: Container(height: 714,
                      //       child: IgnorePointer(
                      //         ignoring: !vm.isLoading, // không chặn tương tác khi không loading
                      //         child: ColoredBox(
                      //           color: AppStyle.whiteYellow,
                      //           child: Center(
                      //             child: LoadingLottie(),
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   )
                    ],
                  ),

                  /// Prev / Next
                  // if (vm.totalPages > 1)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: vm.currentPage > 0 ? vm.prevPage : null,
                        icon: const Icon(Icons.arrow_back),
                      ),
                      Text("${vm.currentPage + 1} / ${vm.totalPages}"),
                      IconButton(
                        onPressed: vm.currentPage < vm.totalPages - 1
                            ? vm.nextPage
                            : null,
                        icon: const Icon(Icons.arrow_forward),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 128,
              ),
            ],
          ),
        ),
      );
    });
  }
}

/// 🟤 Product Card widget
class ProductCard extends StatefulWidget {
  final Product product; // 👈 Thêm model Product
  final HomeMobileScreenVm vm;
  final void Function(Product, GlobalKey) onTap; // 👈 callback nhận Product

  const ProductCard({
    super.key,
    required this.product,
    required this.vm,
    required this.onTap,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _isHovered = false;
  final GlobalKey widgetKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Container(
        decoration: BoxDecoration(
          color:
              AppStyle.primaryGreen_0_81_49.withOpacity(0.1)
             ,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 📸 Hình sản phẩm
            SizedBox(height: 16,),
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Container(
                  key: widgetKey, // 👈 gắn GlobalKey để lấy RenderBox
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: AppStyle.padding_TB_16().copyWith(top: 8, bottom: 8),
                    child: Center(
                      child: Image.network(
                        widget.product.image,
                        fit: BoxFit.contain,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child; // ✅ Ảnh đã load xong
                          }
                          return const SizedBox(
                            // width: 40,
                            // height: 40,
                            child: Center(
                                child: LoadingLottie()
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) => const Icon(
                          Icons.broken_image,
                          size: 40,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // 🌍 Quốc gia
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "---",
                style: KSTheme.of(context).style.ts14w500.copyWith(
                  // fontFamily: FontFamily.roboto
                  // color: AppStyle.primaryGreen_0_81_49,
                ),
              ),
            ),

            // ☕ Tên sản phẩm
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                widget.vm.selectedLang == "vi" ?
                widget.product.name : widget.product.nameEnglish,
                maxLines: 1,
                style: KSTheme.of(context).style.ts16w700.copyWith(
                  color: AppStyle.primaryGreen_0_81_49,
                ),
              ),
            ),

            // 💲 Giá + Add khi hover
            Container(
              height: 90,
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      maxLines: 1,
                      "${S.current.from.capitalizeFirstLetter()} ${double.parse(widget.product.price.toString()).toCurrency()}",
                      style: KSTheme.of(context).style.ts14w500.copyWith(
                          color: AppStyle.primaryGrayWord,
                          fontFamily: FontFamily.roboto),
                    ),
                    // const Spacer(),
                    // if (_isHovered)
                      Row(
                        children: [
                          Spacer(),
                          IconButton(
                            onPressed: () {
                              widget.onTap(widget.product, widgetKey);
                              FocusScope.of(context).unfocus();
                            }, // 👈 truyền Product ra ngoài

                            icon: SvgPicture.asset(
                              Assets.svg.svgCart.keyName,
                              color: AppStyle.primaryGreen_0_81_49,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FilterTabs extends StatefulWidget {
  final List<String> filters;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const FilterTabs({
    super.key,
    required this.filters,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  State<FilterTabs> createState() => _FilterTabsState();
}

class _FilterTabsState extends State<FilterTabs> {
  final ScrollController _scrollController = ScrollController();

  /// 📌 Scroll tab được chọn ra giữa màn hình
  void _scrollToCenter(int index) {
    final screenWidth = MediaQuery.of(context).size.width;
    const itemWidth = 120.0; // chiều rộng mỗi tab (bạn chỉnh lại theo UI)

    final offset = (index * itemWidth) - (screenWidth / 2) + (itemWidth / 2);

    _scrollController.animateTo(
      offset.clamp(0, _scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void didUpdateWidget(covariant FilterTabs oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedIndex != oldWidget.selectedIndex) {
      _scrollToCenter(widget.selectedIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        // physics: const NeverScrollableScrollPhysics(),
        itemCount: widget.filters.length,
        itemBuilder: (context, index) {
          final isSelected = widget.selectedIndex == index;

          return Padding(
            padding: AppStyle.padding_LR_16().copyWith(left: 0),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: isSelected
                    ? AppStyle.primaryGreen_0_81_49
                    : Colors.transparent,
                foregroundColor:
                isSelected ? Colors.white : AppStyle.primaryGreen_0_81_49,
                side: BorderSide(
                  color: isSelected
                      ? AppStyle.primaryGreen_0_81_49
                      : Colors.grey.shade400,
                ),
              ),
              onPressed: () => widget.onSelect(index),
              child: Text(
                widget.filters[index],
              ),
            ),
          );
        },
      ),
    );
  }
}
