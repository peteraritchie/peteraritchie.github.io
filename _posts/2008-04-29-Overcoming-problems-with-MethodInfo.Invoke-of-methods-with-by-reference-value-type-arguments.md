---
layout: post
title: Overcoming problems with MethodInfo.Invoke of methods with by-reference value type arguments
date: 2008-04-28 20:00:00 -0400
categories: ['.NET Development', 'C#', 'DevCenterPost', 'Software Development']
tags:
- msmvps
---
[Source](http://blogs.msmvps.com/peterritchie/2008/04/29/overcoming-problems-with-methodinfo-invoke-of-methods-with-by-reference-value-type-arguments/ "Permalink to Overcoming problems with MethodInfo.Invoke of methods with by-reference value type arguments")

# Overcoming problems with MethodInfo.Invoke of methods with by-reference value type arguments

I ran into an interesting problem on the Forums recently.  Basically, when you use MethodInfo.Invoke to invoke a method with by-reference value type arguments you can't have the invoked method update a variable/argument.  The problem is, when you invoke the method the parameter is passed to the MethodInfo.Invoke via an object array.  Since we're dealing with a value type, the original value type is boxed and the invoked method actually updates the array element, not the original object (as it would with reference types).  For example:

  

using System;

using System.Reflection.Emit;

using System.Reflection;

using System.Diagnostics;

 

namespace InvokeTesting

{

    class Program

    {

        private const int testValue = 10;

        public static void TestMethod(ref int i)

        {

            i = testValue;

        }

        static void Main(string[] args)

        {

            MethodInfo methodInfo = typeof (Program).GetMethod("TestMethod", BindingFlags.Static | BindingFlags.Public);

            int i = 0;

            object[] parameters = new object[] {i};

            methodInfo.Invoke(null, parameters);

            // original variable isn't updated

            Debug.Assert(i == 0);

            // array element is updated:

            Debug.Assert((int)parameters[0] == testValue);

 

            // copy updated value to original variable

            i = (int)parameters[0];

 

            Debug.Assert(i == testValue);

        }

    }

}

Of course, the only "workaround" is to get the new value out of the array.

Since essentially we're implementing a run-time method invocation, a "better" way would be to create a dynamic method to make the call.  A dynamic method is a method created at run-time (whose body is generated through ILGenerator.Emit et al) and invoked via a delegate.  For example:

  

using System;

using System.Reflection.Emit;

using System.Reflection;

using System.Diagnostics;

 

namespace EmitTesting

{

    // delegate for void method that takes one reference parameter

    public delegate void OneRefParameterCallback<T>(ref T value);

 

    class Program

    {

        private const int testValue = 10;

        public static void TestMethod(ref int i)

        {

            i = testValue;

        }

        static void Main(string[] args)

        {

            // create a dynamic method object with arbitrary name "Caller", void return (null), and one parameter "ref int"

            DynamicMethod caller = new DynamicMethod("Caller", null, new Type[] { typeof(int).MakeByRefType() }, typeof(Program).Module);

 

            ILGenerator ilGenerator = caller.GetILGenerator();

 

            // emit ldarg.0

            ilGenerator.Emit(OpCodes.Ldarg_0);

 

            // emit call void EmitTesting.Program::TestMethod(int32&)

            MethodInfo mi = typeof(Program).GetMethod("TestMethod", BindingFlags.Static | BindingFlags.Public, null,

                                                    new Type[] { typeof(int).MakeByRefType() }, null);

            ilGenerator.Emit(OpCodes.Call, mi);

 

            // emit ret

            ilGenerator.Emit(OpCodes.Ret);

 

            OneRefParameterCallback<int> callback =

                (OneRefParameterCallback<int>)caller.CreateDelegate(typeof(OneRefParameterCallback<int>));

 

            // call our emitted code with a reference parameter

            int i = 0;

            callback(ref i);

            Debug.Assert(i == testValue);

        }

    }

}

In this example, the method invocation directly updates a value type variable.  This could be made more re-usable to refactoring the dynamic method creation code into it's own method.

![kick it on DotNetKicks.com][1]

[1]: http://www.dotnetkicks.com/Services/Images/KickItImageGenerator.ashx?url=http%3a%2f%2fmsmvps.com%2fblogs%2fpeterritchie%2farchive%2f2008%2f04%2f29%2fovercoming-problems-with-methodinfo-invoke-of-methods-with-by-reference-value-type-arguments.aspx

