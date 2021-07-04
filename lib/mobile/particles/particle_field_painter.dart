import 'package:flutter/material.dart';
import 'package:timetracker_mobile/mobile/particles/sprite_sheet.dart';
import 'particle_field.dart';

// Renders a ParticleField.
class ParticleFieldPainter extends CustomPainter {
  ParticleField field;
  SpriteSheet spriteSheet = SpriteSheet(
    imageProvider: AssetImage("assets/images/sparkleparty_spritesheet.png"),
    length: 16, // number of frames in the sprite sheet.
    frameWidth: 64,
    frameHeight: 64,
  );

  // ParticleField is a ChangeNotifier, so we can use it as the repaint notifier.
  ParticleFieldPainter(this.field) : super(repaint: field);

  @override
  void paint(Canvas canvas, Size size) {
    if (spriteSheet.image == null) {
      return;
    } // image hasn't loaded

    Paint fill = new Paint();
    List<RSTransform> transforms = [];
    List<Rect> rects = [];
    List<Color> colors = [];
    int frameCount = spriteSheet.length;

    field.particles.forEach((o) {
      // Each particle has a transformation entry, which tells drawAtlas where to draw it.
      transforms.add(RSTransform.fromComponents(
          translateX: o.x,
          translateY: o.y,
          rotation: 0,
          scale: o.life,
          anchorX: 0,
          anchorY: 0));
      // And a rect entry, which describes the portion (frame) of the sprite sheet image to use as the source.
      rects.add(
          spriteSheet.getFrame((frameCount * o.life * 2 % frameCount).floor()));
      // And a color entry, which is composited with the frame via the blend mode.
      colors.add(o.color);
    });

    // Draw all of the particles based on the data entries.
    canvas.drawAtlas(
      spriteSheet.image,
      transforms,
      rects,
      colors,
      BlendMode.dstIn, // Use the sprite frame as an alpha mask for the color
      Rect.fromLTWH(0.0, 0.0, size.width, size.height),
      fill,
    );
  }

  @override
  bool shouldRepaint(_) => true;
}
