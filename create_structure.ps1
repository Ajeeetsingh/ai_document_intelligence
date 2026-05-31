$folders = @(
    # Root folders
    "backend",
    "frontend",
    "infra",
    "docs",
    "scripts",
    "tests",

    # Documentation structure
    "docs\adr",
    "docs\features",
    "docs\architecture",
    "docs\api",
    "docs\database",
    "docs\standards"
)

foreach ($folder in $folders) {
    New-Item -ItemType Directory -Path $folder -Force | Out-Null
}

$files = @(
    ".gitignore",
    "README.md",
    "PROJECT_STATE.md"
)

foreach ($file in $files) {
    New-Item -ItemType File -Path $file -Force | Out-Null
}

Write-Host "Project structure created successfully."