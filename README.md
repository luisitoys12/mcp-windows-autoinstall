# 🤖 MCP Windows AI Control - Instalador Automático

**Convierte tu Windows Server en una PC controlable por IA en 5 minutos.**

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Windows](https://img.shields.io/badge/platform-Windows%2010%2F11%20%7C%20Server-blue)
![PowerShell](https://img.shields.io/badge/PowerShell-5.1%2B-blue)

Este repositorio instala y configura automáticamente:
- ✅ **Claude Desktop** con MCP servers integrados
- ✅ **Gemini CLI** con MCP servers integrados  
- ✅ **Servidores MCP** para control total de Windows (PowerShell, UI automation, build tools)

## 🎯 ¿Qué podrás hacer?

Después de ejecutar el instalador, Claude y Gemini podrán:

### 💻 Control de Windows
- Abrir cualquier programa instalado
- Ejecutar comandos PowerShell/CMD
- Crear, editar, mover, copiar archivos
- Navegar por carpetas
- Instalar software vía winget/chocolatey

### 🔨 Desarrollo y Build
- Compilar proyectos Android (generar APK)
- Ejecutar scripts de build (.NET, Node.js, Python, etc.)
- Editar código fuente
- Gestionar repositorios Git
- Ejecutar pruebas automatizadas

### 🖱️ Automatización UI
- Hacer clicks en ventanas específicas
- Escribir texto en aplicaciones
- Leer contenido de pantalla
- Interactuar con diálogos y menús
- Controlar aplicaciones sin API

## 🚀 Instalación Rápida

### Requisitos
- Windows 10/11 o Windows Server 2016+
- PowerShell 5.1 o superior
- Permisos de administrador
- Conexión a Internet
- 2 GB de espacio libre

### Paso 1: Clonar el repositorio
```powershell
git clone https://github.com/luisitoys12/mcp-windows-autoinstall.git
cd mcp-windows-autoinstall
```

### Paso 2: Ejecutar instalador
```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
.\install.ps1
```

### Paso 3: Autenticar Gemini CLI (opcional)
Si instalaste Gemini CLI:
```powershell
gcli auth
```

¡Listo! Ahora reinicia Claude Desktop y/o ejecuta `gcli chat` para empezar.

## 📋 Lo que instala el script

1. **Node.js LTS** (si no está instalado)
2. **Claude Desktop** (última versión)
3. **Gemini CLI** (vía npm)
4. **MCP Servers**:
   - `powershell-mcp`: Ejecuta comandos PowerShell
   - `windows-automation`: Control de UI (clicks, typing, etc.)
   - `android-builder`: Compilación de proyectos Android
5. **Configuraciones automáticas** para ambos clientes

## 🎯 Ejemplos de Uso

### Con Claude Desktop

1. Abre Claude Desktop
2. Prueba estos prompts:

```
"Abre el Bloc de notas y escribe: Hola desde Claude con MCP"

"Crea una carpeta en C:\temp\prueba-mcp con un archivo test.txt que diga 'Funciona!'"

"Lista todos los archivos .txt en mi carpeta de Documentos"

"Abre Visual Studio Code en la carpeta C:\proyectos"
```

### Con Gemini CLI

```powershell
gcli chat
```

Luego prueba:

```
> Crea un proyecto de ejemplo en C:\temp\app-prueba con un index.html básico

> Ejecuta 'git status' en mi carpeta actual

> Instala Google Chrome usando winget

> Compila el proyecto Android en C:\android\MiApp y genera el APK
```

### Para desarrollo Android

Si tienes Android Studio instalado:

```
"Compila el proyecto en C:\android\MiAppPrueba en modo debug y dime dónde está el APK"

"Crea un nuevo proyecto Android básico en C:\android\HolaMundo con MainActivity"
```

## 🛠️ Personalización

### Agregar más MCP servers

1. Edita `scripts/setup-mcp-servers.ps1`
2. Agrega la instalación de tu servidor:

```powershell
Write-Host "  Instalando Mi Custom MCP..."
if (-not (Test-Path .\mi-custom-mcp)) {
    git clone https://github.com/usuario/mi-custom-mcp.git
}
Set-Location mi-custom-mcp
npm install
npm run build
Set-Location ..
```

3. Edita `scripts/configure-clients.ps1` y agrega la configuración:

```powershell
miCustomMcp = @{
    command = "node"
    args = @("$PSScriptRoot\..\mcp-servers\mi-custom-mcp\build\index.js")
}
```

### Instalar solo componentes específicos

```powershell
# Solo Claude (sin Gemini)
.\install.ps1 -SkipGemini

# Solo Gemini (sin Claude)
.\install.ps1 -SkipClaude

# Solo instalar Node.js y MCP servers
.\install.ps1 -SkipClaude -SkipGemini
```

## 📂 Estructura del Proyecto

```
mcp-windows-autoinstall/
├── README.md                      # Este archivo
├── LICENSE                        # Licencia MIT
├── install.ps1                    # Script principal de instalación
├── scripts/
│   ├── install-nodejs.ps1         # Instalador de Node.js
│   ├── install-claude-desktop.ps1 # Instalador de Claude Desktop
│   ├── install-gemini-cli.ps1     # Instalador de Gemini CLI
│   ├── setup-mcp-servers.ps1      # Configuración de MCP servers
│   └── configure-clients.ps1      # Configuración de clientes
├── mcp-servers/
│   ├── powershell-mcp/            # PowerShell MCP (clonado)
│   ├── windows-automation/        # Windows Automation MCP (clonado)
│   └── android-builder/           # Android Builder MCP (custom)
├── configs/
│   ├── claude_desktop_config.json # Plantilla de config Claude
│   └── gemini_settings.json       # Plantilla de config Gemini
└── docs/
    ├── usage-examples.md          # Más ejemplos de uso
    ├── troubleshooting.md         # Solución de problemas
    └── custom-mcp-guide.md        # Guía para crear tus propios MCP
```

## 🐛 Solución de Problemas

### Claude Desktop no muestra los MCP servers

1. Verifica que el archivo de configuración existe:
   ```powershell
   Test-Path "$env:APPDATA\Claude\claude_desktop_config.json"
   ```

2. Reinicia Claude Desktop completamente

3. Revisa los logs en `%APPDATA%\Claude\logs`

### Gemini CLI no encuentra los MCP servers

1. Verifica la configuración:
   ```powershell
   Get-Content "$env:USERPROFILE\.gemini\settings.json"
   ```

2. Ejecuta `gcli config` para ver la configuración actual

### Errores de permisos de PowerShell

Ejecuta como administrador:
```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Node.js no se encuentra después de instalar

Cierra y vuelve a abrir PowerShell, o ejecuta:
```powershell
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
```

## 📚 Recursos Adicionales

- [Documentación oficial de MCP](https://modelcontextprotocol.io/)
- [Claude Desktop MCP Guide](https://support.claude.com/articles/10949351)
- [Gemini CLI Documentation](https://geminicli.com/docs/)
- [PowerShell MCP Server](https://github.com/gunjanjp/powershell-mcp)
- [Windows Desktop Automation MCP](https://github.com/mario-andreschak/mcp-windows-desktop-automation)

## 🤝 Contribuciones

¡Las contribuciones son bienvenidas! Si tienes ideas para mejorar el instalador o agregar más MCP servers útiles:

1. Haz fork del repositorio
2. Crea una rama para tu feature (`git checkout -b feature/nueva-funcionalidad`)
3. Haz commit de tus cambios (`git commit -am 'Agrega nueva funcionalidad'`)
4. Push a la rama (`git push origin feature/nueva-funcionalidad`)
5. Abre un Pull Request

## 📄 Licencia

MIT License - Ver [LICENSE](LICENSE) para más detalles.

## 🙏 Créditos

Creado por [Luis Martinez Sandoval](https://github.com/luisitoys12) para **EstacionKusMedias**.

Proyectos MCP utilizados:
- [PowerShell MCP](https://github.com/gunjanjp/powershell-mcp) por gunjanjp
- [Windows Desktop Automation](https://github.com/mario-andreschak/mcp-windows-desktop-automation) por mario-andreschak
- [MCP Protocol](https://modelcontextprotocol.io/) por Anthropic

## 🌟 ¿Te resultó útil?

Si este proyecto te ayudó, considera:
- ⭐ Darle una estrella al repositorio
- 🐛 Reportar bugs o sugerir mejoras
- 📢 Compartirlo con otros desarrolladores
- ☕ [Apoyar el proyecto](https://estacionkusmedios.org)

---

**Made with ❤️ in Irapuato, México** 🇲🇽