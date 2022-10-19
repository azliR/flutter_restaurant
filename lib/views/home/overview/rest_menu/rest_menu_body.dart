import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_restaurant/bloc/home/rest_menu/rest_menu_cubit.dart';
import 'package:flutter_restaurant/models/item/item_by_store.dart';
import 'package:flutter_restaurant/models/item/item_sub_category.dart';
import 'package:flutter_restaurant/models/store/store.dart';
import 'package:flutter_restaurant/views/core/widgets/error_text.dart';
import 'package:flutter_restaurant/views/home/overview/rest_menu/widgets/custom_sliver_appbar.dart';
import 'package:flutter_restaurant/views/home/overview/rest_menu/widgets/item_tile_widget.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class RestMenuBody extends StatefulWidget {
  const RestMenuBody({
    super.key,
    required this.store,
    this.scrollController,
  });

  final Store store;
  final ScrollController? scrollController;

  @override
  State<RestMenuBody> createState() => _RestMenuBodyState();
}

class _RestMenuBodyState extends State<RestMenuBody> {
  final _itemPagingController =
      PagingController<int, ItemByStore>(firstPageKey: 0);
  final _subCategoriesPagingController =
      PagingController<int, ItemSubCategory>(firstPageKey: 0);

  static const _itemPageLimit = 10;
  static const _subCategoriesPageLimit = 10;

  bool _isCategoryEmpty = false;

  @override
  void initState() {
    final cubit = context.read<RestMenuCubit>();
    _itemPagingController.addPageRequestListener((pageKey) async {
      await cubit.getItemsByStore(
        storeId: widget.store.id,
        pageKey: pageKey,
        pageLimit: _itemPageLimit,
        onCompleted: (items) {
          if (items.length < _itemPageLimit) {
            _itemPagingController.appendLastPage(items);
          } else {
            final nextPageKey = pageKey + items.length;
            _itemPagingController.appendPage(items, nextPageKey);
          }
        },
        onError: (message) {
          _itemPagingController.error = message;
        },
      );
    });
    _subCategoriesPagingController.addPageRequestListener((pageKey) async {
      await cubit.getSubCategories(
        storeId: widget.store.id,
        pageKey: pageKey,
        pageLimit: _subCategoriesPageLimit,
        languageCode: null,
        onCompleted: (subCategories) {
          if (subCategories.isEmpty && pageKey == 0) {
            setState(() {
              _isCategoryEmpty = true;
            });
          }
          if (subCategories.length < _subCategoriesPageLimit) {
            _subCategoriesPagingController.appendLastPage(subCategories);
          } else {
            final nextPageKey = pageKey + subCategories.length;
            _subCategoriesPagingController.appendPage(
              subCategories,
              nextPageKey,
            );
          }
        },
        onError: (message) {
          _subCategoriesPagingController.error = message;
        },
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final cubit = context.read<RestMenuCubit>();
    const profileRadius = 48.0;

    return BlocListener<RestMenuCubit, RestMenuState>(
      listenWhen: (previous, current) =>
          previous.itemSubCategory != current.itemSubCategory,
      listener: (context, state) {
        _itemPagingController.refresh();
      },
      child: Expanded(
        child: CustomScrollView(
          controller: widget.scrollController,
          slivers: [
            SliverPersistentHeader(
              delegate: CustomSliverAppBar(
                expandedHeight: 240,
                store: widget.store,
                profileRadius: profileRadius,
              ),
            ),
            if (!_isCategoryEmpty) ...[
              SliverPadding(
                padding:
                    const EdgeInsets.fromLTRB(16, profileRadius + 8, 16, 8),
                sliver: SliverToBoxAdapter(
                  child: SizedBox(
                    height: 36,
                    child: BlocSelector<RestMenuCubit, RestMenuState,
                        ItemSubCategory?>(
                      selector: (state) => state.itemSubCategory,
                      builder: (context, selectedSubCategory) {
                        return PagedListView<int, ItemSubCategory>.separated(
                          scrollDirection: Axis.horizontal,
                          pagingController: _subCategoriesPagingController,
                          builderDelegate: PagedChildBuilderDelegate(
                            firstPageErrorIndicatorBuilder: (context) {
                              return ErrorText(
                                message: _subCategoriesPagingController.error
                                    .toString(),
                                onRetry: () {
                                  _subCategoriesPagingController.refresh();
                                },
                              );
                            },
                            newPageProgressIndicatorBuilder: (context) {
                              return const SizedBox(
                                height: 36,
                                width: 36,
                                child: Padding(
                                  padding: EdgeInsets.all(4),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                              );
                            },
                            itemBuilder: (context, subCategory, index) {
                              return FilterChip(
                                label: Text(subCategory.name),
                                selected: subCategory == selectedSubCategory,
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                ),
                                onSelected: (value) => cubit.selectCategory(
                                  !value ? null : subCategory,
                                ),
                              );
                            },
                          ),
                          separatorBuilder: (_, __) => const SizedBox(width: 8),
                        );
                      },
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: BlocSelector<RestMenuCubit, RestMenuState,
                    ItemSubCategory?>(
                  selector: (state) => state.itemSubCategory,
                  builder: (context, selectedSubCategory) {
                    if (selectedSubCategory == null) {
                      return const SizedBox();
                    }
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: Text(
                        selectedSubCategory.name,
                        style: textTheme.titleLarge?.copyWith(
                          color: colorScheme.onBackground,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ] else
              const SliverPadding(
                padding: EdgeInsets.only(top: profileRadius),
              ),
            PagedSliverList<int, ItemByStore>(
              pagingController: _itemPagingController,
              builderDelegate: PagedChildBuilderDelegate(
                firstPageErrorIndicatorBuilder: (context) {
                  return ErrorText(
                    message: _itemPagingController.error.toString(),
                    onRetry: () {
                      _itemPagingController.refresh();
                    },
                  );
                },
                itemBuilder: (context, item, index) {
                  return ItemTile(
                    itemByStore: item,
                    storeName: widget.store.name,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
