// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of map_plugin;

final GoogleMapsFlutterPlatform _googleMapsFlutterPlatform =
    GoogleMapsFlutterPlatform.instance;

class MapController {
  final int mapId;

  MapController._(
    CameraPosition initialCameraPosition,
    this._googleMapState, {
    @required this.mapId,
  }) : assert(_googleMapsFlutterPlatform != null) {
    _connectStreams(mapId);
  }

  static Future<MapController> init(
    int id,
    CameraPosition initialCameraPosition,
    _MyMapState googleMapState,
  ) async {
    assert(id != null);
    await _googleMapsFlutterPlatform.init(id);
    return MapController._(
      initialCameraPosition,
      googleMapState,
      mapId: id,
    );
  }

  final _MyMapState _googleMapState;

  void _connectStreams(int mapId) {
    if (_googleMapState.widget.onCameraMoveStarted != null) {
      _googleMapsFlutterPlatform
          .onCameraMoveStarted(mapId: mapId)
          .listen((_) => _googleMapState.widget.onCameraMoveStarted());
    }
    if (_googleMapState.widget.onCameraMove != null) {
      _googleMapsFlutterPlatform.onCameraMove(mapId: mapId).listen(
          (CameraMoveEvent e) => _googleMapState.widget.onCameraMove(e.value));
    }
    if (_googleMapState.widget.onCameraIdle != null) {
      _googleMapsFlutterPlatform
          .onCameraIdle(mapId: mapId)
          .listen((_) => _googleMapState.widget.onCameraIdle());
    }
    _googleMapsFlutterPlatform
        .onMarkerTap(mapId: mapId)
        .listen((MarkerTapEvent e) => _googleMapState.onMarkerTap(e.value));
    _googleMapsFlutterPlatform.onMarkerDragEnd(mapId: mapId).listen(
        (MarkerDragEndEvent e) =>
            _googleMapState.onMarkerDragEnd(e.value, e.position));
    _googleMapsFlutterPlatform.onInfoWindowTap(mapId: mapId).listen(
        (InfoWindowTapEvent e) => _googleMapState.onInfoWindowTap(e.value));
    _googleMapsFlutterPlatform
        .onPolylineTap(mapId: mapId)
        .listen((PolylineTapEvent e) => _googleMapState.onPolylineTap(e.value));
    _googleMapsFlutterPlatform
        .onPolygonTap(mapId: mapId)
        .listen((PolygonTapEvent e) => _googleMapState.onPolygonTap(e.value));
    _googleMapsFlutterPlatform
        .onCircleTap(mapId: mapId)
        .listen((CircleTapEvent e) => _googleMapState.onCircleTap(e.value));
    _googleMapsFlutterPlatform
        .onTap(mapId: mapId)
        .listen((MapTapEvent e) => _googleMapState.onTap(e.position));
    _googleMapsFlutterPlatform.onLongPress(mapId: mapId).listen(
        (MapLongPressEvent e) => _googleMapState.onLongPress(e.position));
  }

  Future<void> _updateMapOptions(Map<String, dynamic> optionsUpdate) {
    assert(optionsUpdate != null);
    return _googleMapsFlutterPlatform.updateMapOptions(optionsUpdate,
        mapId: mapId);
  }

  Future<void> _updateMarkers(MarkerUpdates markerUpdates) {
    assert(markerUpdates != null);
    return _googleMapsFlutterPlatform.updateMarkers(markerUpdates,
        mapId: mapId);
  }

  Future<void> _updatePolygons(PolygonUpdates polygonUpdates) {
    assert(polygonUpdates != null);
    return _googleMapsFlutterPlatform.updatePolygons(polygonUpdates,
        mapId: mapId);
  }

  Future<void> _updatePolylines(PolylineUpdates polylineUpdates) {
    assert(polylineUpdates != null);
    return _googleMapsFlutterPlatform.updatePolylines(polylineUpdates,
        mapId: mapId);
  }

  Future<void> _updateCircles(CircleUpdates circleUpdates) {
    assert(circleUpdates != null);
    return _googleMapsFlutterPlatform.updateCircles(circleUpdates,
        mapId: mapId);
  }

  Future<void> animateCamera(CameraUpdate cameraUpdate) {
    return _googleMapsFlutterPlatform.animateCamera(cameraUpdate, mapId: mapId);
  }

  Future<void> moveCamera(CameraUpdate cameraUpdate) {
    return _googleMapsFlutterPlatform.moveCamera(cameraUpdate, mapId: mapId);
  }

  Future<void> setMapStyle(String mapStyle) {
    return _googleMapsFlutterPlatform.setMapStyle(mapStyle, mapId: mapId);
  }

  Future<LatLngBounds> getVisibleRegion() {
    return _googleMapsFlutterPlatform.getVisibleRegion(mapId: mapId);
  }

  Future<ScreenCoordinate> getScreenCoordinate(LatLng latLng) {
    return _googleMapsFlutterPlatform.getScreenCoordinate(latLng, mapId: mapId);
  }

  Future<LatLng> getLatLng(ScreenCoordinate screenCoordinate) {
    return _googleMapsFlutterPlatform.getLatLng(screenCoordinate, mapId: mapId);
  }

  Future<void> showMarkerInfoWindow(MarkerId markerId) {
    assert(markerId != null);
    return _googleMapsFlutterPlatform.showMarkerInfoWindow(markerId,
        mapId: mapId);
  }

  Future<void> hideMarkerInfoWindow(MarkerId markerId) {
    assert(markerId != null);
    return _googleMapsFlutterPlatform.hideMarkerInfoWindow(markerId,
        mapId: mapId);
  }

  Future<bool> isMarkerInfoWindowShown(MarkerId markerId) {
    assert(markerId != null);
    return _googleMapsFlutterPlatform.isMarkerInfoWindowShown(markerId,
        mapId: mapId);
  }

  Future<double> getZoomLevel() {
    return _googleMapsFlutterPlatform.getZoomLevel(mapId: mapId);
  }

  Future<Uint8List> takeSnapshot() {
    return _googleMapsFlutterPlatform.takeSnapshot(mapId: mapId);
  }

  void dispose() {
    _googleMapsFlutterPlatform.dispose(mapId: mapId);
  }
}
