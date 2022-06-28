import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_restaurant/bloc/home/map/map_cubit.dart';
import 'package:flutter_restaurant/bloc/preferences/preferences_cubit.dart';
import 'package:flutter_restaurant/injection.dart';
import 'package:flutter_restaurant/views/core/app_router.dart';
import 'package:flutter_restaurant/views/core/misc/asset_images.dart';
import 'package:flutter_restaurant/views/core/widgets/nullable_network_image.dart';
import 'package:flutter_restaurant/views/home/map/widgets/map_card_widget.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

class MapPage extends StatefulWidget with AutoRouteWrapper {
  const MapPage({Key? key}) : super(key: key);

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<MapCubit>(),
      child: this,
    );
  }

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late PageController _pageViewController;
  late MapTileLayerController _mapController;

  late MapZoomPanBehavior _zoomPanBehavior;

  int _currentSelectedIndex = 0;
  late int _previousSelectedIndex;
  late int _tappedMarkerIndex;

  late double _cardHeight;

  late bool _canUpdateFocalLatLng;
  late bool _canUpdateZoomLevel;
  late bool _isDesktop;

  @override
  void initState() {
    super.initState();
    _canUpdateFocalLatLng = true;
    _canUpdateZoomLevel = true;
    _mapController = MapTileLayerController();

    final cubit = context.read<MapCubit>();
    final prefCubit = context.read<PreferencesCubit>();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await cubit.determinePosition(
        onCompleted: (position) {
          prefCubit.setLocation(position);
          cubit.getNearbyStores(
            lat: position.latitude,
            lng: position.longitude,
          );
        },
      );
    });

    _zoomPanBehavior = MapZoomPanBehavior(
      minZoomLevel: 4,
      maxZoomLevel: 18,
      zoomLevel: 16,
      focalLatLng: MapLatLng(
        prefCubit.state.position?.latitude ?? 0,
        prefCubit.state.position?.longitude ?? 0,
      ),
      enableDoubleTapZooming: true,
    );
  }

  @override
  void dispose() {
    _pageViewController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final cubit = context.read<MapCubit>();

    _isDesktop = themeData.platform == TargetPlatform.macOS ||
        themeData.platform == TargetPlatform.windows ||
        themeData.platform == TargetPlatform.linux;
    if (_canUpdateZoomLevel) {
      _zoomPanBehavior.zoomLevel = _isDesktop ? 5 : 4;
      _canUpdateZoomLevel = false;
    }

    _pageViewController = PageController(
      initialPage: _currentSelectedIndex,
      viewportFraction:
          (MediaQuery.of(context).orientation == Orientation.landscape)
              ? (_isDesktop ? 0.5 : 0.7)
              : 0.8,
    );
    return BlocListener<MapCubit, MapState>(
      listener: (context, state) {
        _mapController.clearMarkers();
        for (var i = 0; i < state.stores.length; i++) {
          _mapController.insertMarker(i);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Map'),
        ),
        body: Stack(
          children: <Widget>[
            Positioned.fill(
              child: Image.asset(
                kMapsGridPng,
                repeat: ImageRepeat.repeat,
              ),
            ),
            SfMaps(
              layers: <MapLayer>[
                MapTileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  zoomPanBehavior: _zoomPanBehavior,
                  initialZoomLevel: 15,
                  controller: _mapController,
                  initialMarkersCount: cubit.state.stores.length,
                  tooltipSettings: const MapTooltipSettings(
                    color: Colors.transparent,
                  ),
                  markerTooltipBuilder: (context, index) {
                    final nearbyStore = cubit.state.stores[index];
                    if (_isDesktop) {
                      return ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                              width: 150,
                              height: 80,
                              color: Colors.grey,
                              child: NullableNetworkImage(
                                imageUrl: nearbyStore.image ?? '',
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(
                                left: 10.0,
                                top: 5.0,
                                bottom: 5.0,
                              ),
                              width: 150,
                              color: Colors.white,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    nearbyStore.name,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: Text(
                                      '${nearbyStore.state}, ${nearbyStore.country}',
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.black,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return const SizedBox();
                  },
                  markerBuilder: (BuildContext context, int index) {
                    final nearbyStore = cubit.state.stores[index];
                    final double markerSize =
                        _currentSelectedIndex == index ? 40 : 25;

                    return MapMarker(
                      latitude: nearbyStore.latitude,
                      longitude: nearbyStore.longitude,
                      alignment: Alignment.bottomCenter,
                      child: GestureDetector(
                        onTap: () {
                          if (_currentSelectedIndex != index) {
                            _canUpdateFocalLatLng = false;
                            _tappedMarkerIndex = index;
                            _pageViewController.animateToPage(
                              index,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          height: markerSize,
                          width: markerSize,
                          child: FittedBox(
                            child: Icon(
                              Icons.location_on,
                              color: _currentSelectedIndex == index
                                  ? Colors.blue
                                  : Colors.red,
                              size: markerSize,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            MapCard(
              selectedIndex: _currentSelectedIndex,
              pageController: _pageViewController,
              onPageChanged: _handlePageChange,
              onButtonPressed: () {
                context.router.push(
                  RestMenuRoute(
                    storeId: cubit.state.stores[_currentSelectedIndex].id,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _handlePageChange(int index) {
    if (!_canUpdateFocalLatLng) {
      if (_tappedMarkerIndex == index) {
        _updateSelectedCard(index);
      }
    } else if (_canUpdateFocalLatLng) {
      _updateSelectedCard(index);
    }
  }

  void _updateSelectedCard(int index) {
    final cubit = context.read<MapCubit>();

    setState(() {
      _previousSelectedIndex = _currentSelectedIndex;
      _currentSelectedIndex = index;
    });

    if (_canUpdateFocalLatLng) {
      _zoomPanBehavior.focalLatLng = MapLatLng(
        cubit.state.stores[index].latitude,
        cubit.state.stores[index].longitude,
      );
    }

    _mapController
        .updateMarkers(<int>[_currentSelectedIndex, _previousSelectedIndex]);
    _canUpdateFocalLatLng = true;
  }
}
