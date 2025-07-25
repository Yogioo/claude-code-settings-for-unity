@echo off
REM 复制当前目录的.mcp.json文件到上级目录
copy ".mcp.json" "..\mcp.json"
if %errorlevel% equ 0 (
    echo 文件复制成功: .mcp.json -> ..\mcp.json
) else (
    echo 文件复制失败
)
pause