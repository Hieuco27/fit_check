import 'package:flutter/material.dart';

/// CustomPainter vẽ khung lưới hình người mờ (Human Silhouette Overlay).
/// Dùng cho chế độ "Chụp mẫu người" — hướng dẫn người dùng đứng vào khung.
/// shouldRepaint = false vì overlay hoàn toàn tĩnh → không repaint không cần thiết.
class HumanSilhouetteOverlay extends StatelessWidget {
  const HumanSilhouetteOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        painter: _SilhouettePainter(),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _SilhouettePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    final cx = size.width * 0.5;
    final topY = size.height * 0.07;

    // ── Đầu (vòng tròn) ──────────────────────────────────────────────────────
    final headRadius = size.width * 0.09;
    final headCenterY = topY + headRadius;
    canvas.drawCircle(Offset(cx, headCenterY), headRadius, paint);

    // ── Cổ ───────────────────────────────────────────────────────────────────
    final neckWidth = size.width * 0.05;
    final neckTop = headCenterY + headRadius;
    final neckBottom = neckTop + size.height * 0.04;
    canvas.drawLine(Offset(cx - neckWidth, neckTop), Offset(cx - neckWidth, neckBottom), paint);
    canvas.drawLine(Offset(cx + neckWidth, neckTop), Offset(cx + neckWidth, neckBottom), paint);

    // ── Vai → eo (thân trên) ──────────────────────────────────────────────────
    final shoulderY = neckBottom;
    final shoulderHalfW = size.width * 0.22;
    final waistY = shoulderY + size.height * 0.22;
    final waistHalfW = size.width * 0.14;

    // Đường thân bên trái (vai → eo)
    canvas.drawLine(Offset(cx - shoulderHalfW, shoulderY), Offset(cx - waistHalfW, waistY), paint);
    // Đường thân bên phải
    canvas.drawLine(Offset(cx + shoulderHalfW, shoulderY), Offset(cx + waistHalfW, waistY), paint);
    // Đường vai ngang
    canvas.drawLine(Offset(cx - shoulderHalfW, shoulderY), Offset(cx + shoulderHalfW, shoulderY), paint);

    // ── Cánh tay trái ────────────────────────────────────────────────────────
    final armTopLeft = Offset(cx - shoulderHalfW, shoulderY);
    final elbowLeft = Offset(cx - shoulderHalfW - size.width * 0.1, shoulderY + size.height * 0.15);
    final wristLeft = Offset(cx - shoulderHalfW - size.width * 0.06, shoulderY + size.height * 0.28);
    canvas.drawLine(armTopLeft, elbowLeft, paint);
    canvas.drawLine(elbowLeft, wristLeft, paint);

    // ── Cánh tay phải ────────────────────────────────────────────────────────
    final armTopRight = Offset(cx + shoulderHalfW, shoulderY);
    final elbowRight = Offset(cx + shoulderHalfW + size.width * 0.1, shoulderY + size.height * 0.15);
    final wristRight = Offset(cx + shoulderHalfW + size.width * 0.06, shoulderY + size.height * 0.28);
    canvas.drawLine(armTopRight, elbowRight, paint);
    canvas.drawLine(elbowRight, wristRight, paint);

    // ── Eo → hông (thân dưới) ────────────────────────────────────────────────
    final hipY = waistY + size.height * 0.08;
    final hipHalfW = size.width * 0.18;
    canvas.drawLine(Offset(cx - waistHalfW, waistY), Offset(cx - hipHalfW, hipY), paint);
    canvas.drawLine(Offset(cx + waistHalfW, waistY), Offset(cx + hipHalfW, hipY), paint);
    canvas.drawLine(Offset(cx - hipHalfW, hipY), Offset(cx + hipHalfW, hipY), paint);

    // ── Chân trái ────────────────────────────────────────────────────────────
    final kneeLeftY = hipY + size.height * 0.17;
    final ankleLeftY = kneeLeftY + size.height * 0.17;
    canvas.drawLine(Offset(cx - hipHalfW * 0.7, hipY), Offset(cx - hipHalfW * 0.5, kneeLeftY), paint);
    canvas.drawLine(Offset(cx - hipHalfW * 0.5, kneeLeftY), Offset(cx - hipHalfW * 0.35, ankleLeftY), paint);

    // ── Chân phải ────────────────────────────────────────────────────────────
    canvas.drawLine(Offset(cx + hipHalfW * 0.7, hipY), Offset(cx + hipHalfW * 0.5, kneeLeftY), paint);
    canvas.drawLine(Offset(cx + hipHalfW * 0.5, kneeLeftY), Offset(cx + hipHalfW * 0.35, ankleLeftY), paint);

    // ── 4 góc guide (như camera frame) ──────────────────────────────────────
    _drawCorner(canvas, size, paint);
  }

  void _drawCorner(Canvas canvas, Size size, Paint paint) {
    const cornerLen = 20.0;
    const margin = 20.0;

    final cornerPaint = Paint()
      ..color = Colors.white.withOpacity(0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    // Top-left
    canvas.drawLine(const Offset(margin, margin), Offset(margin + cornerLen, margin), cornerPaint);
    canvas.drawLine(const Offset(margin, margin), Offset(margin, margin + cornerLen), cornerPaint);
    // Top-right
    canvas.drawLine(Offset(size.width - margin, margin), Offset(size.width - margin - cornerLen, margin), cornerPaint);
    canvas.drawLine(Offset(size.width - margin, margin), Offset(size.width - margin, margin + cornerLen), cornerPaint);
    // Bottom-left
    canvas.drawLine(Offset(margin, size.height - margin), Offset(margin + cornerLen, size.height - margin), cornerPaint);
    canvas.drawLine(Offset(margin, size.height - margin), Offset(margin, size.height - margin - cornerLen), cornerPaint);
    // Bottom-right
    canvas.drawLine(Offset(size.width - margin, size.height - margin), Offset(size.width - margin - cornerLen, size.height - margin), cornerPaint);
    canvas.drawLine(Offset(size.width - margin, size.height - margin), Offset(size.width - margin, size.height - margin - cornerLen), cornerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false; // Tĩnh → không repaint
}
