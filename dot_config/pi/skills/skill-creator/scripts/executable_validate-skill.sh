#!/usr/bin/env bash
#
# validate-skill.sh - Validate a skill directory structure and SKILL.md
#
# Usage: validate-skill.sh <skill-directory>
#

set -euo pipefail

red='\033[0;31m'
green='\033[0;32m'
nc='\033[0m' # No color

error() {
    echo -e "${red}Error:${nc} $1" >&2
    exit 1
}

success() {
    echo -e "${green}Valid:${nc} $1"
}

# Check arguments
if [[ $# -ne 1 ]]; then
    echo "Usage: validate-skill.sh <skill-directory>"
    exit 1
fi

skill_dir="$1"

# Check directory exists
if [[ ! -d "$skill_dir" ]]; then
    error "Directory not found: $skill_dir"
fi

# Check SKILL.md exists
skill_md="$skill_dir/SKILL.md"
if [[ ! -f "$skill_md" ]]; then
    error "SKILL.md not found in $skill_dir"
fi

# Read the file
content=$(cat "$skill_md")

# Check frontmatter exists
if [[ ! "$content" =~ ^--- ]]; then
    error "No YAML frontmatter found (file must start with ---)"
fi

# Extract frontmatter (between first --- and second ---)
frontmatter=$(echo "$content" | sed -n '/^---$/,/^---$/p' | sed '1d;$d')

if [[ -z "$frontmatter" ]]; then
    error "Invalid frontmatter format (missing closing ---)"
fi

# Extract name field
name=$(echo "$frontmatter" | grep -E '^name:' | head -1 | sed 's/^name:[[:space:]]*//' | tr -d '"'"'")

if [[ -z "$name" ]]; then
    error "Missing 'name' in frontmatter"
fi

# Validate name format: lowercase alphanumeric with single hyphens
if [[ ! "$name" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]; then
    error "Invalid name '$name': must be lowercase alphanumeric with single hyphen separators (e.g., 'my-skill')"
fi

# Validate name length
if [[ ${#name} -gt 64 ]]; then
    error "Name is too long (${#name} characters). Maximum is 64 characters."
fi

# Check name matches directory name
dir_name=$(basename "$skill_dir")
if [[ "$name" != "$dir_name" ]]; then
    error "Name '$name' does not match directory name '$dir_name'"
fi

# Extract description field (handles multi-line with >- or | or quoted strings)
# First try simple single-line format
description=$(echo "$frontmatter" | grep -E '^description:' | head -1 | sed 's/^description:[[:space:]]*//' | tr -d '"'"'")

# If description looks like a YAML block indicator, extract the block
if [[ "$description" =~ ^[\>\|] ]] || [[ -z "$description" ]]; then
    # Try to get multi-line description
    description=$(echo "$frontmatter" | sed -n '/^description:/,/^[a-z]/p' | tail -n +2 | grep -v '^[a-z]' | sed 's/^[[:space:]]*//' | tr '\n' ' ' | sed 's/[[:space:]]*$//')
fi

if [[ -z "$description" ]]; then
    error "Missing 'description' in frontmatter"
fi

# Validate description length
if [[ ${#description} -gt 1024 ]]; then
    error "Description is too long (${#description} characters). Maximum is 1024 characters."
fi

# Check for angle brackets in description
if echo "$description" | grep -q '[<>]'; then
    error "Description cannot contain angle brackets (< or >)"
fi

# Check for disallowed frontmatter fields
allowed_fields="name|description|license|compatibility|metadata"
unknown_fields=$(echo "$frontmatter" | grep -E '^[a-z-]+:' | sed 's/:.*//' | grep -Ev "^($allowed_fields)$" || true)

if [[ -n "$unknown_fields" ]]; then
    error "Unknown frontmatter field(s): $(echo $unknown_fields | tr '\n' ', ' | sed 's/,$//'). Allowed: name, description, license, compatibility, metadata"
fi

success "Skill '$name' is valid!"
echo "  Name: $name"
echo "  Description: ${description:0:80}$([ ${#description} -gt 80 ] && echo '...')"
