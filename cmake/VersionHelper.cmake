function(get_version)
    set(_version_file "${CMAKE_CURRENT_SOURCE_DIR}/src/.version")
    if(EXISTS "${_version_file}")
        file(READ "${_version_file}" version)
        string(STRIP "${version}" version)
    else()
        set(version "unknown")
    endif()

    execute_process(
        COMMAND git log -n1 --format=%H src/.version
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
        OUTPUT_VARIABLE version_commit
        RESULT_VARIABLE git_log_result
        OUTPUT_STRIP_TRAILING_WHITESPACE
        ERROR_QUIET
    )

    if(git_log_result EQUAL 0 AND NOT "${version_commit}" STREQUAL "")
        execute_process(
            COMMAND git rev-list --count "${version_commit}..HEAD"
            WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
            OUTPUT_VARIABLE patch_number
            RESULT_VARIABLE git_revlist_result
            OUTPUT_STRIP_TRAILING_WHITESPACE
            ERROR_QUIET
        )
        if(git_revlist_result EQUAL 0)
            string(STRIP "${patch_number}" patch_number)
        else()
            set(patch_number "0")
        endif()
    else()
        set(patch_number "0")
    endif()

    set(KALDI_VERSION "${version}" PARENT_SCOPE)
    set(KALDI_PATCH_NUMBER "${patch_number}" PARENT_SCOPE)
endfunction()
