// import 'dart:async';
// import 'dart:ui';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'object_drawable.dart';
//
// class SvgDrawable extends ObjectDrawable {
//   final String assetName;
//   final Picture? _picture;
//   final Size? _svgSize;
//
//   SvgDrawable(this._picture, this._svgSize, {
//     required this.assetName,
//     required Offset position,
//     double rotation = 0,
//     double scale = 1,
//     bool locked = false,
//     bool hidden = false,
//   }) : super(
//     position: position,
//     rotationAngle: rotation,
//     scale: scale,
//     locked: locked,
//     hidden: hidden,
//   );
//
//   Future<PictureInfo> loadSvgPicture(BuildContext context, String asset) async {
//     final pictureProvider = SvgPicture.asset(asset).pictureProvider;
//     final PictureStream stream = pictureProvider.resolve(const PictureConfiguration());
//
//     final Completer<PictureInfo> completer = Completer();
//
//     late PictureStreamListener listener;
//     listener = PictureStreamListener((PictureInfo pictureInfo, bool synchronousCall) {
//       completer.complete(pictureInfo);
//       stream.removeListener(listener);
//     }, onError: (Object error, StackTrace? stackTrace) {
//       completer.completeError(error, stackTrace);
//       stream.removeListener(listener);
//     });
//
//     stream.addListener(listener);
//
//     return completer.future;
//   }
//
//   @override
//   void drawObject(Canvas canvas, Size size) {
//     if (_picture == null || _svgSize == null) {
//       // SVG not loaded yet, optionally draw placeholder or do nothing
//       return;
//     }
//
//     canvas.save();
//
//     // Move to the position
//     canvas.translate(position.dx, position.dy);
//
//     // Apply rotation
//     canvas.rotate(rotationAngle);
//
//     // Apply scale
//     canvas.scale(scale);
//
//     // To center the picture at position, translate by half the svg size negative
//     canvas.translate(-_svgSize!.width / 2, -_svgSize!.height / 2);
//
//     // Draw the SVG picture
//     canvas.drawPicture(_picture!);
//
//     canvas.restore();
//   }
//
//   @override
//   Size getSize({double minWidth = 0, double maxWidth = double.infinity}) {
//     return _svgSize ?? Size.zero;
//   }
//
//   @override
//   SvgDrawable copyWith({
//     Offset? position,
//     double? rotation,
//     double? scale,
//     bool? locked,
//     bool? hidden,
//     String? assetName,
//   }) {
//     return SvgDrawable(
//       assetName: assetName ?? this.assetName,
//       position: position ?? this.position,
//       rotation: rotation ?? this.rotationAngle,
//       scale: scale ?? this.scale,
//       locked: locked ?? this.locked,
//       hidden: hidden ?? this.hidden,
//     );
//   }
// }
