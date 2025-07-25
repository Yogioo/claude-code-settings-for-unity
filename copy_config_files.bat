@echo off
REM Copy config files from current directory to parent directory
echo Starting config file copy...

REM Copy .mcp.json file
copy ".mcp.json" "..\mcp.json"
if %errorlevel% equ 0 (
    echo File copied successfully: .mcp.json -> ..\mcp.json
) else (
    echo File copy failed: .mcp.json
)

REM Copy CLAUDE.md file
copy "CLAUDE.md" "..\CLAUDE.md"
if %errorlevel% equ 0 (
    echo File copied successfully: CLAUDE.md -> ..\CLAUDE.md
) else (
    echo File copy failed: CLAUDE.md
)

echo Config file copy completed!
pause