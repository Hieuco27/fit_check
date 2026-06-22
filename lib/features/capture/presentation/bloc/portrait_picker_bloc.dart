import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fit_check/features/capture/domain/entities/system_model.dart';
import 'package:fit_check/features/capture/presentation/bloc/portrait_picker_event.dart';
import 'package:fit_check/features/capture/presentation/bloc/portrait_picker_state.dart';

/// Bloc quản lý màn hình chọn chân dung (PortraitPickerPage)
class PortraitPickerBloc
    extends Bloc<PortraitPickerEvent, PortraitPickerState> {
  PortraitPickerBloc() : super(const PortraitPickerLoading()) {
    on<LoadPickerData>(_onLoadData);
    on<SwitchPickerTab>(_onSwitchTab);
    on<SelectSystemModel>(_onSelectModel);
    on<SelectPhoto>(_onSelectPhoto);
    on<ConfirmPortraitSelection>(_onConfirm);
  }

  // ─── Load Data ────────────────────────────────────────────────────────────
  Future<void> _onLoadData(
    LoadPickerData event,
    Emitter<PortraitPickerState> emit,
  ) async {
    emit(const PortraitPickerLoading());

    // Simulate async loading (sẽ thay bằng API call sau)
    await Future.delayed(const Duration(milliseconds: 300));

    // Mock: ảnh thư viện — Unsplash fashion photos (portrait style)
    final mockPhotos = [
      'https://images.unsplash.com/photo-1469334031218-e382a71b716b?w=300&auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=300&auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1487222477894-8943e31ef7b2?w=300&auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1496747611176-843222e1e57c?w=300&auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1509631179647-0177331693ae?w=300&auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=300&auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1521119989659-a83eee488004?w=300&auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1504703395950-b89145a5425b?w=300&auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1525507119028-ed4c629a60a3?w=300&auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1531746020798-e6953c6e8e04?w=300&auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1541216970279-affbfdd55aa8?w=300&auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1502716119720-b23a93e5fe1b?w=300&auto=format&fit=crop&q=80',
    ];

    emit(PortraitPickerLoaded(
      systemModels: SystemModel.mockModels,
      photos: mockPhotos,
    ));
  }

  // ─── Switch Tab ───────────────────────────────────────────────────────────
  void _onSwitchTab(
    SwitchPickerTab event,
    Emitter<PortraitPickerState> emit,
  ) {
    final current = state;
    if (current is PortraitPickerLoaded) {
      emit(current.copyWith(tabIndex: event.tabIndex));
    }
  }

  // ─── Select Model ─────────────────────────────────────────────────────────
  void _onSelectModel(
    SelectSystemModel event,
    Emitter<PortraitPickerState> emit,
  ) {
    final current = state;
    if (current is PortraitPickerLoaded) {
      // Nếu tap lại model đang chọn → deselect
      final isSame = current.selectedModel?.id == event.model.id;
      if (isSame) {
        emit(current.copyWith(clearSelection: true));
      } else {
        emit(current.copyWith(
          selectedModel: event.model,
          selectedImagePath: null, // Clear ảnh thư viện
        ));
      }
    }
  }

  // ─── Select Photo ─────────────────────────────────────────────────────────
  void _onSelectPhoto(
    SelectPhoto event,
    Emitter<PortraitPickerState> emit,
  ) {
    final current = state;
    if (current is PortraitPickerLoaded) {
      // Nếu tap lại ảnh đang chọn → deselect
      final isSame = current.selectedImagePath == event.imagePath;
      if (isSame) {
        emit(current.copyWith(clearSelection: true));
      } else {
        emit(current.copyWith(
          selectedImagePath: event.imagePath,
          selectedModel: null, // Clear model
        ));
      }
    }
  }

  // ─── Confirm ──────────────────────────────────────────────────────────────
  void _onConfirm(
    ConfirmPortraitSelection event,
    Emitter<PortraitPickerState> emit,
  ) {
    final current = state;
    if (current is PortraitPickerLoaded) {
      final path = current.resolvedPortraitPath;
      if (path != null) {
        emit(PortraitPickerConfirmed(path));
      }
    }
  }
}
