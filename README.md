# Collection of Bash scripts.

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
