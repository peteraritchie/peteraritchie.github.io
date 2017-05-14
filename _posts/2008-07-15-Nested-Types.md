---
layout: post
title: Nested Types
categories: ['.NET 3.5', '.NET Development', 'Asynchronous Programming Model (APM)', 'C#', 'C# 3.0', 'Design/Coding Guidance', 'Software Development', 'TCP', 'Visual Studio 2008']
tags:
- msmvps
---
[Source](http://blogs.msmvps.com/peterritchie/2008/07/15/nested-types/ "Permalink to Nested Types")

# Nested Types

Recently [Michael Features][1] [blogged about nested types][2].  The title was almost "nested types considered harmful".

I don't agree.  I don't agree that they're any more harmful than any other C# construct (except goto…).  Nested types are like anything else in our tool-belt: they have a time and place and can be abused.

But, when to use them?  Well, for the most part I agree with Michael, you should avoid them. But, there are times when they're simply the best solution in a given set of circumstances.

Let's look at asynchronous programming model (APM) in .NET.
    
    
            // Paraphrased from MSDN
    
    
            // Accept one client connection asynchronously.
    
    
            public static void DoBeginAcceptTcpClient(TcpListener
    
    
                listener)
    
    
            {
    
    
                // Start to listen for connections from a client.
    
    
                Trace.WriteLine("Waiting for a connection...");
    
    
     
    
    
                // Accept the connection. 
    
    
                // BeginAcceptSocket() creates the accepted socket.
    
    
                listener.BeginAcceptTcpClient(
    
    
                    DoAcceptTcpClientCallback,
    
    
                    listener);
    
    
            }
    
    
     
    
    
            // Process the client connection.
    
    
            public static void DoAcceptTcpClientCallback(IAsyncResult ar)
    
    
            {
    
    
                // Get the listener that handles the client request.
    
    
                TcpListener listener = (TcpListener)ar.AsyncState;
    
    
     
    
    
                // End the operation and display the received data on 
    
    
                // the console.
    
    
                TcpClient client = listener.EndAcceptTcpClient(ar);
    
    
     
    
    
                // TODO: do something with client.
    
    
     
    
    
                // Process the connection here. (Add the client to a
    
    
                // server table, read data, etc.)
    
    
                Trace.WriteLine("Client connected completed");
    
    
            }
    
    
     

In this simple scenario we are getting by with a state of simply a TcpListener object.  In a more complex scenario, you'll likely also want a connection-specific queue, some sort of information about what to do after a connection, etc.  While you can use existing types of have several collection instance fields to keep track of each of these things; you then have to introduce synchronization of those collections, managing the content of those collections, etc.–it's much easier and safer to send that information on the stack.  One method I've tried is simply passing an Object collection as the state; but that quickly becomes hard to manage because of the lack of type-safety on the elements in the array (if I remove an element and replace it with another type, the compile can't know and I'll get a run-time error instead of a compile-time error).  To get type safety I generally introduce a new type to aggregate all the types I need in this asynchronous callback.  While this new type *could* be reusable by other classes; it likely isn't and I don't want to then be bound that that explicit contract I've signed by making the types publicly available.  The only option of not making them publicly available is as private nested types.  For example: 
    
    
            private class AcceptTcpClientParameters
    
    
            {
    
    
                public CommandQueue CommandQueue { get; private set; }
    
    
                public Command NextCommand { get; private set; }
    
    
                public TcpListener TcpListener { get; private set; }
    
    
     
    
    
                public AcceptTcpClientParameters(int commandQueue, int nextCommand, TcpListener tcpListener)
    
    
                {
    
    
                    CommandQueue = commandQueue;
    
    
                    NextCommand = nextCommand;
    
    
                    TcpListener = tcpListener;
    
    
                }
    
    
            }
    
    
     
    
    
            // Accept one client connection asynchronously.
    
    
            public static void DoBeginAcceptTcpClient(TcpListener
    
    
                listener, CommandQueue commandQueue, Command nextCommand)
    
    
            {
    
    
                // Start to listen for connections from a client.
    
    
                Trace.WriteLine("Waiting for a connection...");
    
    
     
    
    
                // Accept the connection. 
    
    
                // BeginAcceptSocket() creates the accepted socket.
    
    
                listener.BeginAcceptTcpClient(
    
    
                    DoAcceptTcpClientCallback,
    
    
                    new AcceptTcpClientParameters(commandQueue, nextCommand, listener));
    
    
            }
    
    
     
    
    
            // Process the client connection.
    
    
            public static void DoAcceptTcpClientCallback(IAsyncResult ar)
    
    
            {
    
    
                AcceptTcpClientParameters parameters = ar.AsyncState as AcceptTcpClientParameters;
    
    
                if(parameters == null) return;
    
    
     
    
    
                TcpClient client = parameters.TcpListener.EndAcceptTcpClient(ar);
    
    
     
    
    
                parameters.NextCommand.Process(parameters.CommandQueue, client);
    
    
            }

I find this use of nested types to be more object-oriented (the needs of the DoAcceptTcpClientCallback are abstracted), more intention revealing, better implements Single Responsibility Principle (SRP), better separates concerns, more maintainable and more agile.

Now, to be clear; this is forced set of circumstances.  You're using a library that implements the APM (right?  You haven't implemented APM yourself…).  But, that's my point–nested types are almost essential in a given set of circumstances.

![kick it on DotNetKicks.com][3] 

[1]: http://www.michaelfeathers.com/
[2]: http://michaelfeathers.typepad.com/michael_feathers_blog/2008/06/are-nested-clas.html
[3]: http://www.dotnetkicks.com/Services/Images/KickItImageGenerator.ashx?url=http%3a%2f%2fmsmvps.com%2fblogs%2fpeterritchie%2farchive%2f2008%2f07%2f15%2fnested-types.aspx

