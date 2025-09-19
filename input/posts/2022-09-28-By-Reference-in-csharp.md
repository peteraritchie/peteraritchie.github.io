---
layout: post
title: 'By Reference in C#'
categories: ['C#']
comments: true
excerpt: "Binding affects the compile-time usage of an identifier because of the run-time lifetime of the resources it is bound to."
tags: ['C#', '.NET']
---
I became aware recently that there were many C# compiler errors that do not have a corresponding documentation page.  That documentation is open-source and I chose to spend some time contributing some pages for the community. Looking at a language feature from the perspective of its compile-time errors is rather enlightening, so I'd though I'd write a bit about these features in hopes of offering a better understanding for my readers.

C# compiler errors can be categorized (arbitrarily) by different areas of C# syntax, and I started to focus on one category at a time.  One of those areas involves referenced variables.  C# has always has `ref` arguments, but `ref` return, `ref` locals, `ref` structs, and `ref` fields have been additions to the syntax.

The declaration of a variable in C# influences its syntax in a couple ways: binding and accessibility.  Accessibility is whether an identifier is _visible_ at compile-time in a given context.  Binding is how an identifier or name is bound at run-time to resources like data and code.  Binding uniquely affect the compile-time correctness of any particular usage of a `ref` variable.

Binding affects the compile-time usage of an identifier because of the run-time lifetime of the resources it is bound to. You're probably familiar with a static method accessing instance data and the errors caused in this context. `ref` variables have a similar context when they are stack allocated. Heap-allocated objects (objects bound to the heap) can have their lifetime extended to be long-lived because the heap shares the same lifetime as the application. Variables bound to stack-allocated resources cannot have their lifetime extended beyond a specific scope. The stack is a sequential collection of elements with elements implicitly partitioned by a shared scope. The most recognized scope is probably a method call or method/lambda body. Local variables bound to stack elements do not have a lifetime beyond the method call. A reference to a stack object cannot be assigned to a variable or expression with a broader scope.

How far the value of an expression can leave the confines of its declaration scope is called "escape scope".  Sometimes the escape scope is the same as the declaration scope.  The compiler verifies compatible escape scopes during assignment.  For example:

```csharp
    void M(ref int ra)
    {
        int number = 0;
        ref int rl = ref number;
        if (ra == 0)
        {
            int x = number;
            rl = ref x;
        }
    }
```

`x` is local to the `if` body, it is bound to the stack, and its escape scope is narrower than `ref rl` because `ref rl` is declared in the outer scope.  Since `ref rl` is an alias to another variable, it cannot reference a variable bound to a resource that will go out of scope before it does.  `rl = ref x` results in a compiler error.  If `rl` were not a reference to a value type, the assignment would be okay because `x` would be bound to heap and have a broader escape scope.

The compiler also verifies compatible escape scopes when returning values.  For example:

```csharp
    ref int M(ref int ra)
    {
        int number = 0;
        ref int rl = ref number;
        if (ra == 0)
        {
            ref int x = ref number;
            return ref x;
        }
        return ref ra;
    }
```

`return ref x` results in a compiler error because the escape scope of `x` is local to the method.  The error message here may not be as clear as the first because it doesn't mention the narrower escape scope.

There are the basic escape scopes.  A calling method scope, a current method scope, and a return-only scope.

The calling method scope is a scope outside of the containing method/lambda.  References can reach this scope via either a `ref` parameter or a return.

The current method scope is a scope within a containing method/lambda.

The return-only scope is a special case for `ref struct` types that can only leave the method scope via a return and not through a `ref` or `out` parameter.
