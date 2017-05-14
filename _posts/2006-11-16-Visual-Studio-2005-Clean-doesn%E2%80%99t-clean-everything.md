---
layout: post
title: Visual Studio 2005 Clean doesn’t clean everything
categories: ['C#', 'Visual Studio 2005']
tags:
- msmvps
---
[Source](http://blogs.msmvps.com/peterritchie/2006/11/16/visual-studio-2005-clean-doesn-t-clean-everything/ "Permalink to Visual Studio 2005 Clean doesn’t clean everything")

# Visual Studio 2005 Clean doesn’t clean everything

I noticed a while ago that when I clean a project in Visual Studio 2005 that has _XML documentation file_ enabled the XML file isn't removed.  There's an issue logged about files that don't get deleted on Clean on Microsoft Connect [Clean does not remove all files from the build directory][1].  Unfortunately this issue also mentions the vshost files that usually appear in the project build directory for projects that output an EXE.  This has caused this issue to be resolved By Design because of this, with a note that the XML file not being deleted is a bug.

I've been meaning to fiddle around with the Visual Studio 2005 events anyway, so I thought I'd simply write a build done event handler (as the Clean command actually raises this event with vsBuildAction.vsBuildActionClean.  I gathered from the issue details this only occurs in CSharp, so the following macro does the trick for CSharp projects either in the root of a solution or within Solution folders:

    Private ActiveProject As [Project]

    ' don't know why these don't exist in the Constants class…

    Private Const vsProjectKindCSharp As String = "{FAE04EC0-301F-11D3-BF4B-00C04F79EFBC}"

    Private Const vsProjectKindVisualBasic As String = "{F184B08F-C81C-45F6-A57F-5ABD9991F28F}"

    Private Const vsProjectKindCPlusPlus As String = "{8BC9CEB8-8B4A-11D0-8D11-00A0C91BC942}"

    Private Const vsProjectKindJSharp As String = "{E6FDF86B-F3D1-11D4-8576-0002A516ECE8}"

    Private Const vsProjectKindWeb As String = "{E24C65DC-7377-472b-9ABA-BC803B73C61A}"

 

    ' <revision name="Peter Ritchie" date="16-Nov-06″>Created</>

    Private Sub BuildEvents_OnBuildBegin(ByVal Scope As EnvDTE.vsBuildScope, ByVal Action As EnvDTE.vsBuildAction) Handles BuildEvents.OnBuildBegin

        ActiveProject = Nothing

        If (Action = vsBuildAction.vsBuildActionClean) Then

            If (Scope = vsBuildScope.vsBuildScopeProject) Then

                ' keep track of the currently selected item in the solution explorer

                ' we only support one selected project

                Dim solutionExplorer As UIHierarchy

                solutionExplorer = DTE.Windows.Item(Constants.vsext_wk_SProjectWindow).Object()

                If Not solutionExplorer Is Nothing Then

                    Dim items As Array = solutionExplorer.SelectedItems

                    If (items.GetLength(0) > 0) Then

                        ActiveProject = TryCast(items.GetValue(0).Object(), Project) ' todo

                    End If

                End If

            End If

        End If

    End Sub

 

    ' <revision name="Peter Ritchie" date="16-Nov-06″>Created</>

    Private Sub BuildEvents_OnBuildDone(ByVal Scope As EnvDTE.vsBuildScope, ByVal Action As EnvDTE.vsBuildAction) Handles BuildEvents.OnBuildDone

        Try

            If (Action = vsBuildAction.vsBuildActionClean) Then

                If (Scope = vsBuildScope.vsBuildScopeProject) Then

                    If (Not ActiveProject Is Nothing) Then

                        CleanProject(ActiveProject)

                    End If

                ElseIf (Scope = vsBuildScope.vsBuildScopeSolution) Then

                    Dim project As Project

                    For Each project In DTE.Solution.Projects

                        CleanProject(project)

                    Next

                End If

            End If

        Finally

            ActiveProject = Nothing

        End Try

    End Sub

 

    ' <revision name="Peter Ritchie" date="16-Nov-06″>Created</>

    Private Sub CleanProject(ByRef project As Project)

        If Not project Is Nothing Then

            ' we only support CSharp projects at this time.

            If (project.Kind = vsProjectKindCSharp) Then

                Dim projectPath As String = project.Properties.Item("FullPath").Value

                Dim configuration As Configuration

                configuration = project.ConfigurationManager.ActiveConfiguration

                Dim fullOutputPath As String = projectPath & configuration.Properties.Item("OutputPath").Value

                Dim documentationFilePath As String = configuration.Properties.Item("DocumentationFile").Value

                'MsgWin("Checking xml file path for " & project.Name)

                If (Not documentatinoFilePath Is Nothing) And Len(documentationFileName) > 0 Then

                    Dim fullDocumentationFilePath = projectPath & documentationFilePath

                    'MsgWin("xml path: """ & fullDocumentationFilePath & """")

                    Dim fs As New FileIO.FileSystem

                    If (fs.FileExists(fullDocumentationFilePath)) Then

                        fs.DeleteFile(fullDocumentationFilePath)

                    End If

                End If

            ElseIf project.Kind = Constants.vsProjectKindSolutionItems Then

                ' each solution items project contains a collection

                ' of project item solutions items for which we want the SubProject

                Dim projectItem As ProjectItem

                For Each projectItem In project.ProjectItems

                    If projectItem.Kind = Constants.vsProjectItemKindSolutionItems Then

                        CleanProject(projectItem.SubProject)

                    End If

                Next

            End If

        End If

    End Sub

This macro supports solution clean and single project clean (not multi-select project clean).  If you find there are other files you want wiped when you clean, simply add them in the CleanProject subroutine.

[1]: https://connect.microsoft.com/VisualStudio/feedback/ViewFeedback.aspx?FeedbackID=196887

