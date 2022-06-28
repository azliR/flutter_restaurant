import 'package:auto_route/auto_route.dart';
import 'package:dartz/dartz.dart' hide State;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_restaurant/bloc/core/failure.dart';
import 'package:flutter_restaurant/bloc/home/overview/overview_cubit.dart';
import 'package:flutter_restaurant/bloc/preferences/preferences_cubit.dart';
import 'package:flutter_restaurant/injection.dart';
import 'package:flutter_restaurant/l10n/l10n.dart';
import 'package:flutter_restaurant/models/home/nearby_store.dart';
import 'package:flutter_restaurant/models/home/special_offer.dart';
import 'package:flutter_restaurant/views/core/app_router.dart';
import 'package:flutter_restaurant/views/core/misc/constants.dart';
import 'package:flutter_restaurant/views/core/widgets/error_text.dart';
import 'package:flutter_restaurant/views/home/overview/widgets/nearby_store_tile_widget.dart';
import 'package:flutter_restaurant/views/home/overview/widgets/special_offer_tile_widget.dart';

class OverviewPage extends StatefulWidget implements AutoRouteWrapper {
  const OverviewPage({Key? key}) : super(key: key);

  @override
  Widget wrappedRoute(BuildContext context) {
    final prefCubit = context.read<PreferencesCubit>();
    return BlocProvider(
      create: (context) => getIt<OverviewCubit>()
        ..initialise(
          position: prefCubit.state.position,
        ),
      child: BlocListener<OverviewCubit, OverviewState>(
        listenWhen: (previous, current) =>
            previous.selectedCategory != current.selectedCategory,
        listener: (context, state) {
          final position = prefCubit.state.position;
          if (position != null) {
            context.read<OverviewCubit>().getNearbyStores(position: position);
          }
        },
        child: BlocListener<PreferencesCubit, PreferencesState>(
          listenWhen: (previous, current) =>
              previous.position != current.position,
          listener: (context, state) {
            context.read<OverviewCubit>().initialise(position: state.position);
          },
          child: this,
        ),
      ),
    );
  }

  @override
  State<OverviewPage> createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  bool isDialogOpen = false;

  Future<void> _showLocationDialog() {
    final cubit = context.read<OverviewCubit>();

    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      builder: (_) {
        return ListView(
          padding: const EdgeInsets.fromLTRB(24, 36, 24, 16),
          children: [
            // Center(
            //   child: Image.asset(
            //     kLocationAccessImagePng,
            //     width: 192,
            //   ),
            // ),
            const SizedBox(height: 24),
            Text(
              context.l10n.homeLocationAccessTitle,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .subtitle1
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              context.l10n.homeLocationAccessSubtitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.caption,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                cubit.determinePosition(
                  onCompleted: (position) {
                    context.read<PreferencesCubit>().setLocation(position);
                  },
                );
                context.router.pop();
              },
              child: Text(context.l10n.homeLocationAccessAllow),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                context.router.pop();
              },
              child: Text(context.l10n.homeLocationAccessDeny),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    final prefCubit = context.read<PreferencesCubit>();
    isDialogOpen = prefCubit.state.isFirstLaunch;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (prefCubit.state.isFirstLaunch) {
        await _showLocationDialog();
        setState(() => isDialogOpen = false);
        prefCubit.setFirstLaunch();
      } else {
        await context.read<OverviewCubit>().determinePosition(
          onCompleted: (position) {
            prefCubit.setLocation(position);
          },
        );
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OverviewCubit>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant'),
        actions: [
          IconButton(
            padding: const EdgeInsets.symmetric(vertical: 16),
            onPressed: () {
              context.read<PreferencesCubit>().setThemeMode(
                    ThemeMode.values[(context
                                .read<PreferencesCubit>()
                                .state
                                .themeMode
                                .index +
                            1) %
                        ThemeMode.values.length],
                  );
            },
            icon: BlocSelector<PreferencesCubit, PreferencesState, ThemeMode>(
              selector: (state) => state.themeMode,
              builder: (context, themeMode) {
                return Icon(
                  () {
                    switch (themeMode) {
                      case ThemeMode.system:
                        return Icons.smartphone;
                      case ThemeMode.light:
                        return Icons.light_mode_rounded;
                      case ThemeMode.dark:
                        return Icons.dark_mode_rounded;
                    }
                  }(),
                );
              },
            ),
          ),
        ],
      ),
      body: BlocBuilder<PreferencesCubit, PreferencesState>(
        buildWhen: (previous, current) => previous.position != current.position,
        builder: (context, state) {
          return BlocSelector<OverviewCubit, OverviewState, bool>(
            selector: (state) => state.isLoading,
            builder: (context, isLoading) {
              return ListView(
                children: [
                  const SizedBox(height: 4),
                  if (isLoading || isDialogOpen)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else if (state.position == null)
                    const _NoLocationErrorWidget()
                  else ...[
                    _HomeTitle(
                      title: context.l10n.homeNearbyTitle,
                      subtitle: context.l10n.homeNearbySubtitle,
                    ),
                    SizedBox(
                      height: 220,
                      child: BlocSelector<OverviewCubit, OverviewState,
                          Either<Failure, List<NearbyStore>>?>(
                        selector: (state) => state.failureOrNearbyStores,
                        builder: (context, failureOrNearbyStores) {
                          if (failureOrNearbyStores != null) {
                            return failureOrNearbyStores.fold(
                              (f) => ErrorText(
                                message: f.message,
                                error: f.error,
                                stackTrace: f.stackTrace,
                                onRetry: () {
                                  cubit.getNearbyStores(
                                    position: state.position!,
                                  );
                                },
                              ),
                              (nearbyStores) {
                                if (nearbyStores.isEmpty) {
                                  return Center(
                                    child: Text(context.l10n.homeNoNearbyStore),
                                  );
                                }
                                return ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: kHorizontalListPadding,
                                  ),
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(width: 8),
                                  itemCount: nearbyStores.length,
                                  itemBuilder: (context, index) {
                                    final nearbyStore = nearbyStores[index];
                                    return NearbyStoreTile(
                                      nearbyStore: nearbyStore,
                                      onTap: () => context.router.push(
                                        RestMenuRoute(storeId: nearbyStore.id),
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    _HomeTitle(
                      title: context.l10n.homeSpecialOffersTitle,
                      subtitle: context.l10n.homeSpecialOffersSubtitle,
                    ),
                    SizedBox(
                      height: 240,
                      child: BlocSelector<OverviewCubit, OverviewState,
                          Either<Failure, List<SpecialOffer>>?>(
                        selector: (state) => state.failureOrSpecialOffers,
                        builder: (context, failureOrSpecialOffers) {
                          if (failureOrSpecialOffers == null) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          return failureOrSpecialOffers.fold(
                            (f) => ErrorText(
                              message: f.message,
                              error: f.error,
                              stackTrace: f.stackTrace,
                              onRetry: () {
                                cubit.getSpecialOffers(
                                  position: state.position!,
                                );
                              },
                            ),
                            (specialOffers) {
                              if (specialOffers.isEmpty) {
                                return const Center(
                                  // TODO: translate
                                  child: Text('No special offers'),
                                );
                              }
                              return ListView.separated(
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: kHorizontalListPadding,
                                ),
                                separatorBuilder: (_, __) =>
                                    const SizedBox(width: 8),
                                itemCount: specialOffers.length,
                                itemBuilder: (context, index) {
                                  final specialOffer = specialOffers[index];
                                  return SpecialOfferTile(
                                    specialOffer: specialOffer,
                                    onTap: () {
                                      context.router.pushAll([
                                        RestMenuRoute(
                                          storeId: specialOffer.storeId,
                                        ),
                                        CustomiseFoodRoute(
                                          itemId: specialOffer.id,
                                        ),
                                      ]);
                                    },
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                  const SizedBox(height: 36),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _HomeTitle extends StatelessWidget {
  const _HomeTitle({
    Key? key,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: kHorizontalListPadding,
        vertical: 8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
          Text(
            subtitle,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class _NoLocationErrorWidget extends StatelessWidget {
  const _NoLocationErrorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OverviewCubit>();
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 36,
          horizontal: 24,
        ),
        child: Column(
          children: [
            Text(
              context.l10n.homeLocationAccessTitle,
              textAlign: TextAlign.center,
              style: textTheme.subtitle1?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              context.l10n.homeLocationAccessSubtitle,
              textAlign: TextAlign.center,
              style: textTheme.caption,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                cubit.determinePosition(
                  onCompleted: (position) {
                    context.read<PreferencesCubit>().setLocation(position);
                  },
                );
                context.router.pop();
              },
              child: Text(context.l10n.homeLocationAccessAllow),
            ),
          ],
        ),
      ),
    );
  }
}
