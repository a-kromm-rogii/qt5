if(
    NOT DEFINED ROOT
    OR NOT DEFINED ARCH
)
    message(
        FATAL_ERROR
        "Assert: ROOT = ${ROOT}; ARCH = ${ARCH}"
    )
endif()

set(
    BUILD
    0
)

if(DEFINED ENV{BUILD_NUMBER})
    set(
        BUILD
        $ENV{BUILD_NUMBER}
    )
endif()

set(
    TAG
    ""
)

if(DEFINED ENV{TAG})
    set(
        TAG
        "$ENV{TAG}"
    )
else()
    find_package(
        Git
    )

    if(Git_FOUND)
        execute_process(
            COMMAND
                ${GIT_EXECUTABLE} rev-parse --short HEAD
            OUTPUT_VARIABLE
                TAG
            OUTPUT_STRIP_TRAILING_WHITESPACE
        )
        set(
            TAG
            "_${TAG}"
        )
    endif()
endif()

set(
    VERSION
    5.15.1
)

set(
    PACKAGE_NAME
    "qt-${VERSION}-${ARCH}-${BUILD}${TAG}"
)

set(
    DEBUG_PATH
    "${CMAKE_CURRENT_LIST_DIR}/../build/debug"
)

file(
    MAKE_DIRECTORY
    "${DEBUG_PATH}"
)

set(
    NPM_ROOT
    "${ENV_INSTALL}"
)

if(WIN32)
    set(
        CMAKE_GENERATOR
        -G "NMake Makefiles"
    )
endif()

execute_process(
    COMMAND
       "${CMAKE_COMMAND}" ${CMAKE_GENERATOR} -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=${ROOT}/${PACKAGE_NAME} ../.. 
    WORKING_DIRECTORY
        "${DEBUG_PATH}"
)

execute_process(
    COMMAND
        "${CMAKE_COMMAND}" --build .
    WORKING_DIRECTORY
        "${DEBUG_PATH}"
)

if(UNIX)
    #strip all shared not symlink libs
    file(GLOB files "${ROOT}/${PACKAGE_NAME}/lib/*.so*")
    foreach(file ${files})
        if(NOT IS_SYMLINK ${file})
            message(STATUS "strip ${file}")
            execute_process(
                COMMAND
                    bash ${CMAKE_CURRENT_LIST_DIR}/utils/split_debug_info.sh "${file}"
                WORKING_DIRECTORY
                    "${ROOT}/${PACKAGE_NAME}/lib/"
            )
        endif()
    endforeach()
endif()

file(
    COPY
        ${CMAKE_CURRENT_LIST_DIR}/package.cmake
    DESTINATION
        ${ROOT}/${PACKAGE_NAME}
)

file(
    COPY
        ${CMAKE_CURRENT_LIST_DIR}/qt.conf
    DESTINATION
        ${ROOT}/${PACKAGE_NAME}/bin
)

# WORKAROUND: build and install quickcontrols2 separately to enable build with precompiled qml

include(ProcessorCount)
ProcessorCount(N)

find_package(
    Git
    REQUIRED
)

set(
    PROJECT_ROOT_PATH
    "${CMAKE_CURRENT_LIST_DIR}/.."
)

set(
    QUICKCONTROLS2_ROOT_PATH
    "${PROJECT_ROOT_PATH}/qtquickcontrols2"
)

if(WIN32)
    set(
        PLATFORM_BUILD_COMMAND
        jom /j${N}
    )
    set(
        PLATFORM_INSTALL_COMMAND
        nmake install
    )
elseif(UNIX)
    set(
        PLATFORM_BUILD_COMMAND
        make -j${N}
    )
    set(
        PLATFORM_INSTALL_COMMAND
        make install
    )
else()
    message(
        FATAL_ERROR
        "Unknown platform."
    )
endif()

execute_process(
    COMMAND
        "${ROOT}/${PACKAGE_NAME}/bin/qmlcachegen" -h
    RESULT_VARIABLE
        QUICK_COMPILER_RESULT
)

if(NOT QUICK_COMPILER_RESULT EQUAL 0)
    message(
        FATAL_ERROR
        "Quick compiler is not in the PATH."
    )
endif()

# Clean is required to configure quickcontrols2 correctly
execute_process(
    COMMAND
        ${GIT_EXECUTABLE} clean -fdx
    WORKING_DIRECTORY
        "${PROJECT_ROOT_PATH}"
)

execute_process(
    COMMAND
        ${GIT_EXECUTABLE} clean -fdx
    WORKING_DIRECTORY
        "${QUICKCONTROLS2_ROOT_PATH}"
)

execute_process(
    COMMAND
        "${ROOT}/${PACKAGE_NAME}/bin/qmake"
    WORKING_DIRECTORY
        "${QUICKCONTROLS2_ROOT_PATH}"
)

execute_process(
    COMMAND
        ${PLATFORM_BUILD_COMMAND}
    WORKING_DIRECTORY
        "${QUICKCONTROLS2_ROOT_PATH}"
)

execute_process(
    COMMAND
        ${PLATFORM_INSTALL_COMMAND}
    WORKING_DIRECTORY
        "${QUICKCONTROLS2_ROOT_PATH}"
)

# WORKAROUND end

execute_process(
    COMMAND
        ${CMAKE_COMMAND} -E tar cf "${PACKAGE_NAME}.7z" --format=7zip -- "${PACKAGE_NAME}"
    WORKING_DIRECTORY
        ${ROOT}
)

