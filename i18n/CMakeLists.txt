set_directory_properties(PROPERTIES CLEAN_NO_CUSTOM 1) # Don't delete TS files

find_package(Qt5LinguistTools)

# Translation files
set(ts_files
    ${CMAKE_SOURCE_DIR}/i18n/MushApp_en.ts
    ${CMAKE_SOURCE_DIR}/i18n/MushApp_it.ts
)

#set(files_to_translate
#    ../src/qml/CharacterCreationPage.qml
#    ../src/qml/CharacterInfoPage.qml
#    ../src/qml/Page1.qml
#)

qt5_create_translation(MushApp_qm ${ts_files})
add_custom_target(MushApp_translations DEPENDS ${MushApp_qm})
