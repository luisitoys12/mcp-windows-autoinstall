#Requires -RunAsAdministrator

<#
.SYNOPSIS
    Instalador automatizado de Claude Desktop + Gemini CLI + MCP Servers para Windows
.DESCRIPTION
    Descarga, instala y configura todo lo necesario para que Claude y Gemini
    puedan controlar tu PC Windows desde el primer momento.
.PARAMETER SkipClaude
    Omite la instalación de Claude Desktop
.PARAMETER SkipGemini
    Omite la instalación de Gemini CLI
.PARAMETER SkipMCPServers
    Omite la instalación de MCP Servers
.EXAMPLE
    .\install.ps1
    Instala todo (Claude, Gemini y MCP Servers)
.EXAMPLE
    .\install.ps1 -SkipGemini
    Instala solo Claude Desktop y MCP Servers
.NOTES
    Versión: 1.0.0
    Autor: Luis Martinez Sandoval - EstacionKusMedias
    Requiere: PowerShell 5.1+ y permisos de administrador
    Windows: 10/11 o Server 2016+
#>

[CmdletBinding()]
param(
    [switch]$SkipClaude,
    [switch]$SkipGemini,
    [switch]$SkipMCPServers
)

Set-ExecutionPolicy Bypass -Scope Process -Force

$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"

# Banner
Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "   MCP Windows AI Control Installer    " -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "  Instalador automático para Windows   " -ForegroundColor White
Write-Host "  Claude Desktop + Gemini CLI + MCP    " -ForegroundColor White
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Creado por: Luis Martinez Sandoval" -ForegroundColor Gray
Write-Host "Organización: EstacionKusMedias" -ForegroundColor Gray
Write-Host "GitHub: github.com/luisitoys12" -ForegroundColor Gray
Write-Host "" 

# Verificar que se está ejecutando como administrador
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "❌ Error: Este script requiere permisos de administrador" -ForegroundColor Red
    Write-Host "Por favor, ejecuta PowerShell como administrador e intenta de nuevo." -ForegroundColor Yellow
    exit 1
}

Write-Host "✅ Ejecutando con permisos de administrador" -ForegroundColor Green
Write-Host ""

try {
    # 1. Instalar Node.js si no existe
    Write-Host "[1/5] Verificando Node.js..." -ForegroundColor Yellow
    if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
        Write-Host "  📦 Instalando Node.js LTS..." -ForegroundColor Green
        & .\scripts\install-nodejs.ps1
        Write-Host "  ✅ Node.js instalado correctamente" -ForegroundColor Green
    } else {
        $nodeVersion = node --version
        Write-Host "  ✅ Node.js ya instalado: $nodeVersion" -ForegroundColor Green
    }
    Write-Host ""

    # 2. Instalar Claude Desktop
    if (-not $SkipClaude) {
        Write-Host "[2/5] Instalando Claude Desktop..." -ForegroundColor Yellow
        & .\scripts\install-claude-desktop.ps1
        Write-Host "  ✅ Claude Desktop instalado" -ForegroundColor Green
        Write-Host ""
    } else {
        Write-Host "[2/5] ⏭️  Omitiendo Claude Desktop" -ForegroundColor Gray
        Write-Host ""
    }

    # 3. Instalar Gemini CLI
    if (-not $SkipGemini) {
        Write-Host "[3/5] Instalando Gemini CLI..." -ForegroundColor Yellow
        & .\scripts\install-gemini-cli.ps1
        Write-Host "  ✅ Gemini CLI instalado" -ForegroundColor Green
        Write-Host ""
    } else {
        Write-Host "[3/5] ⏭️  Omitiendo Gemini CLI" -ForegroundColor Gray
        Write-Host ""
    }

    # 4. Instalar y configurar MCP Servers
    if (-not $SkipMCPServers) {
        Write-Host "[4/5] Configurando MCP Servers..." -ForegroundColor Yellow
        & .\scripts\setup-mcp-servers.ps1
        Write-Host "  ✅ MCP Servers configurados" -ForegroundColor Green
        Write-Host ""
    } else {
        Write-Host "[4/5] ⏭️  Omitiendo MCP Servers" -ForegroundColor Gray
        Write-Host ""
    }

    # 5. Configurar clientes (Claude Desktop + Gemini CLI)
    Write-Host "[5/5] Aplicando configuraciones..." -ForegroundColor Yellow
    & .\scripts\configure-clients.ps1 -SkipClaude:$SkipClaude -SkipGemini:$SkipGemini
    Write-Host "  ✅ Configuraciones aplicadas" -ForegroundColor Green
    Write-Host ""

    # Success!
    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "   ✅ Instalación completada!          " -ForegroundColor Green
    Write-Host "=========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "📋 Próximos pasos:" -ForegroundColor Cyan
    Write-Host ""
    
    if (-not $SkipClaude) {
        Write-Host "  1. Reinicia Claude Desktop" -ForegroundColor White
        Write-Host "     Los MCP servers estarán disponibles automáticamente" -ForegroundColor Gray
        Write-Host ""
    }
    
    if (-not $SkipGemini) {
        Write-Host "  2. Autentícate en Gemini CLI:" -ForegroundColor White
        Write-Host "     gcli auth" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "  3. Inicia una conversación:" -ForegroundColor White
        Write-Host "     gcli chat" -ForegroundColor Yellow
        Write-Host ""
    }
    
    Write-Host "🎯 Prueba esto:" -ForegroundColor Cyan
    Write-Host "  'Abre el Bloc de notas y escribe Hola Mundo'" -ForegroundColor White
    Write-Host "  'Crea una carpeta C:\temp\prueba-mcp con un archivo test.txt'" -ForegroundColor White
    Write-Host "  'Lista los archivos en mi carpeta de Documentos'" -ForegroundColor White
    Write-Host ""
    Write-Host "📚 Documentación completa:" -ForegroundColor Cyan
    Write-Host "  https://github.com/luisitoys12/mcp-windows-autoinstall" -ForegroundColor Blue
    Write-Host ""
    Write-Host "¡Gracias por usar MCP Windows AI Control!" -ForegroundColor Green
    Write-Host "Creado con ❤️  por EstacionKusMedias" -ForegroundColor Magenta
    Write-Host ""

} catch {
    Write-Host ""
    Write-Host "❌ Error durante la instalación:" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    Write-Host ""
    Write-Host "Por favor, revisa el error y vuelve a intentarlo." -ForegroundColor Yellow
    Write-Host "Si el problema persiste, abre un issue en:" -ForegroundColor Yellow
    Write-Host "https://github.com/luisitoys12/mcp-windows-autoinstall/issues" -ForegroundColor Blue
    Write-Host ""
    exit 1
}