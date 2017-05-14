---
layout: post
title: More on Async Functions
categories: ['Async Functions', 'C#', 'C# 5', 'DevCenterPost', 'Visual Studio vNext']
tags:
- msmvps
---
[Source](http://blogs.msmvps.com/peterritchie/2010/10/29/more-on-async-functions/ "Permalink to More on Async Functions")

# More on Async Functions

In my last post I showed .Net 1.1 and .NET 2.0 code that performed some asychronous operations.  I then showed the new syntax with "async" and "await" that did the same thing.

But, I didn't detail what's really going on in the new syntax.

If you want to know more about the details of what's going on, read on.  If you just trust me about the previous code, you don't have to read on 🙂

When the Click handler is executed it basically executes everything up to the first await and returns.  This allows the UI to be responsive.  The compiler generates some code that takes the Task<T> object that is returned from the async method and waits for it.  If there is code that needs to execute after the await, then the compiler effectively generates a continuation.  With regard to Task<T>, that's basically a call to Task<T>.ContinueWith.  Any other await statements are collected in that continuation and the same thing is done, the continuation is executed up to the first await and returns…

The underlying architecture knows about synchronization contexts and makes sure "synchronous" code within the Click handler is executed on the UI thread.  So, as you saw in the example, we didn't have to manually deal with marshaling back to the UI thread via Control.Invoke().

My original example was overly simplistic and didn't include anything to deal with disposal.  To a certain extent I've done async functions a disservice because async functions make disposal much, much easier.  For example, my .NET 4.0 code would do something like this:

private void button_Click(object sender, EventArgs e)  
{  
 button.Enabled = false;  
 var webRequest = WebRequest.Create("<http://google.ca>");  
 webRequest.BeginGetResponse(asyncResult =>  
 {  
  var response = webRequest.EndGetResponse(asyncResult);  
  var stream = response.GetResponseStream();  
  if (stream != null)  
  {  
   var reader = new StreamReader(stream);  
   var text = reader.ReadToEnd();  
   BeginInvoke((MethodInvoker) (() =>  
   {  
    textBox.Text = text;  
    button.Enabled = true;  
    reader.Dispose();  
    stream.Dispose();  
    ((IDisposable) response).Dispose();  
   }));  
  }  
  else  
  {  
   ((IDisposable)response).Dispose();  
  }  
 }, null);  
}

As you can see, we can't use the using statement because that assumes the block in which using block resides is run asynchronously, so we're forced to manually call Dispose (and in the case of WebResponse, cast to IDisposable first because it explicitly implements IDisposable).

With await, we can write a block of code with bits of it being asynchronous and still use using statements.  So, with async functions, our code can now dispose more cleanly; for example:

private async void button1_Click(object sender, EventArgs e)  
{  
 try  
 {  
  button.Enabled = false;  
  var webRequest = WebRequest.Create("<http://google.ca>");  
  using (var response = await webRequest.GetResponseAsync())  
  using (var stream = response.GetResponseStream())  
  {  
   if (stream == null) return;  
   using (var reader = new StreamReader(stream))  
   {  
    textBox.Text = await reader.ReadToEndAsync();  
   }  
  }  
 }  
 finally  
 {  
  button.Enabled = true;  
 }  
}

C# 3 and lambda expressions make the act of using asynchronous methods much easier than .NET 1.x; the next version of C# with async functions takes it that final step forward.

