import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fit_check/features/capture/domain/entities/captured_image.dart';
import 'package:fit_check/features/capture/domain/usecases/analyze_garment_usecase.dart';
import 'package:fit_check/features/capture/domain/usecases/analyze_portrait_usecase.dart';
import 'package:fit_check/features/capture/presentation/bloc/camera_event.dart';
import 'package:fit_check/features/capture/presentation/bloc/camera_state.dart';

/// CameraBloc — quản lý toàn bộ lifecycle của tính năng camera:
/// - Khởi tạo và dispose CameraController (tránh memory leak)
/// - Chuyển chế độ Portrait ↔ Garment
/// - Chụp ảnh / chọn gallery / lật camera / flash
/// - Trigger phân tích AI sau khi có ảnh
class CameraBloc extends Bloc<CameraEvent, CameraState> {
  final AnalyzePortraitUseCase _analyzePortrait;
  final AnalyzeGarmentUseCase _analyzeGarment;
  final ImagePicker _imagePicker = ImagePicker();

  // Lưu tham chiếu controller để dispose đúng cách
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];

  // Track camera đang dùng (front = 0 trên hầu hết device, back = 1)
  int _currentCameraIndex = 0;

  CameraBloc({
    required AnalyzePortraitUseCase analyzePortrait,
    required AnalyzeGarmentUseCase analyzeGarment,
  }) : _analyzePortrait = analyzePortrait,
       _analyzeGarment = analyzeGarment,
       super(const CameraInitial()) {
    on<InitCameraEvent>(_onInitCamera);
    on<SwitchCameraModeEvent>(_onSwitchMode);
    on<CapturePhotoEvent>(_onCapturePhoto);
    on<PickFromGalleryEvent>(_onPickFromGallery);
    on<FlipCameraEvent>(_onFlipCamera);
    on<ToggleFlashEvent>(_onToggleFlash);
    on<AnalyzePortraitEvent>(_onAnalyzePortrait);
    on<AnalyzeGarmentEvent>(_onAnalyzeGarment);
    on<RetakeCaptureEvent>(_onRetake);
    on<ConfirmPortraitEvent>(_onConfirmPortrait);
    on<ConfirmGarmentEvent>(_onConfirmGarment);
    on<SelectBodyZoneEvent>(_onSelectBodyZone);
  }

  // Init Camera
  Future<void> _onInitCamera(
    InitCameraEvent event,
    Emitter<CameraState> emit,
  ) async {
    emit(const CameraInitializing());
    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        emit(const CameraError('Không tìm thấy camera trên thiết bị'));
        return;
      }

      // Chọn camera theo yêu cầu từ Home:
      // Portrait mode → cam trước (selfie), Garment mode → cam sau
      if (event.useFrontCamera && _cameras.length > 1) {
        // Tìm front camera (lens facing front)
        final frontIndex = _cameras.indexWhere(
          (c) => c.lensDirection == CameraLensDirection.front,
        );
        _currentCameraIndex = frontIndex >= 0 ? frontIndex : 0;
      } else {
        // Tìm rear camera (lens facing back)
        final backIndex = _cameras.indexWhere(
          (c) => c.lensDirection == CameraLensDirection.back,
        );
        _currentCameraIndex = backIndex >= 0 ? backIndex : 0;
      }

      final isFront =
          _cameras[_currentCameraIndex].lensDirection ==
          CameraLensDirection.front;

      await _initController(_cameras[_currentCameraIndex]);
      emit(
        CameraReady(
          controller: _cameraController!,
          mode: event.initialMode,
          isFrontCamera: isFront,
        ),
      );
    } catch (e) {
      emit(CameraError('Không thể khởi động camera: ${e.toString()}'));
    }
  }

  /// Khởi tạo CameraController với resolution phù hợp
  Future<void> _initController(CameraDescription camera) async {
    // Dispose controller cũ trước khi tạo mới để tránh memory leak
    await _disposeController();

    _cameraController = CameraController(
      camera,
      ResolutionPreset.high, // Đủ chất lượng cho AI, không quá nặng
      enableAudio: false, // Không cần audio cho camera chụp ảnh
      imageFormatGroup: ImageFormatGroup.jpeg,
    );
    await _cameraController!.initialize();
  }

  // ─── Switch Mode ─────────────────────────────────────────────────────────────
  void _onSwitchMode(SwitchCameraModeEvent event, Emitter<CameraState> emit) {
    final current = state;
    if (current is CameraReady) {
      // Chỉ update mode, không rebuild camera controller → không bị flicker
      emit(current.copyWith(mode: event.mode));
    }
  }

  // ─── Capture Photo ─────────────────────────────────────────────────────────
  Future<void> _onCapturePhoto(
    CapturePhotoEvent event,
    Emitter<CameraState> emit,
  ) async {
    final current = state;
    if (current is! CameraReady) return;
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    final mode = current.mode;
    emit(CameraCapturing(mode));

    try {
      final xFile = await _cameraController!.takePicture();
      // Emit preview, KHÔNG tự động phân tích AI nữa (chờ user xác nhận)
      emit(CapturePreview(imagePath: xFile.path, mode: mode));
    } catch (e) {
      emit(CameraError('Chụp ảnh thất bại: ${e.toString()}'));
      // Khôi phục về Ready
      emit(CameraReady(controller: _cameraController!, mode: mode));
    }
  }

  // ─── Pick from Gallery ──────────────────────────────────────────────────────
  Future<void> _onPickFromGallery(
    PickFromGalleryEvent event,
    Emitter<CameraState> emit,
  ) async {
    final current = state;
    CameraMode mode = CameraMode.portrait;
    if (current is CameraReady) mode = current.mode;

    try {
      final xFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85, // Giảm dung lượng để upload nhanh hơn
        maxWidth: 1080, // Giới hạn kích thước để tối ưu bộ nhớ
        maxHeight: 1920,
      );

      if (xFile == null) return; // Người dùng hủy

      emit(CapturePreview(imagePath: xFile.path, mode: mode));
    } catch (e) {
      emit(CameraError('Không thể mở thư viện ảnh: ${e.toString()}'));
    }
  }

  // ─── Flip Camera ─────────────────────────────────────────────────────────────
  Future<void> _onFlipCamera(
    FlipCameraEvent event,
    Emitter<CameraState> emit,
  ) async {
    final current = state;
    if (current is! CameraReady || _cameras.length < 2) return;

    // Toggle camera index
    _currentCameraIndex = (_currentCameraIndex + 1) % _cameras.length;
    final isFront = _currentCameraIndex != 0;

    try {
      await _initController(_cameras[_currentCameraIndex]);
      emit(
        current.copyWith(controller: _cameraController, isFrontCamera: isFront),
      );
    } catch (e) {
      emit(CameraError('Không thể chuyển camera: ${e.toString()}'));
    }
  }

  // ─── Toggle Flash ─────────────────────────────────────────────────────────────
  Future<void> _onToggleFlash(
    ToggleFlashEvent event,
    Emitter<CameraState> emit,
  ) async {
    final current = state;
    if (current is! CameraReady || _cameraController == null) return;

    final newFlashOn = !current.isFlashOn;
    try {
      await _cameraController!.setFlashMode(
        newFlashOn ? FlashMode.torch : FlashMode.off,
      );
      emit(current.copyWith(isFlashOn: newFlashOn));
    } catch (_) {
      // Flash không được hỗ trợ → ignore silently
    }
  }

  // ─── AI Portrait Analysis ────────────────────────────────────────────────────
  Future<void> _onAnalyzePortrait(
    AnalyzePortraitEvent event,
    Emitter<CameraState> emit,
  ) async {
    emit(PortraitAnalyzing(event.imagePath));
    try {
      final bodyProfile = await _analyzePortrait(event.imagePath);
      emit(
        PortraitAnalyzed(imagePath: event.imagePath, bodyProfile: bodyProfile),
      );
    } catch (e) {
      emit(CameraError('Phân tích ảnh thất bại: ${e.toString()}'));
    }
  }

  // ─── AI Garment Analysis ─────────────────────────────────────────────────────
  Future<void> _onAnalyzeGarment(
    AnalyzeGarmentEvent event,
    Emitter<CameraState> emit,
  ) async {
    emit(GarmentAnalyzing(event.imagePath));
    try {
      final garmentScan = await _analyzeGarment(event.imagePath);
      emit(GarmentAnalyzed(garmentScan: garmentScan));
    } catch (e) {
      emit(CameraError('Phân tích quần áo thất bại: ${e.toString()}'));
    }
  }

  // ─── Retake ──────────────────────────────────────────────────────────────────
  Future<void> _onRetake(
    RetakeCaptureEvent event,
    Emitter<CameraState> emit,
  ) async {
    // Xác định mode trước khi retake từ state hiện tại
    CameraMode mode = CameraMode.portrait;
    if (state is PortraitAnalyzed) {
      mode = CameraMode.portrait;
    } else if (state is GarmentAnalyzed) {
      mode = CameraMode.garment;
    } else if (state is CapturePreview) {
      mode = (state as CapturePreview).mode;
    }

    // Khởi tạo lại camera nếu controller vẫn còn
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      emit(CameraReady(controller: _cameraController!, mode: mode));
    } else {
      add(InitCameraEvent(initialMode: mode));
    }
  }

  // ─── Confirm Actions ─────────────────────────────────────────────────────────
  void _onConfirmPortrait(
    ConfirmPortraitEvent event,
    Emitter<CameraState> emit,
  ) {
    if (state is CapturePreview) {
      add(AnalyzePortraitEvent((state as CapturePreview).imagePath));
    }
  }

  void _onConfirmGarment(ConfirmGarmentEvent event, Emitter<CameraState> emit) {
    if (state is CapturePreview) {
      add(AnalyzeGarmentEvent((state as CapturePreview).imagePath));
    }
  }

  // ─── Select Body Zone ─────────────────────────────────────────────────────────
  void _onSelectBodyZone(SelectBodyZoneEvent event, Emitter<CameraState> emit) {
    final current = state;
    if (current is PortraitAnalyzed) {
      // Highlight vùng được chọn trước khi navigate
      emit(current.copyWith(selectedZone: event.zone));
    }
  }

  // ─── Dispose ────────────────────────────────────────────────────────────────
  /// Giải phóng CameraController khi bloc bị đóng.
  /// Quan trọng: tránh memory leak và lỗi "CameraController was used after being disposed"
  Future<void> _disposeController() async {
    if (_cameraController != null) {
      await _cameraController!.dispose();
      _cameraController = null;
    }
  }

  @override
  Future<void> close() async {
    await _disposeController();
    return super.close();
  }
}
