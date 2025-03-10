#!/bin/bash
set -e

# Fetch all tags from the repository
git fetch --tags

# Get the latest tag (assumes semantic version tags like vX.Y.Z or X.Y.Z)
latest_tag=$(git tag --sort=-v:refname | head -n 1)

# If no tags exist, start with 0.0.0
if [ -z "$latest_tag" ]; then
  latest_version="0.0.0"
else
  # Strip 'v' prefix if present (e.g., v1.2.3 -> 1.2.3)
  latest_version="${latest_tag#v}"
fi

# Split version into parts
IFS='.' read -r major minor patch <<< "$latest_version"

# Determine which part to increment (default to patch)
commit_msg="${GITHUB_COMMIT_MSG:-${{ github.event.head_commit.message }}}"  # uses commit message if provided
increment="patch"
if echo "$commit_msg" | grep -qi '\[M\]'; then
  increment="major"
elif echo "$commit_msg" | grep -qi '\[m\]'; then
  increment="minor"
elif echo "$commit_msg" | grep -qi '\[p\]'; then
  increment="patch"
fi

# Bump the version number based on increment
case "$increment" in
  major)
    major=$((major + 1))
    minor=0
    patch=0
    ;;
  minor)
    minor=$((minor + 1))
    patch=0
    ;;
  patch)
    patch=$((patch + 1))
    ;;
esac

new_version="$major.$minor.$patch"
new_tag="v$new_version"

echo "Current version: $latest_version"
echo "Increment type: $increment"
echo "New version: $new_version"

# Create a new git tag for the new version
git config user.name "github-actions"
git config user.email "[email protected]"
git tag -a "$new_tag" -m "Release $new_tag"

# (Optional) Push the new tag to the repository
git push origin "$new_tag"

# Output the new version for use in GitHub Actions
# Using the special GITHUB_OUTPUT environment file to set an output variable
echo "new_version=$new_version" >> "$GITHUB_OUTPUT"
