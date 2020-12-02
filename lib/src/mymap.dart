

part of map_plugin;


typedef void MapCreatedCallback(MapController controller);


int _webOnlyMapId = 0;

class MyMap extends StatefulWidget {

  const MyMap({
    Key key,
    @required this.initialCameraPosition,
    this.onMapCreated,
    this.gestureRecognizers,
    this.compassEnabled = true,
    this.mapToolbarEnabled = true,
    this.cameraTargetBounds = CameraTargetBounds.unbounded,
    this.mapType = MapType.normal,
    this.minMaxZoomPreference = MinMaxZoomPreference.unbounded,
    this.rotateGesturesEnabled = true,
    this.scrollGesturesEnabled = true,
    this.zoomControlsEnabled = true,
    this.zoomGesturesEnabled = true,
    this.liteModeEnabled = false,
    this.tiltGesturesEnabled = true,
    this.myLocationEnabled = false,
    this.myLocationButtonEnabled = true,


    this.padding = const EdgeInsets.all(0),
    this.indoorViewEnabled = false,
    this.trafficEnabled = false,
    this.buildingsEnabled = true,
    this.markers,
    this.polygons,
    this.polylines,
    this.circles,
    this.onCameraMoveStarted,
    this.onCameraMove,
    this.onCameraIdle,
    this.onTap,
    this.onLongPress,
  })  : assert(initialCameraPosition != null),
        super(key: key);

  final MapCreatedCallback onMapCreated;


  final CameraPosition initialCameraPosition;


  final bool compassEnabled;


  final bool mapToolbarEnabled;

  final CameraTargetBounds cameraTargetBounds;


  final MapType mapType;


  final MinMaxZoomPreference minMaxZoomPreference;


  final bool rotateGesturesEnabled;

  final bool scrollGesturesEnabled;

  final bool zoomControlsEnabled;


  final bool zoomGesturesEnabled;


  final bool liteModeEnabled;


  final bool tiltGesturesEnabled;


  final EdgeInsets padding;


  final Set<Marker> markers;


  final Set<Polygon> polygons;


  final Set<Polyline> polylines;


  final Set<Circle> circles;

  final VoidCallback onCameraMoveStarted;


  final CameraPositionCallback onCameraMove;

  final VoidCallback onCameraIdle;


  final ArgumentCallback<LatLng> onTap;


  final ArgumentCallback<LatLng> onLongPress;

  final bool myLocationEnabled;

  final bool myLocationButtonEnabled;


  final bool indoorViewEnabled;

  final bool trafficEnabled;


  final bool buildingsEnabled;


  final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers;

  @override
  State createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  final _webOnlyMapCreationId = _webOnlyMapId++;

  final Completer<MapController> _controller =
      Completer<MapController>();

  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  Map<PolygonId, Polygon> _polygons = <PolygonId, Polygon>{};
  Map<PolylineId, Polyline> _polylines = <PolylineId, Polyline>{};
  Map<CircleId, Circle> _circles = <CircleId, Circle>{};
  _MapOptions _googleMapOptions;

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> creationParams = <String, dynamic>{
      'initialCameraPosition': widget.initialCameraPosition?.toMap(),
      'options': _googleMapOptions.toMap(),
      'markersToAdd': serializeMarkerSet(widget.markers),
      'polygonsToAdd': serializePolygonSet(widget.polygons),
      'polylinesToAdd': serializePolylineSet(widget.polylines),
      'circlesToAdd': serializeCircleSet(widget.circles),
      '_webOnlyMapCreationId': _webOnlyMapCreationId,
    };

    return _googleMapsFlutterPlatform.buildView(
      creationParams,
      widget.gestureRecognizers,
      onPlatformViewCreated,
    );
  }

  @override
  void initState() {
    super.initState();
    _googleMapOptions = _MapOptions.fromWidget(widget);
    _markers = keyByMarkerId(widget.markers);
    _polygons = keyByPolygonId(widget.polygons);
    _polylines = keyByPolylineId(widget.polylines);
    _circles = keyByCircleId(widget.circles);
  }

  @override
  void dispose() async {
    super.dispose();
    MapController controller = await _controller.future;
    controller.dispose();
  }

  @override
  void didUpdateWidget(MyMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateOptions();
    _updateMarkers();
    _updatePolygons();
    _updatePolylines();
    _updateCircles();
  }

  void _updateOptions() async {
    final _MapOptions newOptions = _MapOptions.fromWidget(widget);
    final Map<String, dynamic> updates =
        _googleMapOptions.updatesMap(newOptions);
    if (updates.isEmpty) {
      return;
    }
    final MapController controller = await _controller.future;
    // ignore: unawaited_futures
    controller._updateMapOptions(updates);
    _googleMapOptions = newOptions;
  }

  void _updateMarkers() async {
    final MapController controller = await _controller.future;
    // ignore: unawaited_futures
    controller._updateMarkers(
        MarkerUpdates.from(_markers.values.toSet(), widget.markers));
    _markers = keyByMarkerId(widget.markers);
  }

  void _updatePolygons() async {
    final MapController controller = await _controller.future;
    // ignore: unawaited_futures
    controller._updatePolygons(
        PolygonUpdates.from(_polygons.values.toSet(), widget.polygons));
    _polygons = keyByPolygonId(widget.polygons);
  }

  void _updatePolylines() async {
    final MapController controller = await _controller.future;
    // ignore: unawaited_futures
    controller._updatePolylines(
        PolylineUpdates.from(_polylines.values.toSet(), widget.polylines));
    _polylines = keyByPolylineId(widget.polylines);
  }

  void _updateCircles() async {
    final MapController controller = await _controller.future;
    // ignore: unawaited_futures
    controller._updateCircles(
        CircleUpdates.from(_circles.values.toSet(), widget.circles));
    _circles = keyByCircleId(widget.circles);
  }

  Future<void> onPlatformViewCreated(int id) async {
    final MapController controller = await MapController.init(
      id,
      widget.initialCameraPosition,
      this,
    );
    _controller.complete(controller);
    if (widget.onMapCreated != null) {
      widget.onMapCreated(controller);
    }
  }

  void onMarkerTap(MarkerId markerId) {
    assert(markerId != null);
    if (_markers[markerId]?.onTap != null) {
      _markers[markerId].onTap();
    }
  }

  void onMarkerDragEnd(MarkerId markerId, LatLng position) {
    assert(markerId != null);
    if (_markers[markerId]?.onDragEnd != null) {
      _markers[markerId].onDragEnd(position);
    }
  }

  void onPolygonTap(PolygonId polygonId) {
    assert(polygonId != null);
    _polygons[polygonId].onTap();
  }

  void onPolylineTap(PolylineId polylineId) {
    assert(polylineId != null);
    if (_polylines[polylineId]?.onTap != null) {
      _polylines[polylineId].onTap();
    }
  }

  void onCircleTap(CircleId circleId) {
    assert(circleId != null);
    _circles[circleId].onTap();
  }

  void onInfoWindowTap(MarkerId markerId) {
    assert(markerId != null);
    if (_markers[markerId]?.infoWindow?.onTap != null) {
      _markers[markerId].infoWindow.onTap();
    }
  }

  void onTap(LatLng position) {
    assert(position != null);
    if (widget.onTap != null) {
      widget.onTap(position);
    }
  }

  void onLongPress(LatLng position) {
    assert(position != null);
    if (widget.onLongPress != null) {
      widget.onLongPress(position);
    }
  }
}


class _MapOptions {
  _MapOptions({
    this.compassEnabled,
    this.mapToolbarEnabled,
    this.cameraTargetBounds,
    this.mapType,
    this.minMaxZoomPreference,
    this.rotateGesturesEnabled,
    this.scrollGesturesEnabled,
    this.tiltGesturesEnabled,
    this.trackCameraPosition,
    this.zoomControlsEnabled,
    this.zoomGesturesEnabled,
    this.liteModeEnabled,
    this.myLocationEnabled,
    this.myLocationButtonEnabled,
    this.padding,
    this.indoorViewEnabled,
    this.trafficEnabled,
    this.buildingsEnabled,
  }) {
    assert(liteModeEnabled == null ||
        !liteModeEnabled ||
        (liteModeEnabled && Platform.isAndroid));
  }

  static _MapOptions fromWidget(MyMap map) {
    return _MapOptions(
      compassEnabled: map.compassEnabled,
      mapToolbarEnabled: map.mapToolbarEnabled,
      cameraTargetBounds: map.cameraTargetBounds,
      mapType: map.mapType,
      minMaxZoomPreference: map.minMaxZoomPreference,
      rotateGesturesEnabled: map.rotateGesturesEnabled,
      scrollGesturesEnabled: map.scrollGesturesEnabled,
      tiltGesturesEnabled: map.tiltGesturesEnabled,
      trackCameraPosition: map.onCameraMove != null,
      zoomControlsEnabled: map.zoomControlsEnabled,
      zoomGesturesEnabled: map.zoomGesturesEnabled,
      liteModeEnabled: map.liteModeEnabled,
      myLocationEnabled: map.myLocationEnabled,
      myLocationButtonEnabled: map.myLocationButtonEnabled,
      padding: map.padding,
      indoorViewEnabled: map.indoorViewEnabled,
      trafficEnabled: map.trafficEnabled,
      buildingsEnabled: map.buildingsEnabled,
    );
  }

  final bool compassEnabled;

  final bool mapToolbarEnabled;

  final CameraTargetBounds cameraTargetBounds;

  final MapType mapType;

  final MinMaxZoomPreference minMaxZoomPreference;

  final bool rotateGesturesEnabled;

  final bool scrollGesturesEnabled;

  final bool tiltGesturesEnabled;

  final bool trackCameraPosition;

  final bool zoomControlsEnabled;

  final bool zoomGesturesEnabled;

  final bool liteModeEnabled;

  final bool myLocationEnabled;

  final bool myLocationButtonEnabled;

  final EdgeInsets padding;

  final bool indoorViewEnabled;

  final bool trafficEnabled;

  final bool buildingsEnabled;

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> optionsMap = <String, dynamic>{};

    void addIfNonNull(String fieldName, dynamic value) {
      if (value != null) {
        optionsMap[fieldName] = value;
      }
    }

    addIfNonNull('compassEnabled', compassEnabled);
    addIfNonNull('mapToolbarEnabled', mapToolbarEnabled);
    addIfNonNull('cameraTargetBounds', cameraTargetBounds?.toJson());
    addIfNonNull('mapType', mapType?.index);
    addIfNonNull('minMaxZoomPreference', minMaxZoomPreference?.toJson());
    addIfNonNull('rotateGesturesEnabled', rotateGesturesEnabled);
    addIfNonNull('scrollGesturesEnabled', scrollGesturesEnabled);
    addIfNonNull('tiltGesturesEnabled', tiltGesturesEnabled);
    addIfNonNull('zoomControlsEnabled', zoomControlsEnabled);
    addIfNonNull('zoomGesturesEnabled', zoomGesturesEnabled);
    addIfNonNull('liteModeEnabled', liteModeEnabled);
    addIfNonNull('trackCameraPosition', trackCameraPosition);
    addIfNonNull('myLocationEnabled', myLocationEnabled);
    addIfNonNull('myLocationButtonEnabled', myLocationButtonEnabled);
    addIfNonNull('padding', <double>[
      padding?.top,
      padding?.left,
      padding?.bottom,
      padding?.right,
    ]);
    addIfNonNull('indoorEnabled', indoorViewEnabled);
    addIfNonNull('trafficEnabled', trafficEnabled);
    addIfNonNull('buildingsEnabled', buildingsEnabled);
    return optionsMap;
  }

  Map<String, dynamic> updatesMap(_MapOptions newOptions) {
    final Map<String, dynamic> prevOptionsMap = toMap();

    return newOptions.toMap()
      ..removeWhere(
          (String key, dynamic value) => prevOptionsMap[key] == value);
  }
}
