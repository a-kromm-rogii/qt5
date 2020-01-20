set(
    MODULE_PATH_BACKUP33333399999
    "${CMAKE_MODULE_PATH}"
)

set(
    CMAKE_MODULE_PATH
    ""
)

set(
    ROGII_SUFFIX
    "Rogii"
)

set(
    PREFIX_PATH_BACKUP33333399999
    "${CMAKE_PREFIX_PATH}"
)

set(
    CMAKE_PREFIX_PATH
    "${CMAKE_CURRENT_LIST_DIR}"
)

set(
    COMPONENTS

    Core
    Concurrent
    Designer
    Gui
    Help
    Svg
    Widgets
    Sql
    PrintSupport
    Test
    Network
    OpenGL
    LinguistTools
    Qml
    Quick
    QuickControls2
    QuickTest
    QuickWidgets
    UiPlugin
    UiTools
    WebSockets
    Xml
)

find_package(
    Qt5
        5.9.9
        EXACT
    REQUIRED
        ${COMPONENTS}
    CONFIG
)

set(
    CMAKE_MODULE_PATH
    "${MODULE_PATH_BACKUP33333399999}"
)

unset(
    MODULE_PATH_BACKUP33333399999
)

set(
    CMAKE_PREFIX_PATH
    "${PREFIX_PATH_BACKUP33333399999}"
)

unset(
    PREFIX_PATH_BACKUP33333399999
)

if(NOT TARGET Qt5::QuickTemplates2)
    add_library(
        Qt5::QuickTemplates2
        SHARED
        IMPORTED
    )

    if(WIN32)
        set_target_properties(
            Qt5::QuickTemplates2
            PROPERTIES
                IMPORTED_LOCATION
                    "${CMAKE_CURRENT_LIST_DIR}/bin/Qt5QuickTemplates2${ROGII_SUFFIX}.dll"
                IMPORTED_LOCATION_DEBUG
                    "${CMAKE_CURRENT_LIST_DIR}/bin/Qt5QuickTemplates2${ROGII_SUFFIX}d.dll"
                IMPORTED_IMPLIB
                    "${CMAKE_CURRENT_LIST_DIR}/lib/Qt5QuickTemplates2${ROGII_SUFFIX}.lib"
                IMPORTED_IMPLIB_DEBUG
                    "${CMAKE_CURRENT_LIST_DIR}/lib/Qt5QuickTemplates2${ROGII_SUFFIX}d.lib"
                INTERFACE_INCLUDE_DIRECTORIES
                    "${CMAKE_CURRENT_LIST_DIR}/include/QtQuickTemplates2/;${CMAKE_CURRENT_LIST_DIR}/include/"
                INTERFACE_LINK_LIBRARIES
                    "Qt5::Quick"
        )
    elseif(UNIX)
        set_target_properties(
                Qt5::QuickTemplates2
                PROPERTIES
                    IMPORTED_LOCATION
                        "${CMAKE_CURRENT_LIST_DIR}/lib/libQt5QuickTemplates2${ROGII_SUFFIX}.so.5.9.9"
                    INTERFACE_INCLUDE_DIRECTORIES
                        "${CMAKE_CURRENT_LIST_DIR}/include/QtQuickTemplates2/;${CMAKE_CURRENT_LIST_DIR}/include/"
                    INTERFACE_LINK_LIBRARIES
                        "Qt5::Quick"
            )
    endif()
endif()

set(
    TARGETS_TO_INSTALL

    QuickControls2
    QuickTemplates2
    QuickTest
)

foreach(COMPONENT ${TARGETS_TO_INSTALL})
    set(
        COMPONENT_NAMES

        CNPM_RUNTIME_Qt5_${COMPONENT}
        CNPM_RUNTIME_Qt5
        CNPM_RUNTIME
    )

    foreach(COMPONENT_NAME ${COMPONENT_NAMES})
        install(
            FILES
                $<TARGET_FILE:Qt5::${COMPONENT}>
            DESTINATION
                .
            COMPONENT
                ${COMPONENT_NAME}
            EXCLUDE_FROM_ALL
        )
    endforeach()
endforeach()

if(WIN32)
    # TODO: remove copypaste
    set(
        TARGETS_TO_INSTALL

        Concurrent
        Svg
        Widgets
        Sql
        PrintSupport
        Qml
        Quick
        Core
        Gui
        Network
        Gui_EGL
        Gui_GLESv2
        QuickWidgets
    )

    foreach(COMPONENT ${TARGETS_TO_INSTALL})
        set(
            COMPONENT_NAMES

            CNPM_RUNTIME_Qt5_${COMPONENT}
            CNPM_RUNTIME_Qt5
            CNPM_RUNTIME
        )

        foreach(COMPONENT_NAME ${COMPONENT_NAMES})
            install(
                FILES
                    $<TARGET_FILE:Qt5::${COMPONENT}>
                DESTINATION
                    .
                COMPONENT
                    ${COMPONENT_NAME}
                EXCLUDE_FROM_ALL
            )
        endforeach()
    endforeach()

    set(
        COMPONENT_NAMES

        CNPM_RUNTIME_Qt5_qml
        CNPM_RUNTIME_Qt5
        CNPM_RUNTIME
    )

    foreach(COMPONENT_NAME ${COMPONENT_NAMES})
        # pattern to exclude debug dlls may fail, I mean it
        install(
            DIRECTORY
                $<TARGET_FILE_DIR:Qt5::Core>/../qml
            DESTINATION
                .
            CONFIGURATIONS
                MinSizeRel
                RelWithDebInfo
                Release
            EXCLUDE_FROM_ALL
            COMPONENT
                ${COMPONENT_NAME}
            PATTERN
                "*d.dll"
                EXCLUDE
            PATTERN
                "*.qmlc"
                EXCLUDE
            PATTERN
                "*.pdb"
                EXCLUDE
        )

        # it install also release dlls 'cause
        # it's not so trivial to exclude them just by analizing its name
        # at the moment )
        # In any case debug build mustn't be deployed so the approach
        # is good enough
        install(
            DIRECTORY
                $<TARGET_FILE_DIR:Qt5::Core>/../qml
            DESTINATION
                .
            CONFIGURATIONS
                Debug
            EXCLUDE_FROM_ALL
            COMPONENT
                ${COMPONENT_NAME}
            PATTERN
                "*.qmlc"
                EXCLUDE
            PATTERN
                "*.pdb"
                EXCLUDE
        )
    endforeach()
elseif(UNIX)
    install(
        FILES
            $<TARGET_FILE:Qt5::Core>
        DESTINATION
            .
        COMPONENT
            CNPM_RUNTIME
        RENAME
            libQt5Core${ROGII_SUFFIX}.so.5
        EXCLUDE_FROM_ALL
    )
    install(
        FILES
            $<TARGET_FILE:Qt5::Gui>
        DESTINATION
            .
        COMPONENT
            CNPM_RUNTIME
        RENAME
            libQt5Gui${ROGII_SUFFIX}.so.5
        EXCLUDE_FROM_ALL
    )
    install(
        FILES
            $<TARGET_FILE:Qt5::Network>
        DESTINATION
            .
        COMPONENT
            CNPM_RUNTIME
        RENAME
            libQt5Network${ROGII_SUFFIX}.so.5
        EXCLUDE_FROM_ALL
    )
    install(
        FILES
            $<TARGET_FILE:Qt5::Concurrent>
        DESTINATION
            .
        COMPONENT
            CNPM_RUNTIME
        RENAME
            libQt5Concurrent${ROGII_SUFFIX}.so.5
        EXCLUDE_FROM_ALL
    )
    install(
        FILES
            $<TARGET_FILE:Qt5::Svg>
        DESTINATION
            .
        COMPONENT
            CNPM_RUNTIME
        RENAME
            libQt5Svg${ROGII_SUFFIX}.so.5
        EXCLUDE_FROM_ALL
    )
    install(
        FILES
            $<TARGET_FILE:Qt5::Quick>
        DESTINATION
            .
        COMPONENT
            CNPM_RUNTIME
        RENAME
            libQt5Quick${ROGII_SUFFIX}.so.5
        EXCLUDE_FROM_ALL
    )
    install(
        FILES
            $<TARGET_FILE:Qt5::Qml>
        DESTINATION
            .
        COMPONENT
            CNPM_RUNTIME
        RENAME
            libQt5Qml${ROGII_SUFFIX}.so.5
        EXCLUDE_FROM_ALL
    )
    install(
        FILES
            $<TARGET_FILE:Qt5::Widgets>
        DESTINATION
            .
        COMPONENT
            CNPM_RUNTIME
        RENAME
            libQt5Widgets${ROGII_SUFFIX}.so.5
        EXCLUDE_FROM_ALL
    )
    install(
        FILES
            $<TARGET_FILE:Qt5::QuickWidgets>
        DESTINATION
            .
        COMPONENT
            CNPM_RUNTIME
        RENAME
            libQt5QuickWidgets${ROGII_SUFFIX}.so.5
        EXCLUDE_FROM_ALL
    )
    install(
        FILES
            $<TARGET_FILE:Qt5::PrintSupport>
        DESTINATION
            .
        COMPONENT
            CNPM_RUNTIME
        RENAME
            libQt5PrintSupport${ROGII_SUFFIX}.so.5
        EXCLUDE_FROM_ALL
    )
endif()

if(WIN32)
    # TODO: remove copypaste
    set(
        TARGETS_TO_INSTALL

        QOffscreenIntegrationPlugin
        QMinimalIntegrationPlugin
        QWindowsIntegrationPlugin
        QWindowsDirect2DIntegrationPlugin
    )

    foreach(plugin ${TARGETS_TO_INSTALL})
        set(
            COMPONENT_NAMES

            CNPM_RUNTIME_Qt5_plugins_platforms_${plugin}
            CNPM_RUNTIME_Qt5_plugins_platforms
            CNPM_RUNTIME_Qt5_plugins
            CNPM_RUNTIME_Qt5
            CNPM_RUNTIME
        )

        foreach(COMPONENT_NAME ${COMPONENT_NAMES})
            install(
                FILES
                    $<TARGET_FILE:Qt5::${plugin}>
                DESTINATION
                    "./platforms"
                COMPONENT
                    ${COMPONENT_NAME}
                EXCLUDE_FROM_ALL
            )
        endforeach()
    endforeach()

    # yes, this copies also platform plugins, but who cares
    # about so awkward Qt5's cmake?
    foreach(plugin ${Qt5Gui_PLUGINS})
        set(
            COMPONENT_NAMES

            CNPM_RUNTIME_Qt5_plugins_imageformats_${plugin}
            CNPM_RUNTIME_Qt5_plugins_imageformats
            CNPM_RUNTIME_Qt5_plugins
            CNPM_RUNTIME_Qt5
            CNPM_RUNTIME
        )

        foreach(COMPONENT_NAME ${COMPONENT_NAMES})
            install(
                FILES
                    $<TARGET_FILE:${plugin}>
                DESTINATION
                    "./imageformats"
                COMPONENT
                    ${COMPONENT_NAME}
                EXCLUDE_FROM_ALL
            )
        endforeach()
    endforeach()

    set(
        TARGETS_TO_INSTALL

        QODBCDriverPlugin
    )

    foreach(plugin ${TARGETS_TO_INSTALL})
        set(
            COMPONENT_NAMES

            CNPM_RUNTIME_Qt5_plugins_sqldrivers_${plugin}
            CNPM_RUNTIME_Qt5_plugins_sqldrivers
            CNPM_RUNTIME_Qt5_plugins
            CNPM_RUNTIME_Qt5
            CNPM_RUNTIME
        )

        foreach(COMPONENT_NAME ${COMPONENT_NAMES})
            install(
                FILES
                    $<TARGET_FILE:Qt5::${plugin}>
                DESTINATION
                    "./sqldrivers"
                COMPONENT
                    ${COMPONENT_NAME}
                EXCLUDE_FROM_ALL
            )
        endforeach()
    endforeach()
endif()

unset(
    TARGETS_TO_INSTALL
)

unset(
    COMPONENT_NAMES
)

foreach(COMPONENT ${COMPONENTS})
    unset(
        Qt5${COMPONENT}_DIR
        CACHE
    )
endforeach()

unset(
    COMPONENTS
)

unset(
    Qt5_DIR
    CACHE
)

