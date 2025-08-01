# Xperience by Kentico Community Package Template

## Description

This is a template repository for creating Xperience by Kentico community packages. It provides a complete foundation for developing extensions and community packages for Xperience by Kentico applications.

## Template Structure

This template includes:

- **Class Library Project** (`XperienceCommunity.ExtensionTemplate`) - The main extension library containing:
  - Admin module registration and configuration
  - Client-side components (React/TypeScript)
  - Custom components and properties
  - Extension permissions and constants
  
- **UI Testing Library** (`XperienceCommunity.ExtensionTemplate.UITests`) - Automated testing framework including:
  - Base test classes and utilities
  - Web driver extensions and helpers
  - Core website testing functionality
  
- **Example Scripts** - Sample scripts for development and testing:
  - Dancing Goat initialization script for testing your extension
  - Template configuration examples

### Dependencies

- [ASP.NET Core 8.0](https://dotnet.microsoft.com/en-us/download)
- [Xperience by Kentico](https://docs.kentico.com) (latest version)
- [Node.js](https://nodejs.org/) (for client-side development)

## Getting Started

### 1. Initialize Your Extension

Use the provided PowerShell script to transform this template into your custom extension:

```powershell
.\Init-Template.ps1 -ExtensionName "YourExtensionName"
```

**Example:**
```powershell
.\Init-Template.ps1 -ExtensionName "FormNotifications"
```

This script will:
- Rename all directories and files from `XperienceCommunity.ExtensionTemplate` to `XperienceCommunity.YourExtensionName`
- Update all namespace references in code files
- Replace template placeholders with your extension name
- Update package.json and configuration files
- Clean up by removing the initialization script

### 2. Set up Development Environment

After initializing your extension:

1. **Build the solution:**
   ```bash
   dotnet build src/XperienceCommunity.YourExtensionName.sln
   ```

2. **Install client-side dependencies:**
   ```bash
   cd src/XperienceCommunity.YourExtensionName/Client
   npm install
   ```

3. **Build client assets:**
   ```bash
   npm run build
   ```

### 3. Test with Dancing Goat (Optional)

Use the provided Dancing Goat initialization script to create a test environment:

```powershell
cd example
.\Init-DancingGoat.ps1
```

This will create a Dancing Goat sample project with the latest Xperience by Kentico version that references your extension for testing purposes.

## Development Guidelines

### Project Structure

- `src/XperienceCommunity.ExtensionTemplate/` - Main extension library
  - `Client/` - TypeScript/React components and build configuration
  - `Components/` - Server-side custom components
  - `Models/` - Data models and info classes
  - `*.cs` - Core extension files (modules, permissions, etc.)

- `src/XperienceCommunity.ExtensionTemplate.UITests/` - UI testing framework
  - `Core/` - Base test classes
  - `Helpers/` - Testing utilities and extensions

### Naming Conventions

- Use PascalCase for your extension name (e.g., `FormNotifications`, `CustomAnalytics`)
- The template automatically handles namespace and file naming conversions
- Package names will follow the pattern `xperiencecommunity{extensionname}-web-admin`

### Client-Side Development

The template includes a complete webpack build setup for TypeScript and React development:

- Entry point: `Client/src/entry.tsx`
- Custom components: `Client/src/components/custom/`
- Build configuration: `Client/webpack.config.js`

## Next Steps

1. **Customize your extension** - Modify the template code to implement your specific functionality
2. **Update documentation** - Replace this README with documentation specific to your extension
3. **Set up CI/CD** - Configure build and deployment pipelines
4. **Publish to NuGet** - Package and distribute your community extension

## Contributing

This template is designed to streamline community package development for Xperience by Kentico. If you have suggestions for improvements to the template itself, please submit an issue or pull request.