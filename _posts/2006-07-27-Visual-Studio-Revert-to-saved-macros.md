---
layout: post
title: Visual Studio Revert-to-saved macros
categories: ['.NET Development', 'Visual Studio 2005']
tags:
- msmvps
---
[Source](http://blogs.msmvps.com/peterritchie/2006/07/27/visual-studio-revert-to-saved-macros/ "Permalink to Visual Studio Revert-to-saved macros")

# Visual Studio Revert-to-saved macros

I often run into situations where I'd like to undo all the work I've done in a file.  Some applications refer to this as Revert-to-saved.  Visual Studio 2005 does not seem to have a function to do this.  So, I've written a couple macros to do this.

The first, RevertToSaved simply calls Undo until it can't undo anymore.  This is much faster than holding the Ctrl-Z key down, and keeps your undo buffer.

  

    Sub RevertToSaved()

        While DTE.ActiveDocument.Undo() = True

 

        End While

    End Sub

The second, RevertToSaved2, is a little more brute force–it simply closes the current project item and reopens it, attempting to return to the same cursor location.

  

    Sub RevertToSaved2()

        Dim projectItem As EnvDTE.ProjectItem = DTE.ActiveDocument.ProjectItem

        If Not projectItem Is Nothing Then

            Dim activeLine As Integer = DTE.ActiveDocument.Selection.ActivePoint.Line

            Dim lineCharOffset As Integer = DTE.ActiveDocument.Selection.ActivePoint.LineCharOffset

            DTE.ActiveDocument.Close(vsSaveChanges.vsSaveChangesNo)

            Dim window As EnvDTE.Window = projectItem.Open()

            If Not window Is Nothing Then

                window.Activate()

                window.Document.Selection.MoveToLineAndOffset(activeLine, lineCharOffset)

            End If

        End If

    End Sub

Enjoy!

