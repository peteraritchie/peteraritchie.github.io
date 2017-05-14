---
layout: post
title: Dispose Pattern and “Set large fields to null”
categories: ['.NET 4.0', 'C#', 'DevCenterPost', 'Pontification']
tags:
- msmvps
---
[Source](http://blogs.msmvps.com/peterritchie/2012/04/26/dispose-pattern-and-set-large-fields-to-null/ "Permalink to Dispose Pattern and “Set large fields to null”")

# Dispose Pattern and “Set large fields to null”

I was involved in a short side discussion about "should" fields be set to null in the Dispose method(s).  I'm not sure what the impetus of the question was; but, if you read through the [dispose pattern MSDN documentation][1] (in most versions I believe) there's a comment // Set large fields to null. in the implementation of the virtual Dispose method within the if(!disposed) block and after the if(disposing) block.  But, that's the only reference to setting fields to null during dispose.  There's nothing else that I've been able to find in MSDN with regard to setting fields to null.

At face value, setting a field to null means that the referenced object is now unrooted from the class that owns the field and, if that was the last root of that reference, the Garbage Collector (GC) is now free to release the memory used by the object that was referenced by that field.  Although advanced, this seems all very academic because the amount of time between unrooting the reference and the return from Dispose (and thus the unrooting of the parent object) would seem like a very short amount of time.  Even if the amount of time between these two actions is small, setting a single field to null (i.e. a single assignment) seems like such a minor bit of code to provide no adverse affects.  The prevalent opinion seems to be that the GC "handles" this case and does what is best for you without setting the field to null.

The GC is pretty smart.  There's a lot of bright people who have worked on the GC over the years; and it improves every release of .NET.  But, that doesn't answer the question; is there benefit to setting a field to null in the Dispose method?  Considering there isn't much guidance on the topic; I'd though I'd set aside any faith I have in the GC and throw some science at the problem: take my theory, create some experiments, make observations, and collect some evidence.

What I did was to create two classes, identical except that the Dispose method doesn't set a reference field to null.  The classes contain an field that could reference a "large" or "small" object: I would experiment with large objects and small objects and observe the differences.  The following are the classes:
    
    
    	public class First : IDisposable {
    		int[] arr = new int[Constants.ArraySize];
    		public int[] GetArray() {
    			return arr;
    		}
    		public void Dispose() {
    			arr = null;
    		}
    	}
     
    	public class Second : IDisposable {
    		int[] arr = new int[Constants.ArraySize];
    		public int[] GetArray() {
    			return arr;
    		}
     
    		public void Dispose() {
    		}
    	}
    

I would vary Constants.ArraySize constant to make the arr reference a "large" object or a "small" object.  I then created a loop that created several thousand instances of one of these classes then forced a garbage collection at the end; keeping track of the start time and the end time via Stopwatch:
    
    
    	public class Program {
    		private const int Iterations = 10000;
     
    		static void Main(string[] args)
    		{
    			var stopwatch = Stopwatch.StartNew();
    			for (int i = 0; i < Iterations; ++i)
    			{
    				using (var f = new First())
    				{
    					ConsumeValue(f.GetArray().Length);
    				}
    			}
    			GC.Collect();
    			stopwatch.Stop();
    			Trace.WriteLine(String.Format("{0} {1}", stopwatch.Elapsed, stopwatch.ElapsedTicks));
    			stopwatch = Stopwatch.StartNew();
    			for (int i = 0; i < Iterations; ++i)
    			{
    				using (var s = new Second())
    				{
    					ConsumeValue(s.GetArray().Length);
    				}
    			}
    			GC.Collect();
    			stopwatch.Stop();
    			Trace.WriteLine(String.Format("{0} {1}", stopwatch.Elapsed, stopwatch.ElapsedTicks));
    		}
     
    		static void ConsumeValue(int x) {
    		}
    	}

I wanted to make sure instanced got optimized away so the GetArray method makes sure the arr field sticks around and the ConsumeValue makes sure the First/Second instances stick around (more a knit-picker circumvention measure :).  Results are the 2nd result from running the application 2 times.

As it turns out, the results were very interesting (at least to me :).  The results are as follows:

Iterations: 10000 ArraySize: 85000 Debug: yes Elapsed time: 00:00:00.0759408 Ticks: 170186.

Iterations: 10000 ArraySize: 85000 Debug: yes Elapsed time: 00:00:00.7449450 Ticks: 1669448.

Iterations: 10000 ArraySize: 85000 Debug: no Elapsed time: 00:00:00.0714526 Ticks: 160128.

Iterations: 10000 ArraySize: 85000 Debug: no Elapsed time: 00:00:00.0753187 Ticks: 168792.

Iterations: 10000 ArraySize: 1 Debug: yes Elapsed time: 00:00:00.0009410 Ticks: 2109.

Iterations: 10000 ArraySize: 1 Debug: yes Elapsed time: 00:00:00.0007179 Ticks: 1609.

Iterations: 10000 ArraySize: 1 Debug: no Elapsed time: 00:00:00.0005225 Ticks: 1171.

Iterations: 10000 ArraySize: 1 Debug: no Elapsed time: 00:00:00.0003908 Ticks: 876.

Iterations: 10000 ArraySize: 1000 Debug: yes Elapsed time: 00:00:00.0088454 Ticks: 19823.

Iterations: 10000 ArraySize: 1000 Debug: yes Elapsed time: 00:00:00.0062082 Ticks: 13913.

Iterations: 10000 ArraySize: 1000 Debug: no Elapsed time: 00:00:00.0096442 Ticks: 21613.

Iterations: 10000 ArraySize: 1000 Debug: no Elapsed time: 00:00:00.0058977 Ticks: 13217.

Iterations: 10000 ArraySize: 10000 Debug: yes Elapsed time: 00:00:00.0527439 Ticks: 118201.

Iterations: 10000 ArraySize: 10000 Debug: yes Elapsed time: 00:00:00.0528719 Ticks: 118488.

Iterations: 10000 ArraySize: 10000 Debug: no Elapsed time: 00:00:00.0478136 Ticks: 107152.

Iterations: 10000 ArraySize: 10000 Debug: no Elapsed time: 00:00:00.0524012 Ticks: 117433.

Iterations: 10000 ArraySize: 40000 Debug: yes Elapsed time: 00:00:00.0491652 Ticks: 110181.

Iterations: 10000 ArraySize: 40000 Debug: yes Elapsed time: 00:00:00.3580011 Ticks: 802293.

Iterations: 10000 ArraySize: 40000 Debug: no Elapsed time: 00:00:00.0467649 Ticks: 104802.

Iterations: 10000 ArraySize: 40000 Debug: no Elapsed time: 00:00:00.0487685 Ticks: 109292.

Iterations: 10000 ArraySize: 30000 Debug: yes Elapsed time: 00:00:00.0446106 Ticks: 99974.

Iterations: 10000 ArraySize: 30000 Debug: yes Elapsed time: 00:00:00.2748007 Ticks: 615838.

Iterations: 10000 ArraySize: 30000 Debug: no Elapsed time: 00:00:00.0411109 Ticks: 92131.

Iterations: 10000 ArraySize: 30000 Debug: no Elapsed time: 00:00:00.0381225 Ticks: 85434.

For the most part, results in debug mode are meaningless.  There's no point in making design/coding decisions based on perceived benefits in debug mode; so, I don't the results other than to document them above.

The numbers could go either way, if we look at percentages; release mode, setting a field to null seems to be slower 50% of the time and faster 50% of the time.  When setting a field to null is faster it's insignificantly faster (5.41%, 9.59%, and 4.28% faster) when it's slower it's insignificantly slower but more slow than it is fast (133.68%, 163.52%, and 107.84% slower).  Neither seems to make a whole lot of difference (like 10281 ticks over 10000 iterations in the biggest difference for about 1 tick per iteration—1000 byte array at 10000 iterations).  If we look at just the time values, we start to see that setting a field starts to approach being faster (when it's slower it's slower by 295, 8396, and 6697 ticks; when it's faster it's faster by 8664, 10281, 4490).  Oddly though, setting "large" fields to null isn't the biggest of faster setting field to null values.  But, of course, I don't know what the documentation means by "large"; it could be large-heap objects or some other arbitrary size.

Of course there's other variables that could affect things here that I haven't accounted for (server GC, client GC, GC not occurring at specific time, better sample size, better sample range, etc.); so, take the results with a grain of salt.

What should you do with this evidence?  It's up to you.  I suggest not taking it as gospel and making a decision that is best for you own code based on experimentation and gathered metrics in the circumstances unique to your application and its usage..  i.e. setting a field to null in Dispose is neither bad nor good in the general case.

[1]: http://bit.ly/I8Xf3R

