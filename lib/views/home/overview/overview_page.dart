import 'package:auto_route/auto_route.dart';
import 'package:dartz/dartz.dart' hide State;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_restaurant/bloc/core/failure.dart';
import 'package:flutter_restaurant/bloc/home/overview/overview_cubit.dart';
import 'package:flutter_restaurant/bloc/preferences/preferences_cubit.dart';
import 'package:flutter_restaurant/injection.dart';
import 'package:flutter_restaurant/l10n/l10n.dart';
import 'package:flutter_restaurant/models/item.dart';
import 'package:flutter_restaurant/views/core/widgets/error_text.dart';
import 'package:flutter_restaurant/views/home/overview/widgets/nearby_store_tile_widget.dart';
import 'package:flutter_restaurant/views/home/overview/widgets/special_offer_tile_widget.dart';

class OverviewPage extends StatefulWidget implements AutoRouteWrapper {
  const OverviewPage({Key? key}) : super(key: key);

  @override
  Widget wrappedRoute(BuildContext context) {
    final prefCubit = context.read<PreferencesCubit>();
    return BlocProvider(
      create: (context) => getIt<HomeCubit>()
        ..initialise(
          position: prefCubit.state.position,
        ),
      child: BlocListener<HomeCubit, HomeState>(
        listenWhen: (previous, current) =>
            previous.selectedCategory != current.selectedCategory,
        listener: (context, state) {
          final position = prefCubit.state.position;
          if (position != null) {
            context.read<HomeCubit>().getNearbyStores(position: position);
          }
        },
        child: BlocListener<PreferencesCubit, PreferencesState>(
          listenWhen: (previous, current) =>
              previous.position != current.position,
          listener: (context, state) {
            context.read<HomeCubit>().initialise(position: state.position);
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
    final cubit = context.read<HomeCubit>();

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
        await context.read<HomeCubit>().determinePosition(
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
    final cubit = context.read<HomeCubit>();

    return Scaffold(
      body: BlocBuilder<PreferencesCubit, PreferencesState>(
        buildWhen: (previous, current) => previous.position != current.position,
        builder: (context, state) {
          return BlocSelector<HomeCubit, HomeState, bool>(
            selector: (state) => state.isLoading,
            builder: (context, isLoading) {
              return ListView(
                children: [
                  // const _HomeAppBar(),
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
                    Text(context.l10n.homeExploreNearby),
                    SizedBox(
                      height: 220,
                      child: BlocBuilder<HomeCubit, HomeState>(
                        buildWhen: (previous, current) =>
                            previous.failureOrNearbyStores !=
                            current.failureOrNearbyStores,
                        builder: (context, state) {
                          if (state.failureOrNearbyStores != null) {
                            return state.failureOrNearbyStores!.fold(
                              (l) => Text(l.message),
                              (nearbyStores) {
                                if (nearbyStores.isEmpty) {
                                  return Center(
                                    child: Text(context.l10n.homeNoNearbyStore),
                                  );
                                }
                                return ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  itemCount: nearbyStores.length,
                                  itemBuilder: (context, index) {
                                    final nearbyStore = nearbyStores[index];
                                    return NearbyStoreTile(
                                      nearbyStore: nearbyStore,
                                      onTap: () {},
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
                    const Divider(),
                    Text(context.l10n.homeSpecialOffers),
                    SizedBox(
                      height: 220,
                      child: BlocSelector<HomeCubit, HomeState,
                          Either<Failure, List<Item>>?>(
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
                                    position: state.position!);
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                separatorBuilder: (_, __) =>
                                    const SizedBox(width: 8),
                                itemCount: specialOffers.length,
                                itemBuilder: (context, index) {
                                  final popularItem = specialOffers[index];
                                  return SpecialOfferTile(
                                    item: popularItem,
                                    onTap: () {},
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _NoLocationErrorWidget extends StatelessWidget {
  const _NoLocationErrorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HomeCubit>();

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
          ],
        ),
      ),
    );
  }
}
