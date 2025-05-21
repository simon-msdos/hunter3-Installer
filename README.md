# hunter3-Installer
# Hunter3 Ninja Auto Installer

This script (`hnt3.sh`) automates the installation and uninstallation of all major reconnaissance and security tools needed for [https://hunter3.ninja/](https://hunter3.ninja/).

```sh
bash <(curl -sSL https://raw.githubusercontent.com/simon-msdos/hunter3-Installer/main/hnt3.sh)
```

---

## Features

- **Automated install/uninstall** of all required tools for Hunter3 Ninja
- **Animated progress bar** for each tool
- **Menu-driven interface**: install/uninstall all or selected tools
- **Dependency checks** and auto-install for system requirements
- **Fallback build from source** for `masscan` if not available via apt
- **Robust uninstall logic** (skips core system packages)
- **Clear, color-coded output and logging**

---

## Usage

### 1. Make the script executable

```sh
chmod +x hnt3.sh
```

### 2. Run the script

```sh
./hnt3.sh
```

> **Note:** You may need to run as root or with `sudo` for installing system packages.

---

## Menu Options

- **1) Install all tools**  
  Installs every tool required for Hunter3 Ninja.

- **2) Install selected tools**  
  Lets you pick which tools to install.

- **3) Uninstall all tools**  
  Removes all tools (except core system packages).

- **4) Uninstall selected tools**  
  Lets you pick which tools to uninstall.

- **5) Exit**  
  Quits the script.

---

## Tools Installed

- **System/Language:** `git`, `make`, `python3`, `python3-pip`, `ruby`, `curl`, `golang`
- **Recon/Scan:** `nmap`, `masscan`, `subfinder`, `httpx`, `subzy`, `naabu`, `katana`, `gau`, `gf`, `Gxss`, `kxss`, `dalfox`, `nuclei`, `ffuf`, `qsreplace`, `assetfinder`, `httprobe`
- **Python:** `uro`, `arjun`, `CORScanner`
- **Ruby:** `wpscan`
- **Go:** `s3scanner`

---

## Log File

All output and errors are logged to:

```
/tmp/hunter3_tools_install.log
```

---

## Notes

- For Go tools, ensure `/usr/local/go/bin` and `$HOME/go/bin` are in your `PATH`.
- The script will **not uninstall core system packages** (like `python3`, `git`, etc.).
- If a tool is not available via apt, the script will attempt to build it from source (e.g., `masscan`).

---

## License

MIT

---

**Created by Simon — [SIMON - SOMOYAMO](https://dev.somoyamo.com)**
