import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_restaurant/bloc/home/customise_food/customise_food_cubit.dart';
import 'package:flutter_restaurant/models/item/item.dart';
import 'package:flutter_restaurant/models/item/item_addon.dart';
import 'package:flutter_restaurant/models/item/item_addon_category.dart';
import 'package:flutter_restaurant/views/core/misc/constants.dart';
import 'package:flutter_restaurant/views/core/misc/utils.dart';
import 'package:flutter_restaurant/views/core/widgets/nullable_network_image.dart';
import 'package:kt_dart/kt.dart';

class CustomiseFoodBody extends StatelessWidget {
  const CustomiseFoodBody({
    super.key,
    required this.item,
  });

  final Item item;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Expanded(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 240,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(item.name),
                  background: NullableNetworkImage(
                    imageUrl: item.picture,
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(kBorderRadius),
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 8),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  childCount: item.addonCategories.length,
                  (context, index) {
                    final addonCategory = item.addonCategories[index];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Text(
                            addonCategory.name,
                            style: textTheme.titleMedium?.copyWith(
                              color: colorScheme.onBackground,
                            ),
                          ),
                        ),
                        BlocSelector<CustomiseFoodCubit, CustomiseFoodState,
                            KtList<ItemAddon>>(
                          selector: (state) => state.addonCategories
                              .getOrDefault(addonCategory.id, emptyList()),
                          builder: (context, selectedAddons) {
                            final addons = addonCategory.addons;

                            if (addons.isNotEmpty) {
                              return Column(
                                children: addonCategory.isMultipleChoice
                                    ? _buildCheckTiles(
                                        context: context,
                                        addonCategory: addonCategory,
                                        selectedAddons: selectedAddons,
                                      )
                                    : _buildRadioTiles(
                                        context: context,
                                        addonCategory: addonCategory,
                                        value: selectedAddons.firstOrNull() ??
                                            addons.first,
                                      ),
                              );
                            } else {
                              return const SizedBox();
                            }
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
              SliverToBoxAdapter(
                child: Card(
                  margin: const EdgeInsets.all(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'About this food',
                          style: textTheme.titleMedium?.copyWith(
                            color: colorScheme.onBackground,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item.description ?? 'No description',
                          textAlign: TextAlign.justify,
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _buildCheckTiles({
    required BuildContext context,
    required ItemAddonCategory addonCategory,
    required KtList<ItemAddon> selectedAddons,
  }) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final cubit = context.read<CustomiseFoodCubit>();

    return addonCategory.addons.map((addon) {
      return CheckboxListTile(
        title: Text(
          addon.name,
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onBackground,
          ),
        ),
        secondary: Text(
          addon.price == null ? '' : '+${formatCurrency(addon.price!)}',
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onBackground,
          ),
        ),
        controlAffinity: ListTileControlAffinity.leading,
        value: selectedAddons.contains(addon),
        onChanged: (value) => value!
            ? cubit.putAddon(addonCategory.id, addon)
            : cubit.removeAddon(
                addonCategory.id,
                addon,
              ),
      );
    }).toList();
  }

  List<Widget> _buildRadioTiles({
    required BuildContext context,
    required ItemAddonCategory addonCategory,
    required ItemAddon value,
  }) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return addonCategory.addons.map((addon) {
      return RadioListTile<ItemAddon>(
        title: Text(
          addon.name,
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onBackground,
          ),
        ),
        secondary: Text(
          addon.price == null ? '' : '+${formatCurrency(addon.price!)}',
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onBackground,
          ),
        ),
        value: value,
        groupValue: addon,
        onChanged: (value) {
          context
              .read<CustomiseFoodCubit>()
              .switchAddon(addonCategory.id, addon);
        },
      );
    }).toList();
  }
}
