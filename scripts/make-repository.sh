#!/bin/sh
# Creates a new project repository

# Create the empty root
if [ -n "$1" ]; then
    mkdir "$1"
    cd "$1"
fi

git init
git commit --allow-empty -m "Make the root commit"
git tag root

# Add the default .gitignore
cat > .gitignore <<EOF
# Ignore derived artifacts
/bin/

# Ignore Eclipse settings
/.settings/
/.classpath
/.project
EOF

git add .gitignore
git commit -m "Configure the workspace"
# Reset .gitignore to have correct line ends (for Windows)
rm .gitignore
git reset --hard

# Provide instructions for remaining manual steps
echo
echo "Continue with the setup:"
echo "1. Prepare project skeleton."
echo "2. Run make-skeleton.sh to finish it."
echo
