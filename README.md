# Collection of Bash scripts.

## Usage of `backup_repos.sh` -

- This script creates backups of multiple Git repositories by archiving each one, including its full commit history.
- You don’t need to specify each repository, just point to the parent folder.
- The script detects all valid Git repositories automatically.
- Each backup is timestamped and processed independently.
- You can easily back up hundreds of repositories at once.
- After running, you’ll be asked whether to upload the backups to gofile.io.
    - If you choose yes, backups will be uploaded directly and not saved locally.
    - If you choose no, backups will be saved in the specified directory on your machine.

```bash
bash <(curl -s https://raw.githubusercontent.com/Karan-Frost/Bashery/refs/heads/main/backup_repos.sh) "/path/to/repos" "/path/to/backup"
```

- If you want to extract every archive in the backup folder:

```bash
for archive in /path/to/backup/*.tar.gz; do
    echo "Extracting $archive..."
    tar -xzf "$archive" -C /path/to/restore/
done
```

<hr>

## Usage of `clone_repo.sh` -

- You can clone multiple repos using the script.
- It removes the targeted directory for the repository before cloning it.

```
bash <(curl -s https://raw.githubusercontent.com/Karan-Frost/Bashery/refs/heads/main/clone_repos.sh) \
    "repo1-link.git,branch-name,repo-1-directory" \
    "repo2-link.git,branch-name,repo-2-directory"
```

- Use --shallow after bash to shallow clone every repository.

```
bash <(curl -s https://raw.githubusercontent.com/Karan-Frost/Bashery/refs/heads/main/clone_repos.sh) --shallow \
    "repo1-link.git,branch-name,repo-1-directory" \
    "repo2-link.git,branch-name,repo-2-directory"
```
