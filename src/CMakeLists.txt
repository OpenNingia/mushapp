cmake_minimum_required(VERSION 3.3)

project(MushApp LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 14)

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

find_package(Qt5 COMPONENTS Core Quick Sql WebEngine REQUIRED)

get_target_property(Qt5Core_location Qt5::Core LOCATION)
get_filename_component(QT5_DLL_DIR ${Qt5Core_location} DIRECTORY)

add_executable(${PROJECT_NAME} WIN32 "main.cpp" "sqlcharactermodel.cpp" "qml/qml.qrc")
target_link_libraries(${PROJECT_NAME} Qt5::Core Qt5::Quick Qt5::Sql Qt5::WebEngine)

# INSTALL INSTRUCTIONS
install(TARGETS ${PROJECT_NAME} DESTINATION bin COMPONENT coreapp)
#if(UNIX)
#  install(FILES assets/gnu/CodeSearch.desktop DESTINATION share/applications COMPONENT coreapp)
#  install(FILES assets/iconset/svg/search.svg DESTINATION share/pixmaps/CodeSearch COMPONENT coreapp)
#endif()

# ON WINDOWS SHOULD ALSO INSTALL SHARED LIBRARIES
if(WIN32)
  install(FILES
    ${QT5_DLL_DIR}/D3Dcompiler_47.dll
    ${QT5_DLL_DIR}/libEGL${D}.dll
    ${QT5_DLL_DIR}/libGLESV2${D}.dll
    ${QT5_DLL_DIR}/opengl32sw.dll
    ${QT5_DLL_DIR}/Qt5Core${D}.dll
    ${QT5_DLL_DIR}/Qt5Gui${D}.dll
    ${QT5_DLL_DIR}/Qt5Sql${D}.dll
    ${QT5_DLL_DIR}/Qt5Svg${D}.dll
    ${QT5_DLL_DIR}/Qt5Qml${D}.dll
    ${QT5_DLL_DIR}/Qt5Network${D}.dll
    ${QT5_DLL_DIR}/Qt5Quick${D}.dll
    ${QT5_DLL_DIR}/Qt5QuickControls2${D}.dll
    ${QT5_DLL_DIR}/Qt5QuickTemplates2${D}.dll
    DESTINATION bin
    COMPONENT coreapp)
endif()

# translation files
install(FILES
  ../i18n/MushApp_en.qm
  ../i18n/MushApp_it.qm
  DESTINATION bin/i18n
  COMPONENT coreapp)

if(WIN32)
  string(REPLACE "\\" "/" ENV_PROGRAMFILES $ENV{PROGRAMFILES})
  string(REPLACE "\\" "/" ENV_LOCALAPPDATA $ENV{LOCALAPPDATA})
  string(REPLACE "\\" "/" ENV_USERPROFILE $ENV{USERPROFILE})
endif()

# PACKAGING GENERIC
set(CPACK_PACKAGE_NAME MushApp)
set(CPACK_PACKAGE_VERSION_MAJOR 0)
set(CPACK_PACKAGE_VERSION_MINOR 0)
set(CPACK_PACKAGE_VERSION_PATCH 1)

set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "Musha Shugyo companion App")
set(CPACK_PACKAGE_CONTACT "Daniele Simonetti <oppifjellet@gmail.com>")
set(CPACK_PACKAGE_VENDOR "Daniele Simonetti")
set(CPACK_PACKAGE_INSTALL_DIRECTORY MushApp)
#file(TO_NATIVE_PATH "${CMAKE_SOURCE_DIR}/assets/iconset/svg/search.svg" CPACK_PACKAGE_ICON)
#set(CPACK_PACKAGE_ICON "${CMAKE_SOURCE_DIR}/assets/iconset/svg/search.svg")

#if(WIN32)
#  string(REPLACE "\\" "\\\\" CPACK_PACKAGE_ICON ${CPACK_PACKAGE_ICON})
#endif()

#set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_SOURCE_DIR}/LICENSE")
#set(CPACK_RESOURCE_FILE_README "${CMAKE_SOURCE_DIR}/README.md")
set(CPACK_PACKAGE_EXECUTABLES "MushApp;MushApp")

# PACKAGING DEB
#set(CPACK_DEBIAN_PACKAGE_SECTION devel)
#set(CPACK_DEBIAN_PACKAGE_RECOMMENDS "golang-go")
#set(CPACK_DEBIAN_PACKAGE_ARCHITECTURE amd64)
#set(CPACK_DEBIAN_PACKAGE_DEPENDS "qt5-default, libqt5scintilla2-12v5, libqt5scintilla2-l10n")

# PACKAGING NSIS
file(TO_NATIVE_PATH ${ENV_LOCALAPPDATA}/Programs CPACK_NSIS_INSTALL_ROOT)
string(REPLACE "\\" "\\\\" CPACK_NSIS_INSTALL_ROOT ${CPACK_NSIS_INSTALL_ROOT})
#set(CPACK_NSIS_INSTALL_ROOT $ENV{LOCALAPPDATA}/Programs/${CPACK_PACKAGE_NAME})
set(CPACK_NSIS_ENABLE_UNINSTALL_BEFORE_INSTALL ON)
set(CPACK_NSIS_URL_INFO_ABOUT "https://gitlab.com/dasi")
set(CPACK_NSIS_CONTACT ${CPACK_PACKAGE_CONTACT})
set(CPACK_NSIS_MUI_FINISHPAGE_RUN "MushApp")
set(CPACK_NSIS_COMPRESSOR "/FINAL /SOLID lzma")

include(CPack)
include(CPackNSIS)

# CONFIGURE COMPONENTS
cpack_add_component(
  coreapp
  DISPLAY_NAME "MushApp application"
  DESCRIPTION "Install MushApp application files"
  REQUIRED)
