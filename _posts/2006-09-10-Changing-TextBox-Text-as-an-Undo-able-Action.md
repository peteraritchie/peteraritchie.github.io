---
layout: post
title: Changing TextBox Text as an Undo-able Action
categories: ['.NET 2.0', '.NET Development', 'C#', 'Software Development', 'WinForms']
tags:
- msmvps
---
[Source](http://blogs.msmvps.com/peterritchie/2006/09/10/changing-textbox-text-as-an-undo-able-action/ "Permalink to Changing TextBox Text as an Undo-able Action")

# Changing TextBox Text as an Undo-able Action

The `TextBox` class supports undoing the last action–inherited from `TextBoxBase`.  Normally the user does this by pressing the undo key (Ctrl-Z if your keyboard doesn't have a specific Undo key) or by selecting "Undo" from the context menu.  The last action can also be undone programmatically by calling `TextBoxBase.Undo()` (after calling `CanUndo()` to see if `Undo()` will work).

Changing the text in a `TextBox` so that the change can be undone is not so obvious though.  Changing the `Text` property or the `SelectedText` property is not undo-able.  .NET 2.0 added `TextBox.Paste(String)` (not inherited from `TextBoxBase`, it's inherent to `TextBox`) that replaces the currently selected text and is undoable.  If you want to replace all the text while allowing the user to undo it, simply call `TextBoxBase.SelectAll()` before `Paste(Sting)`.  For example:

  

textBox.SelectAll();

textBox.Paste(text);

This side-effect, unfortunately, is not documented–which is why it "is not so obvious".

