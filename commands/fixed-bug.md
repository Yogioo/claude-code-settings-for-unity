Please fixed script bug, you can use Unity MCP Tools for read unity console log with under flow

1. Trigger Compile
call 'mcp__unityMCP__execute_menu_item(Assets/Refresh)'

1. Check unity console log
call `mcp__unityMCP__read_console(action: "get", types: ["all"], count: 10,format: "detailed")`