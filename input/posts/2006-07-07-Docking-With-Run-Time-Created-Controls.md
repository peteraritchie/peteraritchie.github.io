---
layout: post
title: 'Docking With Run-Time-Created Controls'
tags: ['.NET Development', 'C#', 'Software Development', 'WinForms', 'msmvps', 'July 2006']
---
[Source](http://blogs.msmvps.com/peterritchie/2006/07/07/runtimedockfill/ "Permalink to Docking With Run-Time-Created Controls")

# Docking With Run-Time-Created Controls

I was throwing together some demo code that involved creating a control at runtime, that I wanteddocked in a certain way on the parent Form. I could have pre-created the control in the designer and hidden it–to be made visible instead of creating it–but, that's not the situation I wasin. Simply creating the control and setting the Dock property (in this case to DockStyle.Fill) isn't enough to dock it properly if there are any existing docked controls.

If you've ever created a control and runtime and attempted to change the Dock property, you've probably noticed it doesn't dock the way you want. Control docking depends on order of the control in the Controls collection of the parent Form. If you have a Form with a control whose Dock property is DockStyle.top, and you create a new control and set it's dock to DockStyle.Fill, it fills to the entire form client area, not the the area left over by the other docked controls.

In order to create a control and add it to the formwith Dock set toDockStyle.Fill you need to push it to the top of the Controls collection. This can be accomplished with the [SetChildIndex()][1] method on the Collections property. For example:

  

>   

PictureBox pictureBox = new PictureBox();  
pictureBox.Image = pictureBox.ErrorImage;  
pictureBox.SizeMode = PictureBoxSizeMode.StretchImage;  
pictureBox.Dock = DockStyle.Fill;  
this.Controls.Add(pictureBox);  
// the magic line:  
this.Controls.SetChildIndex(pictureBox, 0);Technorati Tags: [WinForms][2]

[1]: http://msdn2.microsoft.com/en-us/library/system.windows.forms.control.controlcollection.setchildindex.aspx
[2]: http://technorati.com/tag/WinForms


