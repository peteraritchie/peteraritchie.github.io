---
layout: post
title: 'A tool to help contributing to many Git repos'
categories: ['Git']
comments: true
excerpt: I contribute to a variety of Git repos.  When I re-start work (or maybe I'm coming off a vacation), going to each repo dir to perform git fetch is tedious. I've developed a Powershell script to do that.
tags: ['October 2023', 'Git']
---
![Source code from many sources](../assets/contributing-to-many-git-repos.jpg)

I've contributed to many Git repos over the years. Doing this means I work in a code base for a little while, switch to another, and often eventually switch back.

## Collaborating with Others

In the repos that I work in, many have multiple contributors. The contributions to those repos can be prolific, and if the repo is using a workflow that uses feature or topic branches, branches come and go quite often. `git fetch` by default (or with no other options) gets all branches so you'll have other team members' branches after a fetch--which can be used to do a deep dive on a PR.

|You could choose not to use the `git fetch` defaults and have it only get a particular branch. This can typically be done with `git fetch origin main` (depending on how you've named your remotes and your branches.) | 
|-|

I work with many organizations and rarely is there one repo (yes, I know, there's this thing called a "monorepo"; but I find that organizations that can make this work need to be very technically savy, with products/technologies geared towards developers, and only a few of the organizations I work with are at that level.) With remote work being what it is (I'm often working at a different time than other contributors), when I return to work with an organization's code, I usually need to update several repos.

|Why not do a `git pull` instead of `git fetch`?|
|:-:|
What I'm contributing to, what I may be reviewing, and whether I'm connected, are variable enough that I've built a habit only to pull when I'm ready to merge and deal with potential conflicts. If I have conflicts, I must resolve them (or abort: `git merge --abort` or `git fetch origin` and `git reset --hard origin`) before doing anything else. This means I must commit to resolving those conflicts before switching to another branch to review or work with it. (Yes, I could re-clone in a different place, but frequent-fetch>abort>clone in terms of effort and risk.)}

# A tool to help

When I re-start work (or maybe I'm coming off a vacation), going to each repo dir to perform `git fetch` is tedious. I've developed a Powershell script to do that. I'll walk through the script after the code (commented code available [here](https://github.com/peteraritchie/pri.powershell/blob/main/git/fetch-all.ps1).)

```powershell
using namespace System.IO;
param (
    [switch]$WhatIf,
    [switch]$Verbose,
    [switch]$Quiet
    )
$currentDir = (get-location).Path;

if($Verbose.IsPresent) {
    $VerbosePreference = "Continue";
}

function Build-Command {
    $expression = 'git fetch';
    if($Quiet.IsPresent) {
        $expression += ' -q';
    }
    if($Verbose.IsPresent) {
        $expression += ' -v --progress';
    }
    if($WhatIf.IsPresent) {
        $expression += ' --dry-run';
    }
    $expression += " origin";
    return $expression;
}

foreach($item in $([Directory]::GetDirectories($currentDir, '.git', [SearchOption]::AllDirectories);)) {
    $dir = get-item -Force $item;
    Push-Location $dir.Parent;
    try {
        Write-Verbose "fetching in $((Get-Location).Path)...";
        $expression = Build-Command;

        Invoke-expression $expression;

    } finally {
        Pop-Location;
    }
}
```

First, I'm translating the PowerShell idioms `WhatIf`, `Verbose`, and `Quiet` to common Git options `--dry-run`, `--verbose` (`-v`), and `--quiet` (`-q`). The `Build-Command` builds up the expression we want to use to invoke git. I've included the `--progress` option with `git fetch` to display progress when`-Verbose` is specified. Next, I'm looping through all directories, looking for a `.git` directory. I'm using `System.IO.GetDirectories` instead of `Get-ChildItem` because it's much faster. For each directory that contains a `.git` subdirectory, Git `fetch` is invoked. This allows me to fetch several Git repos within the hierarchy of the current directory.

|Organizaing Code Locally|
|:-:|
|I work with my code (spikes, libraries, experiments, etc.), open-source projects, and multiple clients. All these diverge from one another at one level in my directory structure. e.g. I may have a `src` subdiretory in my home directory; and `oss`, `experiments`, and `client` subdirectories within `src`, so I can choose to fetch from all the repos recursively in each of those subdirectories--if I'm returning to work on an OSS project after being away from OSS for a while, I just `fetch-all.ps` within the `oss` subdirectory.|

By default (or with no other options), `git fetch` does not delete corresponding local branches that have been removed from a remote. So, new branches will be downloaded, but those that were removed will remain.

|To also remove local branches removed from the remote, you can include a purge option with `git fetch`: `git fetch --prune` or `git fetch -p`.|
|-|

If I'm reviewing a PR, I don't necessarily want removed remote branches to be removed locally _all the time_. So, I like pruning separately from fetching. The following is the script for that (other than Build-Command, it has the same structure and flow as `fetch-all.ps1` (so I won't walk through this snippet.)

```PowerShell
using namespace System.IO;
param (
    [switch]$WhatIf,
    [switch]$Verbose
    )
$currentDir = (get-location).Path;

if($Verbose.IsPresent) {
    $VerbosePreference = "Continue";
}

function Build-Command {
    $expression = 'git remote';
    if($Verbose.IsPresent) {
        $expression += ' -v';
    }
    $expression += ' prune';
    if($WhatIf.IsPresent) {
        $expression += ' --dry-run';
    }
    $expression += ' origin';
    return $expression;
}

foreach($item in $([Directory]::GetDirectories($currentDir, '.git', [SearchOption]::AllDirectories);)) {
    $dir = get-item -Force $item;
    Push-Location $dir.Parent;
    try {
        Write-Verbose "pruning in $((Get-Location).Path)...";
        $expression = Build-Command;

        Invoke-expression $expression;
    } finally {
        Pop-Location;
    }
}
```

Separating pruning from fetching also allows me to prune at a wider scope than fetching. e.g. `c:\Users\peter\src\client .\fetch-all.ps1` and `c:\Users\peter\src .prune-all.ps1`. 

I look forward to your feedback and comments.
