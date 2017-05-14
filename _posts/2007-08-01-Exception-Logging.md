---
layout: post
title: Exception Logging
categories: ['C#', 'Design/Coding Guidance', 'Software Development']
tags:
- msmvps
---
[Source](http://blogs.msmvps.com/peterritchie/2007/08/01/exception-logging/ "Permalink to Exception Logging")

# Exception Logging

There is often a requirement for an application to log unhandled (and sometimes "handled") exceptions.  This logging could occur to a log file, to the Event Log, a logging server, etc.  There's great reasons to log exceptions but logging exceptions can be fraught with problems.

I've have many clients that have been requested to log exceptions and simply threw (pardon the pun) in a call to some logging method in every catch block and added catch blocks around most code that could throw.  This certainly gets the exception logged but introduces at least one problem: if it's an unhandled exception, when does the exception stop getting logged?  For example, given the following code:

  

    //…

    internal sealed class MyClass

    {

        private const int NAME_FIELDINDEX = 1;

        private IDAL dal;

        public MyClass ( )

        {

            // TODO: Base from configuration

            dal = MyOtherClass.Create();

        }

        public String GetName ( )

        {

            String name = String.Empty;

            try

            {

                dal.ReadField(NAME_FIELDINDEX, ref name);

            }

            catch (Exception exception)

            {

                Logger.LogException(exception);

                throw;

            }

            return name;

        }

    }

 

    //…

    internal sealed class MyOtherClass : IDAL

    {

        IDataReader dataReader;

        //…

        public static IDAL Create ( )

        {

            // TODO: do something real

            return new MyOtherClass();

        }

 

        // implements IDAL.ReadField<T>(int, ref T)

        public bool ReadField<T> ( int index, ref T value )

        {

            try

            {

                value = (T)dataReader.GetValue(index);

            }

            catch (InvalidCastException invalidCastException)

            {

                Logger.LogLogicError(Resources.GetMessage(Resources.MessageType.LogicError), invalidCastException);

                return false;

            }

            catch (Exception exception)

            {

                Logger.LogException(exception);

                throw;

            }

            return true;

        }

    }

 

    //…

    public static class Program

    {

        public static void Main ( )

        {

            // …

            MyClass myObject = new MyClass();

            String name = myObject.GetName();

            // …

        }

    }

…since no other method should know (or more importantly, rely-upon) the implementation details of another (like whether it logs exceptions or not) and with a notion that low-level exception logging should be implemented, each method is forced to log exceptions.  As a result, in this example, there would be two identical exceptions logged here.  Anyone debugging would have to know to begin researching the problem with the first in a series of identical exceptions; but, this could be a rat-hole because it assumes adjacently logged exceptions are really the same–which isn't always going to be the case.  But, that's the minor problem.  What if logging is performed to file and a StackException occurs?  Best case, nothing gets logged and several StackExceptions occur (calling another method in the presence of a StackException doesn't go far and may just throw another StackException), worst case you've conceptually got an infinite loop and the remote possibility it can write the event, filling up the event log.  Same would occur with a file, quickly eating up disk space.  In low disk space situations or where there are policies to restrict the size of the Event Log you run into a denial of service problem (i.e. you've blocked all other applications from writing to the event log or to disk).

While the intentions are noble here, the result is not as useful as it was intended to be.  How do you correct this?

This situation can be corrected by mirroring accepted exception handling practices: only catch exceptions you can handle with the exception of a last-chance exception handler.  Since there's the requirement of logging both unhandled and some handled exceptions; logging of handled exceptions needs to occur when the exception is handled, and the notion of low-level unhandled exception logging should be abandoned and unhandled exceptions would be logged at the last-chance handler.  This change would result in something like:

  

    //…

    internal sealed class MyClass

    {

        private const int NAME_FIELDINDEX = 1;

        private IDAL dal;

        public MyClass ( )

        {

            // TODO: Base from configuration

            dal = MyOtherClass.Create();

        }

        public String GetName ( )

        {

            String name = String.Empty;

            dal.ReadField(NAME_FIELDINDEX, ref name);

            return name;

        }

    }

 

    //…

    internal sealed class MyOtherClass : IDAL

    {

        IDataReader dataReader;

        //…

        public static IDAL Create ( )

        {

            // TODO: do something real

            return new MyOtherClass();

        }

 

        // implements IDAL.ReadField<T>(int, ref T)

        public bool ReadField<T> ( int index, ref T value )

        {

            try

            {

                value = (T)dataReader.GetValue(index);

            }

            catch (InvalidCastException invalidCastException)

            {

                Logger.LogLogicError(Resources.GetMessage(Resources.MessageType.LogicError), invalidCastException);

                return false;

            }

            return true;

        }

    }

 

    public static class Program

    {

 

        public static void Main ( )

        {

            try

            {

                MyClass myObject = new MyClass();

                String name = myObject.GetName();

                //…

            }

            catch (Exception exception)

            {

                // last-chance handler

                Logger.LogException(exception);

                throw; // optional re-throw

                // terminate

            }

        }

    }

I've added a last-change handler in Program.Main, removed the exception handler from MyClass.GetName, and removed the catch(Exception) block from MyOtherClass.GetField<T>. Now you've got simpler code (even in this example, more so in the real world), without the potential of duplicate exception logging and denial of service.  And taking into account the [performance implications of try blocks][1], potentially faster code.

[1]: http://msmvps.com/blogs/peterritchie/archive/2007/06/22/performance-implications-of-try-catch-finally.aspx

