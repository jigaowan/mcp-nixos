# Docker Image Tagging Strategy

This document explains the Docker image tagging strategy for mcp-nixos.

## Image Repositories

Docker images are pushed to two registries:
- **Docker Hub**: `utensils/mcp-nixos`
- **GitHub Container Registry**: `ghcr.io/utensils/mcp-nixos`

## Tagging Strategy

### On Main Branch Push (Continuous)
- `latest` - Always points to the latest main branch build
- `edge` - Alternative tag for latest main branch
- `main-<short-sha>` - Specific commit reference (e.g., `main-abc1234`)

### On Pull Request
- `pr-<number>` - For testing PR builds (e.g., `pr-42`)
- Images are built but NOT pushed to registries

### On Release
- `<version>` - Full semver version (e.g., `1.0.1`)
- `<major>.<minor>` - Major.minor version (e.g., `1.0`)
- `<major>` - Major version only for stable releases (e.g., `1`)
- `latest` - Updated for stable (non-prerelease) releases

## Multi-Platform Support

All images are built for:
- `linux/amd64` (x86_64)
- `linux/arm64` (ARM64/Apple Silicon)

## Usage Examples

```bash
# Latest stable release
docker run --rm -i ghcr.io/utensils/mcp-nixos:latest

# Latest development version
docker run --rm -i ghcr.io/utensils/mcp-nixos:edge

# Specific version
docker run --rm -i ghcr.io/utensils/mcp-nixos:1.0.1

# Specific commit
docker run --rm -i ghcr.io/utensils/mcp-nixos:main-abc1234
```