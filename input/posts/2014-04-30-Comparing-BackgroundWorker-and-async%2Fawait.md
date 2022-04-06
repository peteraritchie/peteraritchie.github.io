---
layout: post
title: 'Comparing BackgroundWorker and async/await'
tags: ['Software Development', 'msmvps', 'April 2014']
---
[Source](http://pr-blog.azurewebsites.net/2014/04/30/comparing-backgroundworker-and-asyncawait/ "Permalink to Comparing BackgroundWorker and async/await")

# Comparing BackgroundWorker and async/await

`BackgroundWorker` is meant to model a single task that you'd want to perform in the background, on a thread pool thread. `async`/`await` is a syntax for asynchronously awaiting on asynchronous operations. Those operations may or may not use a thread pool thread or even use _any other thread_. So, they're apples and oranges.

For example, you can do something like the following with `await`:
    
    
    using (WebResponse response = await webReq.GetResponseAsync())
    {
        using (Stream responseStream = response.GetResponseStream())
        {
            int bytesRead = await responseStream.ReadAsync(buffer, 0, buffer.Length);
        }
    }
    

But, you'd likely never model that in a background worker, you'd likely do something like this in .NET 4.0 (prior to `await`):
    
    
    webReq.BeginGetResponse(ar =>
    {
        WebResponse response = webReq.EndGetResponse(ar);
        Stream responseStream = response.GetResponseStream();
        responseStream.BeginRead(buffer, 0, buffer.Length, ar2 =>
        {
            int bytesRead = responseStream.EndRead(ar2);
            responseStream.Dispose();
            ((IDisposable) response).Dispose();
        }, null);
    }, null);
    

Notice the disjointness of the disposal compared between the two syntaxes and how you can't use `using` without `async`/`await`.

But, you wouldn't do something like that with `BackgroundWorker`. `BackgroundWorker` is usually for modeling a single long-running operation that you don't want to impact the UI responsiveness. For example:
    
    
    worker.DoWork += (sender, e) =>
                        {
                        int i = 0;
                        // simulate lengthy operation
                        Stopwatch sw = Stopwatch.StartNew();
                        while (sw.Elapsed.TotalSeconds < 1)
                            ++i;
                        };
    worker.RunWorkerCompleted += (sender, eventArgs) =>
                                    {
                                        // TODO: do something on the UI thread, like
                                        // update status or display "result"
                                    };
    worker.RunWorkerAsync();
    

There's really nothing there you can use async/await with, `BackgroundWorker` is creating the thread for you.

Now, you could use TPL instead:
    
    
    var synchronizationContext = TaskScheduler.FromCurrentSynchronizationContext();
    Task.Factory.StartNew(() =>
                          {
                            int i = 0;
                            // simulate lengthy operation
                            Stopwatch sw = Stopwatch.StartNew();
                            while (sw.Elapsed.TotalSeconds < 1)
                                ++i;
                          }).ContinueWith(t=>
                                          {
                                            // TODO: do something on the UI thread, like
                                            // update status or display "result"
                                          }, synchronizationContext);
    

In which case the `TaskScheduler` is creating the thread for you (assuming the default `TaskScheduler`), and could use `await` as follows:
    
    
    await Task.Factory.StartNew(() =>
                      {
                        int i = 0;
                        // simulate lengthy operation
                        Stopwatch sw = Stopwatch.StartNew();
                        while (sw.Elapsed.TotalSeconds < 1)
                            ++i;
                      });
    // TODO: do something on the UI thread, like
    // update status or display "result"
    

In my opinion, a major comparison is whether you're reporting progress or not. For example, you might have a `BackgroundWorker like` this:
    
    
    BackgroundWorker worker = new BackgroundWorker();
    worker.WorkerReportsProgress = true;
    worker.ProgressChanged += (sender, eventArgs) =>
                                {
                                // TODO: something with progress, like update progress bar
    
                                };
    worker.DoWork += (sender, e) =>
                     {
                        int i = 0;
                        // simulate lengthy operation
                        Stopwatch sw = Stopwatch.StartNew();
                        while (sw.Elapsed.TotalSeconds < 1)
                        {
                            if ((sw.Elapsed.TotalMilliseconds%100) == 0)
                                ((BackgroundWorker)sender).ReportProgress((int) (1000 / sw.ElapsedMilliseconds));
                            ++i;
                        }
                     };
    worker.RunWorkerCompleted += (sender, eventArgs) =>
                                    {
                                        // do something on the UI thread, like
                                        // update status or display "result"
                                    };
    worker.RunWorkerAsync();
    

But, you wouldn't deal with some of this because you'd drag-and-drop the background worker component on to the design surface of a form–something you can't do with async/await and Task… i.e. you won't manually create the object, set the properties and set the event handlers. you'd only fill in the body of the `DoWork`, `RunWorkerCompleted`, and `ProgressChanged` event handlers.

If you "converted" that to async/await, you'd do something like:
    
    
         var progress = new Progress<int>();
    
         progress.ProgressChanged += ( s, e ) =>
            {
               // TODO: do something with e.ProgressPercentage
               // like update progress bar
            };
    
    await Task.Factory.StartNew(() =>
                      {
                        int i = 0;
                        // simulate lengthy operation
                        Stopwatch sw = Stopwatch.StartNew();
                        while (sw.Elapsed.TotalSeconds < 1)
                        {
                            if ((sw.Elapsed.TotalMilliseconds%100) == 0)
                            {
                                progress.OnReport((int) (1000 / sw.ElapsedMilliseconds))
                            }
                            ++i;
                        }
                      });
    // TODO: do something on the UI thread, like
    // update status or display "result"
    

Without the ability to drag a component on to a Designer surface, it's really up to the reader to decide which is "better". But, that, to me, is the comparison between `await` and `BackgroundWorker`, not whether you can await built-in methods like `Stream.ReadAsync`. e.g. if you were using `BackgroundWorker` as intended, it could be hard to convert to use `await`.


