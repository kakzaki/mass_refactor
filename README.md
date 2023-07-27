# Mass Refactor

A Command-Line Interface (CLI) tool for performing mass refactoring of files and folders.

## Overview

Mass Refactor is a powerful tool that helps you quickly and efficiently perform mass renaming of files and folders inside a target directory and its subdirectories. It uses command-line arguments to specify the target directory and the keyword replacements to be performed, making it suitable for batch refactoring tasks.

## Use Case

Imagine you have a project with hundreds of files and folders, and you need to update a specific keyword throughout the project. Manually renaming each file and folder can be time-consuming and error-prone. With Mass Refactor, you can easily automate this process by providing the target directory and the keyword replacements as command-line arguments.

## Features

- Replace keywords in file and folder names.
- Update keyword occurrences inside file contents.
- Case-sensitive or case-insensitive keyword replacements.
- Recursively traverse subdirectories for refactoring.

## Installation

To use Mass Refactor, you need to have Dart SDK installed on your machine. If you don't have it yet, you can download it from the [Dart website](https://dart.dev/get-dart).

Once you have Dart installed, you can install Mass Refactor globally by running:

```bash
dart pub global activate mass_refactor
```

Make sure that the Dart SDK's `bin` directory (e.g., `~/.pub-cache/bin` on Linux/macOS) is added to your system's PATH variable.

## Usage

```bash
mass_refactor -d <directory> -r <keyword replacements>
```

Replace `<directory>` with the path to the target directory you want to refactor. Use the `-r` option to specify the keyword replacements. Separate multiple keyword pairs with spaces. Each keyword pair should be in the format `keyword:replacement`.

### Examples

```bash
# Rename files and folders in the "project" directory, replacing "Brand" with "Category".
mass_refactor -d project -r Brand:Category

# Refactor the "src" directory, replacing both "Color" and "Size" with "Theme".
mass_refactor -d src -r Color:Theme Size:Theme
```

## Command-Line Options

- `-d, --directory`: The target directory for mass refactoring.
- `-r, --replace`: The keyword replacements. Specify one or more keyword pairs (e.g., `keyword:replacement`).

## Important Notes

- Make sure to create a backup of your data before using Mass Refactor, especially on important directories.
- Use caution while performing mass refactoring operations, as they can't be undone.

## Contributing

Contributions are welcome! If you find any issues or have suggestions for improvements, please feel free to [open an issue](https://github.com/kakzaki/mass_refactor/issues) or submit a pull request.

## License

This project is licensed under the [MIT License](LICENSE).

---

If you have any questions or need further assistance, please don't hesitate to contact us at support@example.com.

Happy refactoring with Mass Refactor! 🚀
```
