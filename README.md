# goodies

New home for public scripts, utilities and apps

## Available scripts/tools/utilities

### Aadhar utility

- A CLI tool to crop and watermark Aadhar PDF files.
- script last updated on - Mar 29, 2026

``` bash
# Input: PDF file or folder path
# Output: PDF file path (optional, default: <input>.pdf)
# Search: Process only files containing this string (folder mode only)
go run ./cli/go-utils/main.go aadhar --in data/aadhar-util/input-files --out data/aadhar-util/output --search Aadhar
```

### Git repos backup

- Clone all personal and org repos
- script last updated on - Mar 29, 2026

``` bash
# command <destination-folder>
./cmd/clone-github-repos/clone.sh $HOME/dev/github-repos-backup
```

### Firefox to Google Chrome password migration

Migrate Firefox saved passwords to Google Chrome.
- script initially created on - Jan 1, 2022

``` bash
./cmd/firefox-to-gpm/main.go
```

### Open frequetly used apps in windows

- script initially created on - Apr 28, 2017

``` bash
./cmd/windows-open-apps/open_apps.py
```

### Windows clipboard manager

- A CLI tool to manage clipboard history.
- script initially created on - Apr 28, 2017

``` bash
./cmd/windows-clipboard-manager/clipboard-manager.py
```

### Two dates difference

- Calculate difference between two dates.
- script initially created on - Aug 15, 2017

``` bash
./cmd/two-dates-diff/date-diff.java
```

### SPLM

- [repo](https://github.com/IASB-archives/splm_unitscripts)
- repo last updated on - Mar 11, 2022