# WSL Network Fixer

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![PowerShell](https://img.shields.io/badge/PowerShell-5.0%2B-blue.svg)](https://github.com/PowerShell/PowerShell)
[![WSL2](https://img.shields.io/badge/WSL-2.0%2B-green.svg)](https://docs.microsoft.com/en-us/windows/wsl/)

Fix WSL2 network connectivity issues with Windows host. Solves the common `ERR_NETWORK_ACCESS_DENIED` error when accessing WSL2 services from Windows.

## 🚀 Quick Start

1. Download the latest release
2. Run `install.bat` as Administrator
3. Restart WSL: `wsl --shutdown`
4. Access your services via `localhost`!

## 🔧 What it does

This tool configures WSL2 with `networkingMode=mirrored`, which:
- Shares the same IP address between WSL2 and Windows
- Eliminates NAT issues
- Allows `localhost` to work seamlessly
- No more port forwarding needed!

## 📋 Requirements

- Windows 10/11 with WSL2
- PowerShell 5.0 or higher
- Administrator privileges (for first-time setup)

## 🛠️ Installation

### Option 1: Automated (Recommended)
```batch
install.bat
```

### Option 2: Manual
Create/edit `%USERPROFILE%\.wslconfig`:
```ini
[wsl2]
networkingMode=mirrored
memory=4GB
processors=2
autoMemoryReclaim=gradual
sparseVhd=true
```

## 📖 Usage

After installation:
1. Restart WSL: `wsl --shutdown`
2. Start your service in WSL (e.g., `npm run dev`)
3. Access from Windows: `http://localhost:3000`

## 🐛 Troubleshooting

### Still getting ERR_NETWORK_ACCESS_DENIED?
1. Ensure WSL is updated: `wsl --update`
2. Restart Windows completely
3. Check Windows Firewall settings
4. Run `diagnose.bat` for detailed troubleshooting

### Performance Issues?
Adjust memory allocation in `.wslconfig`:
```ini
memory=8GB  # Increase if needed
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👏 Acknowledgments

- Microsoft WSL Team for the `networkingMode=mirrored` feature
- Community members who reported and helped solve network issues
- Contributors to this project

## 📊 Stats

![GitHub stars](https://img.shields.io/github/stars/oratual/WslNetworkFixer?style=social)
![GitHub forks](https://img.shields.io/github/forks/oratual/WslNetworkFixer?style=social)

---

Made with ❤️ by [Oratual](https://github.com/oratual)