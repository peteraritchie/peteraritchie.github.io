---
layout: post
title: 'A New Asynchronicity Awaits You'
tags: ['C#', 'DevCenterPost', 'Software Development', 'Visual Studio vNext', 'msmvps', 'October 2010']
---
[Source](http://blogs.msmvps.com/peterritchie/2010/10/28/a-new-synchronicity-awaits-you/ "Permalink to A New Asynchronicity Awaits You")

# A New Asynchronicity Awaits You

The languages team at Microsoft have just announced that both VB and C# are giving first-class citizenship to asynchronous operations.

At long last we can cleanly program for asynchronous operations without cluttering up the code with imperative artefacts relating to how the asynchronous operation is being performed.

Let's have a quick look at how we had you might perform an asynchronous operation in .NET 1.x:
    
    
    	byte[] readbuffer = new byte[1024];
    
    public void Button1_Click()  
    {  
    WebRequest webRequest = WebRequest.Create("http://msdn.com");  
    webRequest.BeginGetResponse(new AsyncCallback(BeginGetResponseCallback), webRequest);  
    }
    
    private void BeginGetResponseCallback(IAsyncResult asyncResult)  
    {  
    WebRequest webRequest = (WebRequest)asyncResult.AsyncState;  
    WebResponse webResponse = webRequest.EndGetResponse(asyncResult);
    
    Stream stream = webResponse.GetResponseStream();  
    stream.BeginRead(readbuffer, 0, readbuffer.Length, new AsyncCallback(BeginReadCallback), stream);  
    }
    
    private delegate void TakeString(string text);
    
    private void BeginReadCallback(IAsyncResult asyncResult)  
    {  
    Stream stream = (Stream)asyncResult.AsyncState;  
    int read = stream.EndRead(asyncResult);  
    this.Invoke(new TakeString(SetTextBoxText), new object[] {Encoding.ASCII.GetString(readbuffer, 0, read);  
    }
    
    private void SetTextBoxText(String text)  
    {  
    textBox.Text = text;  
    }  
    

In .NET 1.x, in order to go get data from a web page in response to a button click, we had to create two methods that acted as callback for the asynchronous get web request and asynchronous read response. As well, we had to create a method to marshal data back to the UI thread via Control.Invoke so that modification of controls (setting of Text property) is done only on the UI thread.



In .NET 2.0 this got much easier. We could use anonymous methods and get rid of our callback methods altogether to get something like this:
    
    
    	public void Button1_Click(object snder, EventArgs e)  
    {  
    WebRequest webRequest = WebRequest.Create("http://msdn.com");  
    webRequest.BeginGetResponse(delegate(IAsyncResult asyncResult)  
    {  
    WebRequest webRequest1 = (WebRequest) asyncResult.AsyncState;  
    WebResponse webResponse = webRequest1.EndGetResponse(asyncResult);
    
    Stream stream = webResponse.GetResponseStream();  
    stream.BeginRead(readbuffer, 0, readbuffer.Length, asyncResult1 =>  
     {  
     Stream stream1 =  
     (Stream) asyncResult1.AsyncState;  
     int read =  
     stream1.EndRead(asyncResult1);  
     this.Invoke(  
     new TakeString(  
     delegate(string text)  
     {  
     textBox.Text =  
     Encoding.ASCII.GetString(  
     stream1, 0, read);  
     }));  
     }, stream);  
    }, webRequest);  
    }  
    

But, the details of anonymous methods and closures really make this code complex and hard to understand.

In some future version of VB and C#, it will become even easier with the new await/Await and async/Async keywords. In conjunction with the Task Parallel Library, you will now capable of declaring an asynchronous method ("asynch") and inform the compiler which part of the method is asynchronous ("await"). For example:
    
    
    	private async void Button1_Click(object sender, EventArgs e)  
    {  
    var request = WebRequest.Create("http://msdn.com");  
    var response = await request.GetResponseAsync();  
    var reader = new StreamReader(response.GetResponseStream());
    
    textBox.Text = await  
    reader.ReadToEndAsync();  
    }

Much, much simpler and easier to read. "async" tells the compiler that a method uses the await keyword. The await keyword tells the compiler that the method being called returns some sort of Task<> object, the type parameter signifying the left-hand-side type of the method call and that the method uses the Task Parallel library to spin up that Task<> object to perform the operation asynchronously.

As you might imagine, there's a plethora of new methods in the BCL that will now return a Task<> object (and have the postfix of "Async") that can be used with the await keyword.


