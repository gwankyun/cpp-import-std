param(
    [Parameter(Mandatory=$true)][ValidateSet('msvc','gcc','clang','clangcl')][string]$compiler
)

cmake --preset $compiler

if ($LASTEXITCODE -ne 0) {
    Write-Error "error: cmake --preset $compiler"
    exit 1
}

cmake --build --preset $compiler

if ($LASTEXITCODE -ne 0) {
    Write-Error "cmake --build --preset $compiler"
    exit 1
}

ctest --preset $compiler

if ($LASTEXITCODE -ne 0) {
    Write-Error "ctest --preset $compiler"
    exit 1
}
