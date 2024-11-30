# Markdown Image Revamp (`md-img-revamp`)

Personally, when I upload my articles to the blog, I first edit and take notes in Obsidian. Then, when I copy the article content (which is in Obsidian) to upload it to the blog, the image formatting isn't correct. That's why I've decided to create this script to automate the process of adjusting the image format from Obsidian to the one required for the blog.

**`md-img-revamp`** is a Bash script designed to **rename and optimize image references** in Markdown files. It simplifies image management in your projects by standardizing their names and automatically updating the paths within the Markdown file.

## Features

- **Automatic Image Detection**: Scans the Markdown file and lists all image references.
- **Smart Image Renaming**: Renames images by replacing spaces and special characters with hyphens to maintain a clean and consistent naming convention.
- **Markdown Path Update**: Automatically updates image paths within the Markdown file to reflect the new file names and locations.
- **Custom Paths**: Allows users to specify custom directories for renaming images.
- **Interactive User Prompts**: The script interacts with the user to confirm actions before proceeding.

## Requirements

- Bash (Linux or macOS compatible)
- Permissions to execute the script: `chmod +x md-img-revamp`

## Usage

```bash
./md-img-revamp file.md [image_path] [rename_path]
```

- `file.md`: The Markdown file containing image references.
- `[image_path]` (optional): Path where the renamed images should be stored (default /assets/img/).
- `[rename_path]` (optional): Path where the image files to rename are located (defaults to the current directory).

## Example

1. Input Markdown file (`document.md`):

```markdown
![[Image 1.jpg]]
![[Image 2.jpg]]
```

2. Running the script:

```bash
./md-img-revamp document.md /assets/img ./assets/img/
```

3. What happens:

- The script removes the "\[" and "]" at the beginning and end to ensure the proper format.
- The script appends the corresponding image path at the end of the line.
- The script will rename the image files, replacing spaces with hyphens.
- The Markdown file will be updated with the new file names and paths.

For example:

- `pretty photo.jpg` will be renamed to `pretty-photo.jpg`.
- The path will be updated to `![Image 1](/assets/img/pretty-photo.jpg)`.

## How It Works

1. File Validation: The script checks if the Markdown file and image directories exist.
2. Image Extraction: It identifies images in the Markdown file and lists them.
3. Interactive Prompt: You can confirm if you want to rename the images.
4. File Renaming: Renames image files in the specified directory by replacing spaces with hyphens.
5. Markdown Update: Updates image references in the Markdown file with the new paths.
