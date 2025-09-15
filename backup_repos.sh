#!/bin/bash

REPO_DIR="$1"
BACKUP_DIR="$2"

# Validate the parsed values.
if [ -z "$REPO_DIR" ] || [ -z "$BACKUP_DIR" ]; then
    echo "Usage:"
    echo "  bash <(curl -s https://raw.githubusercontent.com/Karan-Frost/Bashery/refs/heads/main/backup_repos.sh) \\"
    echo "      \"/path/to/repos\" \"/path/to/backup\""
    exit 1
fi

mkdir -p "$BACKUP_DIR"

TIMESTAMP=$(date "+%Y%m%d_%H%M%S")

echo "Starting backup at $(date)"
echo "Repositories folder: $REPO_DIR"
echo "Backup directory: $BACKUP_DIR"

# Ask the user whether to upload or not
while true; do
    read -p "Do you want to upload backups to gofile.io? (yes/no): " UPLOAD_CHOICE
    case "$UPLOAD_CHOICE" in
        yes|y|Y )
            UPLOAD="yes"
            echo "Backups will be uploaded and not saved locally."
            break
            ;;
        no|n|N )
            UPLOAD="no"
            echo "Backups will be saved locally in $BACKUP_DIR."
            break
            ;;
        * )
            echo "Please answer yes or no."
            ;;
    esac
done

for repo in "$REPO_DIR"/*; do
    if [ -d "$repo/.git" ]; then
        NAME=$(basename "$repo")
        
        # Use temporary location if uploading, permanent if saving locally
        if [ "$UPLOAD" == "yes" ]; then
            ARCHIVE="$(mktemp --suffix=._${NAME}_$TIMESTAMP.tar.gz)"
        else
            ARCHIVE="$BACKUP_DIR/${NAME}_$TIMESTAMP.tar.gz"
        fi

        echo "Backing up $NAME..."
        tar -czf "$ARCHIVE" -C "$REPO_DIR" "$NAME"

        if [ $? -eq 0 ]; then
            echo "Successfully backed up $NAME"
        else
            echo "Failed to back up $NAME"
            [ "$UPLOAD" == "yes" ] && rm -f "$ARCHIVE"
            continue
        fi

        if [ "$UPLOAD" == "yes" ]; then
            echo "Uploading $NAME to gofile.io..."

            SERVER=$(curl -s -X GET 'https://api.gofile.io/servers' | grep -Po '(store[^"]*)' | tail -n 1)
            if [ -z "$SERVER" ]; then
                echo "Failed to retrieve upload server."
                rm -f "$ARCHIVE"
                continue
            fi

            RESPONSE=$(curl -s -X POST "https://${SERVER}.gofile.io/contents/uploadfile" -F "file=@$ARCHIVE")
            HASH=$(echo "$RESPONSE" | grep -Po '(https://gofile.io/d/)[^"]*')

            if [ -n "$HASH" ]; then
                echo "Upload successful: $HASH"
            else
                echo "Upload failed. Response:"
                echo "$RESPONSE"
            fi

            # Remove the temporary archive after uploading
            rm -f "$ARCHIVE"
        fi

    else
        echo "Skipping $repo (not a Git repository)"
    fi
done

echo "Backup process completed at $(date)"
