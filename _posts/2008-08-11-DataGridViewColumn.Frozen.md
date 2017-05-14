---
layout: post
title: DataGridViewColumn.Frozen
date: 2008-08-10 20:00:00 -0400
categories: ['.NET Development', 'C#', 'Design/Coding Guidance', 'Software Development']
tags:
- msmvps
---
[Source](http://blogs.msmvps.com/peterritchie/2008/08/11/datagridviewcolumn-frozen/ "Permalink to DataGridViewColumn.Frozen")

# DataGridViewColumn.Frozen

[DataGridViewColumn.Frozen][1] is documented as "When a column is frozen, all the columns to its left (or to its right in right-to-left languages) are frozen as well."

Which is nice until you think of the consequences.  The consequences being that freezing a column and all columns to the left is performed with a single assignment of true to the Frozen property of that column; but to unfreeze is not the opposite (a assignment of false to the Frozen property of that column).  No, you must unfreeze each of those columns to the left.  This can be done by manually unfreezing each column, or by unfreezing column 0.

This means that column.Frozen = false is not the opposite of column.Frozen = true—resulting in unbalanced reversible side-effects.

Neither of the techniques to "unfreeze" the column that was frozen is intuitive; but unfortunately this interface is not "intention revealing".  You're not just setting the Frozen property of a column, you're setting the frozen property of that column and all the columns to the left.

Greg Young recently commented (I don't remember where) about writing classes without _any_ properties.  This approach would have helped here.  What Greg is alluding to is to recognize behaviour rather than shape.  Freezing the current column and all columns to the left is a behaviour, not an attribute; and it should be modeled as a method rather than a property.

At any rate, if you have a DataGridView on your form, you may be interested in using these methods instead:
    
    
            private void FreezeAtColumn(int value)
    
    
            {
    
    
                dataGridView.Columns[value].Frozen = true;
    
    
            }
    
    
     
    
    
            private void UnfreezeColumns()
    
    
            {
    
    
                dataGridView.Columns[0].Frozen = false;
    
    
            }

[1]: http://msdn.microsoft.com/en-us/library/system.windows.forms.datagridviewcolumn.frozen(VS.80).aspx

