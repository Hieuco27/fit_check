import 'package:flutter/material.dart';

/// CustomPainter vẽ khung hướng dẫn đặt quần áo phẳng (Garment Frame Overlay).
/// Dùng cho chế độ "Chụp trang phục" — khung hình chữ nhật vàng với icon áo.
/// shouldRepaint = false vì overlay hoàn toàn tĩnh.
class GarmentFrameOverlay extends StatelessWidget {
  const GarmentFrameOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        painter: _GarmentFramePainter(),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _GarmentFramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // ── Khung chữ nhật chính (màu vàng #F5A623) ──────────────────────────────
    final borderPaint = Paint()
      ..color = const Color(0xFFF5A623).withOpacity(0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    const margin = 40.0;
    final frameRect = Rect.fromLTRB(
      margin,
      size.height * 0.12,
      size.width - margin,
      size.height * 0.82,
    );
    final rrect = RRect.fromRectAndRadius(frameRect, const Radius.circular(16));
    canvas.drawRRect(rrect, borderPaint);

    // ── Fill mờ bên trong khung ───────────────────────────────────────────────
    final fillPaint = Paint()
      ..color = const Color(0xFFF5A623).withOpacity(0.06);
    canvas.drawRRect(rrect, fillPaint);

    // ── Các góc dày hơn (highlight) ──────────────────────────────────────────
    final cornerPaint = Paint()
      ..color = const Color(0xFFF5A623)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;

    const cornerLen = 28.0;

    // Top-left
    canvas.drawLine(Offset(margin, frameRect.top + cornerLen), Offset(margin, frameRect.top), cornerPaint);
    canvas.drawLine(Offset(margin, frameRect.top), Offset(margin + cornerLen, frameRect.top), cornerPaint);
    // Top-right
    canvas.drawLine(Offset(size.width - margin - cornerLen, frameRect.top), Offset(size.width - margin, frameRect.top), cornerPaint);
    canvas.drawLine(Offset(size.width - margin, frameRect.top), Offset(size.width - margin, frameRect.top + cornerLen), cornerPaint);
    // Bottom-left
    canvas.drawLine(Offset(margin, frameRect.bottom - cornerLen), Offset(margin, frameRect.bottom), cornerPaint);
    canvas.drawLine(Offset(margin, frameRect.bottom), Offset(margin + cornerLen, frameRect.bottom), cornerPaint);
    // Bottom-right
    canvas.drawLine(Offset(size.width - margin - cornerLen, frameRect.bottom), Offset(size.width - margin, frameRect.bottom), cornerPaint);
    canvas.drawLine(Offset(size.width - margin, frameRect.bottom), Offset(size.width - margin, frameRect.bottom - cornerLen), cornerPaint);

    // ── Icon áo (dashed) ở trung tâm khung ───────────────────────────────────
    final iconPaint = Paint()
      ..color = const Color(0xFFF5A623).withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    final iconCx = size.width * 0.5;
    final iconCy = (frameRect.top + frameRect.bottom) * 0.5;
    final iconW = size.width * 0.25;
    final iconH = iconW * 1.3;

    // Vẽ hình áo đơn giản dạng outline
    final path = Path();
    // Cổ áo
    path.moveTo(iconCx - iconW * 0.2, iconCy - iconH * 0.5);
    path.quadraticBezierTo(iconCx, iconCy - iconH * 0.4, iconCx + iconW * 0.2, iconCy - iconH * 0.5);
    // Vai phải + tay phải
    path.lineTo(iconCx + iconW * 0.5, iconCy - iconH * 0.35);
    path.lineTo(iconCx + iconW * 0.5, iconCy - iconH * 0.15);
    path.lineTo(iconCx + iconW * 0.3, iconCy - iconH * 0.2);
    // Thân phải
    path.lineTo(iconCx + iconW * 0.3, iconCy + iconH * 0.5);
    // Đáy
    path.lineTo(iconCx - iconW * 0.3, iconCy + iconH * 0.5);
    // Thân trái
    path.lineTo(iconCx - iconW * 0.3, iconCy - iconH * 0.2);
    path.lineTo(iconCx - iconW * 0.5, iconCy - iconH * 0.15);
    path.lineTo(iconCx - iconW * 0.5, iconCy - iconH * 0.35);
    path.close();

    canvas.drawPath(path, iconPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
