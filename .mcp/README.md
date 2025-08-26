# MCP Configuration for Linux_Setup

This directory contains Model Context Protocol (MCP) server configurations specific to this repository.

## Files

- `config.json` - Repository-specific MCP configuration
- `memory_template.json` - Template for memory server context
- `.gitignore` - Excludes temporary MCP files from git

## MCP Servers Available

### Memory Server
- Maintains context between Claude sessions
- Remembers important repository information
- Stores development notes and patterns

### Filesystem Server  
- Configured with repository-specific exclude patterns
- Optimized for this repository's structure and technology stack

### Sequential-thinking Server
- Enhanced reasoning for complex problems in this codebase
- Context-aware problem solving

## Usage

When using Claude Code in this repository, the global MCP servers will automatically use these configurations for enhanced, repository-specific functionality.

## Configuration

Edit `config.json` to customize:
- File patterns to exclude from filesystem operations
- Memory server behavior
- Project-specific context and metadata
