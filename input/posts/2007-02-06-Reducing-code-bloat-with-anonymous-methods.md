---
layout: post
title: 'Reducing code-bloat with anonymous methods'
tags: ['Uncategorized', 'msmvps']
---
[Source](http://blogs.msmvps.com/peterritchie/2007/02/06/reducing-code-bloat-with-anonymous-methods/ "Permalink to Reducing code-bloat with anonymous methods")

# Reducing code-bloat with anonymous methods

C# 2.0 introduced anonymous methods that allow programmers to create a callable block of code thatuses parameters but is notdeclared as a method. One of the places I find this to be most useful is with Invoke and BeginInvoke. Often times, invoking a delegate is used internal to a class to perform asynchronous processing or to ensure code is executed on the GUI thread.  

Events generally don't have a particular thread their handlersare run on; it's up to the code raising the event which thread is used. Code that modifies WinForm control data must be run on the GUI thread. If the codethat modifies control data is in an event handler, you run the risk of causing hard-to-reproduceinstability. Rather than create a new delegate type, a method to be wrapped by your new delegate type, and code to instantiate the delegate when needed; you can use an anonymous method. For example,if in the processing of an event you wanted to add an entry to a ListBox, to ensure the code didn't cause any cross-threading exceptionsor hard-to-reproduce instability you'd have to implement something like:

  

 private delegate void StringToListBox(String item);



 private void AddStringToListBox(String item)

 {

  listBox1.Items.Add(item);

 }



 void myClass_MyEvent ( object sender, EventArgs e )

 {

  

  String item = DateTime.Now.ToString();

 listBox1.BeginInvoke(new StringToListBox(AddStringToListBox),

   new object[] { item });

 }



This lends itself to re-usability; but if you're only using AddStringToListBox in the one event handler, that's a lot of baggage. Plus, you don't get type safety passing an Object array to the delegate invocation. Anonymous methods can reduce this down to a single call to BeginInvoke. For example:

  

 void myClass_MyEvent ( object sender, EventArgs e )

 {

  String item = DateTime.Now.ToString();

  listBox1.BeginInvoke((MethodInvoker)delegate( )

  {

   listBox1.Items.Add(item);

  });

 }

Type safety is no longer an issue and you're not polluting the class' name space with a method thatcould bemisused. For WinForm control events this is not necessary because theyare raisedon the GUI thread.


