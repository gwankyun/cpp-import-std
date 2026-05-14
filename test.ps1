param(
    [Parameter(Mandatory=$true)][ValidateSet('msvc','gcc','clang','clangcl')][string]$compiler
)

cmake --workflow --preset $compiler
