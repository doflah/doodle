include_directories(
    ${CMAKE_CURRENT_SOURCE_DIR}
)

set(
    Doodlebackend_SRCS
    modules/Doodle/backend.cpp
)

add_library(Doodlebackend MODULE
    ${Doodlebackend_SRCS}
)

set_target_properties(Doodlebackend PROPERTIES
         LIBRARY_OUTPUT_DIRECTORY Doodle)

qt5_use_modules(Doodlebackend Gui Qml Quick)

# Copy qmldir file to build dir for running in QtCreator
add_custom_target(Doodlebackend-qmldir ALL
    COMMAND cp ${CMAKE_CURRENT_SOURCE_DIR}/modules/Doodle/qmldir ${CMAKE_CURRENT_BINARY_DIR}/Doodle
    DEPENDS ${QMLFILES}
)

# Install plugin file
install(TARGETS Doodlebackend DESTINATION ${QT_IMPORTS_DIR}/Doodle/)
install(FILES   modules/Doodle/qmldir DESTINATION ${QT_IMPORTS_DIR}/Doodle/)

