#!/bin/bash

# GitHub Repository Setup Script
# This script helps you create and initialize a new GitHub repository

# Color codes for better output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== GitHub Repository Setup Script ===${NC}"
echo ""

# Get repository name
read -p "Enter repository name: " REPO_NAME
if [ -z "$REPO_NAME" ]; then
    echo -e "${RED}Error: Repository name cannot be empty${NC}"
    exit 1
fi

# Get repository description
read -p "Enter repository description (optional): " REPO_DESC

# Ask if repo should be private
echo "Should this repository be private? (y/n)"
read -p "Default is public: " IS_PRIVATE
if [[ "$IS_PRIVATE" =~ ^[Yy]$ ]]; then
    PRIVACY_FLAG="--private"
else
    PRIVACY_FLAG="--public"
fi

# Create project directory
if [ -d "$REPO_NAME" ]; then
    echo -e "${RED}Error: Directory '$REPO_NAME' already exists${NC}"
    exit 1
fi

echo -e "\n${BLUE}Creating project directory...${NC}"
mkdir "$REPO_NAME"
cd "$REPO_NAME"

# Initialize git repository
echo -e "${BLUE}Initializing git repository...${NC}"
git init

# Create README.md
echo -e "${BLUE}Creating README.md...${NC}"
cat > README.md << EOF
# $REPO_NAME

$REPO_DESC

## Getting Started

This repository was created on $(date +"%Y-%m-%d").

## Installation

\`\`\`bash
git clone https://github.com/$(git config user.name)/$REPO_NAME.git
cd $REPO_NAME
\`\`\`

## Usage

[Add usage instructions here]

## Contributing

[Add contributing guidelines here]

## License

[Add license information here]
EOF

# Create .gitignore for C projects
echo -e "${BLUE}Creating .gitignore for C projects...${NC}"
cat > .gitignore << EOF
# Prerequisites
*.d

# Object files
*.o
*.ko
*.obj
*.elf

# Linker output
*.ilk
*.map
*.exp

# Precompiled Headers
*.gch
*.pch

# Libraries
*.lib
*.a
*.la
*.lo

# Shared objects (inc. Windows DLLs)
*.dll
*.so
*.so.*
*.dylib

# Executables
*.exe
*.out
*.app
*.i*86
*.x86_64
*.hex

# Debug files
*.dSYM/
*.su
*.idb
*.pdb

# Kernel Module Compile Results
*.mod*
*.cmd
.tmp_versions/
modules.order
Module.symvers
Mkfile.old
dkms.conf

# Editor directories and files
.vscode/
.idea/
*.swp
*.swo
*~

# OS generated files
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db
EOF

# Create initial commit
echo -e "${BLUE}Creating initial commit...${NC}"
git add .
git commit -m "Initial commit"

# Create repository on GitHub using gh CLI
echo -e "\n${BLUE}Creating repository on GitHub...${NC}"
if command -v gh &> /dev/null; then
    # Check if user is authenticated
    if gh auth status &> /dev/null; then
        if [ -n "$REPO_DESC" ]; then
            gh repo create "$REPO_NAME" $PRIVACY_FLAG --description "$REPO_DESC" --source=. --remote=origin --push
        else
            gh repo create "$REPO_NAME" $PRIVACY_FLAG --source=. --remote=origin --push
        fi
        echo -e "${GREEN}✓ Repository created successfully on GitHub!${NC}"
        echo -e "${GREEN}✓ URL: https://github.com/$(gh api user -q .login)/$REPO_NAME${NC}"
    else
        echo -e "${RED}Error: Not authenticated with GitHub CLI${NC}"
        echo "Run 'gh auth login' to authenticate"
        echo ""
        echo "Manual steps to complete setup:"
        echo "1. Create a new repository on GitHub: https://github.com/new"
        echo "2. Run these commands:"
        echo "   git remote add origin https://github.com/YOUR_USERNAME/$REPO_NAME.git"
        echo "   git branch -M main"
        echo "   git push -u origin main"
    fi
else
    echo -e "${RED}GitHub CLI (gh) is not installed${NC}"
    echo ""
    echo "To install GitHub CLI:"
    echo "- macOS: brew install gh"
    echo "- Ubuntu/Debian: sudo apt install gh"
    echo "- Windows: winget install --id GitHub.cli"
    echo ""
    echo "Manual steps to complete setup:"
    echo "1. Create a new repository on GitHub: https://github.com/new"
    echo "2. Run these commands:"
    echo "   git remote add origin https://github.com/YOUR_USERNAME/$REPO_NAME.git"
    echo "   git branch -M main"
    echo "   git push -u origin main"
fi

echo -e "\n${GREEN}✓ Local repository setup complete!${NC}"
echo -e "${BLUE}Repository location: $(pwd)${NC}"
