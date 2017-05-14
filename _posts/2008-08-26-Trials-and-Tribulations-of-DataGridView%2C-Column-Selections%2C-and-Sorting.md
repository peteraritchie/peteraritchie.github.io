---
layout: post
title:  "Trials and Tribulations of DataGridView, Column Selections, and Sorting"
date:   2008-08-25 12:00:00 -0600
categories: ['.NET 3.5', '.NET Development', 'C#', 'Connect Issue', 'Framework Bug', 'Software Development', 'Visual Studio 2008 SP1']
tags:
- msmvps
---
[Source](http://blogs.msmvps.com/peterritchie/2008/08/26/trials-and-tribulations-of-datagridview-column-selections-and-sorting/ "Permalink to Trials and Tribulations of DataGridView, Column Selections, and Sorting")

# Trials and Tribulations of DataGridView, Column Selections, and Sorting

I had to implement some _custom_ sorting in a DataGridView recently.  Essentially, the stakeholders wanted full column selection (like Excel) while still having the ability to sort the data based on a particular column.

This particular DataGridView is data-bound.  DataGridView offers the Sort(DataGridViewColumn, ListSortDirection) method to perform this.  Nice and easy I thought: I'll set the SelectionMode to DataGridViewSelectionMode.ColumnHeaderSelect and simply call Sort with the selected column.

Well, much to my chagrin this had the side effect of making that column look selected all the time.  No matter where else I clicked, that recently sorted column _looked_ selected (SelectedColumns had a count of zero).  And to add insult to injury, when I control-clicked that column (thinking it was selected) to unselected it, it caused a NullReferenceException deep in the framework.

Suffice it to say, this makes it very difficult to sort by columns in DataGridView without using the built-in sort-column-when-header-is-clicked mode.

What I'm now attempting to do is to unselect the column before sorting it.  This, in itself, is not trivial either; there's no public method to select or deselect a column in the DataGridView.  I've had to create a new DataGridView derivative and call the protected method SetSelectedColumnCore.  A few hoops…

I've logged a couple of issues on Microsoft Connect about these problems.  The first is about ctrl-clicking the column and getting an exception:  <https://connect.microsoft.com/VisualStudio/feedback/ViewFeedback.aspx?FeedbackID=363623> The second is about the visual state of the column remaining "selected": <https://connect.microsoft.com/VisualStudio/feedback/ViewFeedback.aspx?FeedbackID=363623> Attached to this post you will find the project referenced by the two Connect issues.

[Update: I've currently only tried this with a .NET 2.0 project in Visual Studio 2008 SP1; if you find this problem occurs in Visual 2008 RTM, please comment.]

[Update: I overlooked the DataGridViewColumn.Select property, so there's no need to derive from DataGridView]

