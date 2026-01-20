#include <flutter/dart_project.h>
#include <flutter/flutter_view_controller.h>
#include <windows.h>

#include "flutter/generated_plugin_registrant.h"

int APIENTRY wWinMain(_In_ HINSTANCE instance, _In_opt_ HINSTANCE prev,
                      _In_ wchar_t *command_line, _In_ int show_command) {
  flutter::DartProject project(L"data");

  std::vector<std::string> command_line_arguments;

  flutter::FlutterViewController::ViewMode view_mode = 
      flutter::FlutterViewController::ViewMode::kNormalMode;

  flutter::FlutterViewController controller(100, 100, project);
  RegisterPlugins(controller.engine());
  controller.engine()->SetNextFrameCallback([&]() {
    controller.ForceRedraw();
  });

  ::MSG msg;
  while (::GetMessage(&msg, nullptr, 0, 0)) {
    ::TranslateMessage(&msg);
    ::DispatchMessage(&msg);
  }

  return EXIT_SUCCESS;
}
