---
layout: post
title:  "Robustness with RabbitMQ in .NET"
date:   2011-05-21 12:00:00 -0600
categories: ['Message-Oriented Architectures', 'RabbitMQ']
tags:
- msmvps
---
[Source](http://blogs.msmvps.com/peterritchie/2011/05/22/robustness-with-rabbitmq-in-net/ "Permalink to Robustness with RabbitMQ in .NET")

# Robustness with RabbitMQ in .NET

Recently I've been doing a bit of work with queues, in part with RabbitMQ.

Unfortunately, (or fortunately, depending on your point of view) network connections where I am have had a tendency to be unreliable.  That's a story for the pub; but, needless to say we needed our clients of RabbitMQ to be robust in light of disconnections.  Fortunately, RabbitMQ has ways of dealing with this.

##### A bit about queues

Queues are a two way communication mechanism.  You can enqueue messages and dequeue messages.  In a distributed system you often have a local queue that you asynchronously deal with when you enqueue and dequeue messages.  MSMQ works in this way.  RabbitMQ can be used in this way too.  Eventually, though, a connection to a remote computer needs to be made for the message to be delivered or received from the queue.  RabbitMQ can support asynchronous communications; which means failure can occur outside of when you give your message to the local queue (or "client", in RabbitMQ parlance) or receive a message from the local queue.  RabbitMQ doesn't have the luxury of a the OS having a built-in queue client like MSMQ to deal with connection issues out-of-process—the RabbitMQ client is in-process to your application, so it can be a bit tricky dealing with disconnections.

RabbitMQ supports many "patterns" of messaging like pub/sub, push/pull, etc.  I've been working in a more pub/sub model; so I'm focusing on publication and subscription aspects of RabbitMQ

Robustness can be a complex beast; and I'm not going to discuss many of the aspects certain systems need to deal with.  I'm going to take the stance that the queue and it's client API deals with correct delivery, receipt, acknowledgement, and resending of unacknowledged messages.

With that said, I've alluded to two points of failure.  During the enqueue or during the dequeue.  This is where I'll detail how we can make our system to be more robust with regard to RabbitMQ and disconnections.  With a subscription model in RabbitMQ, the local queue client basically proactively gathers messages for you and places them in a local cache (itself a queue) and you "enumerate" through the messages in the queue.  One way of doing this is with the Subscrption.Next() method.  One overload of Next simply blocks and returns the next message in the queue.  In my circumstance we simply couldn't block the thread indeterminately like that, so we used a different overload Subscription.Next(int timeout, out BasicDeliveryEventArgs result).  This is effectively the same as the first Next method but will timeout if there are no messages in the queue.  The calling code is then free to do anything else it needs to do, like abort and/or try again.  During the call to Next the connection to the queue server could have been severed.  If it has been severed one of two things will happen.  

In the case of Next(int, BasicDeliveryEventArgs), the BasicDeliveryEventArgs instance may be null but Next will return true.  (i.e. "succeeded" but there's no message).  This may happen because the connection was lost prior to the call to Next.  This may also happen if the connection is severed while data is being streamed from the server—resulting internally with an end of stream exception.

Another possibility is OperationInterruptedException will be thrown from Subscription.Next.  I'm not sure why things like end of stream exceptions aren't translated into an OperationInterruptedException instead of returning true and setting BaiscDeliveryEventArgs to null.

In either case, this tells you that the connection is no longer good.  With RabbitMQ you have to try to recreate your connection and try your dequeue again.

Of course, you're not sure what the problem may be and thus  don't know when the server may be available again; so, to simply immediately try to reconnect and retry will most likely mean several failures until it succeeds.  e.g. if the server was rebooted due to an update; we might be able to try thousands of times before we're successful.  To avoid these needless retries, adding a delay in there limits the number of times we retry and gives other threads a chance at CPU time.  I've found that when we don't delay at all, it's more common that we never seem to be able to reconnect.

Following is some code that deals with disconnections in a robust way.

 
    
    
    while (!abort)
    {
    
    
    	if (subscription == null)
    	{
    		try
    		{
    			subscription = CreateSubscription(connectionFactory, "mainqueue", out connection, out model);
    		}
    		catch (BrokerUnreachableException)
    		{
    			Thread.Sleep(1000);
    			continue;
    		}
    	}
    	try
    	{
    		BasicDeliverEventArgs basicDeliveryEventArgs;
    		if (subscription.Next(500, out basicDeliveryEventArgs))
    		{
    			if (basicDeliveryEventArgs == null)
    			{
    				throw new OperationInterruptedException(
    					new ShutdownEventArgs(ShutdownInitiator.Application, 0, "null BasicDeliveryEventArgs"));
    			}
    			// **TODO: something with basicDeliveryEventArgs.Body**
    			subscription.Ack(basicDeliveryEventArgs);
    		}
    	}
    	catch (OperationInterruptedException)
    	{
    		// don't bother with connection, it will throw IOException due to disconnection
    		using (model) using (subscription)
    		{
    			subscription = null;
    			model = null;
    			connection = null;
    		}
    		Thread.Sleep(1000);
    	}
    

}

 

It, of course, doesn't go into detail about how to create a subscription instance—I've left that up to you to create a subscription how your application needs it, and the disposal of the model and the connection isn't detailed as your application will implement this code in different ways influencing when and how these two instances need to be disposed. 

