{ config, lib, pkgs, ... }:
let
  cfg = config.services.mcp-nixos;
  log_path = "/tmp/mcp-nixos.log";
  exec_args =
    [ (lib.getExe cfg.package) "--transport" cfg.transport ]
    ++ lib.optionals (cfg.transport != "stdio") [
      "--host"
      cfg.host
      "--port"
      (toString cfg.port)
      "--path"
      cfg.path
    ]
    ++ cfg.extraArgs;
in
{
  options.services.mcp-nixos = {
    enable = lib.mkEnableOption "MCP-NixOS server";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.mcp-nixos;
      defaultText = "pkgs.mcp-nixos";
      description = "Package providing the mcp-nixos executable.";
    };
    transport = lib.mkOption {
      type = lib.types.enum [
        "stdio"
        "http"
        "sse"
      ];
      default = "http";
      description = "Transport to serve (stdio, http, sse).";
    };
    host = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      description = "Host to bind for HTTP/SSE transports.";
    };
    port = lib.mkOption {
      type = lib.types.port;
      default = 8000;
      description = "Port to bind for HTTP/SSE transports.";
    };
    path = lib.mkOption {
      type = lib.types.str;
      default = "/mcp";
      description = "HTTP path for the MCP endpoint.";
    };
    extraArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Extra command-line arguments passed to mcp-nixos.";
    };
    environment = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {};
      description = "Environment variables passed to the service.";
    };
    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Ignored on Darwin (Linux only).";
    };
  };

  config = lib.mkIf cfg.enable {
    launchd.user.agents.mcp-nixos = {
      serviceConfig = {
        ProgramArguments = exec_args;
        KeepAlive = true;
        RunAtLoad = true;
        ProcessType = "Background";
        StandardOutPath = log_path;
        StandardErrorPath = log_path;
        EnvironmentVariables = cfg.environment;
      };
      managedBy = "services.mcp-nixos.enable";
    };
  };
}
