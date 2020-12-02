
library map_plugin;

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';


export 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart'
    show
    ArgumentCallbacks,
    ArgumentCallback,
    BitmapDescriptor,
    CameraPosition,
    CameraPositionCallback,
    CameraTargetBounds,
    CameraUpdate,
    Cap,
    Circle,
    CircleId,
    InfoWindow,
    JointType,
    LatLng,
    LatLngBounds,
    MapStyleException,
    MapType,
    Marker,
    MarkerId,
    MinMaxZoomPreference,
    PatternItem,
    Polygon,
    PolygonId,
    Polyline,
    PolylineId,
    ScreenCoordinate;
part 'src/controller.dart';
part 'src/mymap.dart';
