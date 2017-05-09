---
layout: post
title: Resetting Build Number in Appveyor
date: 2017-05-09 14:32:00 -0500
categories: Appveyor CI
---
# Resetting Build Number in Appveyor
I've been using [AppVeyor](http://ci.appveyor.com) for a while now to be my CI platform of choice for my OSS projects.  It's like any other tool.  It works, and does a lot of things very well.  I recently bumped some major version numbers up and realized that some things AppVeyor was automating weren't completely automated.

Build numbers.  AppVeyor takes on the burden of incrementing a build number for you (and updating your AssemblyInfo and Nuget info, if you want).  Unfortunately that's all it does automatically with the build number.  If I change my version number (e.g. from 1.0 to 2.0) then the build number does not reset to zero but continues on with the next version (so I go from 1.0.34 to 2.0.35).  Not what I was expecting.  Not that big a deal; but when it also publishes Nuget packages; kinda leaves you stuck at contining on from that point.

I've seen a [couple](http://help.appveyor.com/discussions/problems/311-reset-the-build-number-automatically-yml) [threads](http://help.appveyor.com/discussions/suggestions/730-support-next-build-number-0-zero) on the topic, but the result always seemed to get pointed to the API to reset the build number.  I kinda think this violated the Principle of Least Surprise, so I decided to dig in a bit to avoid the surprise the future.

The problem turned out to be fairly easy to solve (easier if you're an expert in PowerShell).  Basically, the way I approached it was to add a script in the *Init script* section of the configuration to get the last build version via the [API](https://www.appveyor.com/docs/api/projects-builds/#get-project-last-build) and compare the components of that version to the current build verison found in the [environment](https://www.appveyor.com/docs/environment-variables/).

This is the result:
<script src="https://gist.github.com/peteraritchie/3643ba729e20d5d0b1b2f817ed00ce6b.js"></script>