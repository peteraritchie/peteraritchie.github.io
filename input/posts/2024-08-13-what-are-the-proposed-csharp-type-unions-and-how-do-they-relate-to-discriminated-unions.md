---
layout: post
title: 'What Are the Proposed C# Type Unions and How Do They Relate to Discriminated Unions?'
categories: ['.NET', 'C#', 'Aspire']
comments: true
excerpt: .
tags: ['Aug 2024', '.NET', 'C#', '.NET', 'C# 13']
---
<!--what-are-the-proposed-csharp-type-unions-and-how-do-they-relate-to-discriminated-unions-->
![views through different lenses](../assets/views-through-different-lenses.jpg)

The [rumor](https://github.com/dotnet/csharplang/blob/18a527bcc1f0bdaf542d8b9a189c50068615b439/proposals/TypeUnions.md) is that a _type union_ feature may make its way into the next version of C#. The next version of C# will be 13, and C# has been around since 2000. What do type unions mean to C#?

The concepts behind type unions have probably been around as long as programming languages. Some languages refer to them with different terms. Ada, Pascal, and Modula-2 refer to them as _variant records_ (like _variants_ in COM), Algo refers to them as _united modes_, F#, and CORBA refer to them as discriminated unions and other languages refer to them as tagged unions (like Python and TypeScript). Some languages have a discriminator (tag) support in their enumerations feature (like Swift, Rust, and Haxe). You might also see discriminated union-_like_ support in other technologies like Swagger and OpenAPI.

If you're familiar with C/C++, you may be familiar with unions; they're similar--their data types that define the type (or a block of memory) can be one of multiple types. C/C++ unions don't have a tag or discriminator or track what the union's storage _means_). So, the code that uses the union has to figure out how to access data in the union correctly. I.e., the code that uses a union C/C++ must have its own discriminator/tag.

C# never truly had the concept of a C/C++ union because of increased memory safety&mdash;accessing memory in many different ways wasn't considered _safe_. You can fake C/C++ style unions in C# with `StructLayoutAttribute` and `LayoutKind.Explicit`. But I, for one, wouldn't recommend implementing discriminated unions that way.

There have been some quasi-discriminated union implementations out there like `Result<T>` and `Optional<T>`. I call these _quasi_ because they're very special-case. Most `Result<T>` implementations are discriminated unions because of the `Status` or `IsSuccess` properties that allow a consumer of an instance to tell whether to access the success or the error information. `Optional<T>` is like `Nullable<T>` with a discriminator `HasValue`, but more semantically aligned with an _optional value_ (that could also be nullable).

## Will C# Get _Discriminated Unions_ or _Type Unions_?

The proposal for C# uses "Type Union" because the discriminator isn't explicit. The union object (or, more accurately, the C# compiler) knows the instance type and allows the use of existing C# type-matching features (like `is`). The proposed syntax for declaring a Type Union is similar to declaring a single-level inheritance hierarchy that cannot be inherited from and behaves as if it is _closed_. In fact, BCL support for the concept will use a `ClosedAttribute` to declare Type Unions in a Common Type System way.

Without a Type Union feature, something with a discriminator (specifically something like [`Result<T>`](https://blog.nimblepros.com/blogs/getting-started-with-ardalis-result/), is used like this:

```csharp
// makes use of predefined union "Result<T>"
public Result<Resource> GetResource(Guid id)
{
   var resource = _context.Resources.SingleOrDefault(e => e.Id == id);
   if(resource == null) return new Result<Resource>.NotFound;
   return new Result<Resource>(resource);
}

//... 

var result = GetResource(id);
if(result.Status == ResultStatus.Ok)
{
  result.Value.Description = newDescription;
  UpdateResource(result.Value);
}
else
{
  CreateResource(new Resource(id){Description = newDescription};
}
```

With the proposed C# syntax, you'd declare a type union something like this, and for the point of comparison, I'll do one possible, simplified Type Union implementation of `Result<T>`
```csharp
public union struct Result<TValue>
{
  Success(TValue value);
  Failure(ErrorCode errorCode);
}
```

As a _Type Union_, this declares a union `Result` and member types `Success` and `Failure`.

Creating an instance is similar to:
```csharp
Result<Resource> result = Succes(resource);
```
or
```csharp
Result<Resource> result = Failure(ErrorCode.NotFound);
```

Instantiating one of the types and assigning it to an instance of the union&mdash;much like assigning a subclass to an instance of the base class.

And use the instance like:
```csharp
if(result is Failure f) { /*...*/ }
```
|NOTE|
|-|
|These examples were written without access to the feature in the language. Based solely on documentation, expect syntax errors when the feature is released.|

This example is covered in some common patterns in the proposal and only covers a part of what's possible with Type Unions (that part is _struct unions_.) What's nice about this proposed feature is that it also considers union classes, ad hoc unions, and a limited ability to create custom unions (e.g., `ClosedAttribute` and `UnionAttribute`).

What's also nice about this proposal is that it considers records, refs, boxing, nullability, co-/contra-variance (with ad hoc unions), exhaustiveness, nullability, equivalence, and assignability. The proposal might only do _most_ of what you'd expect, but it does what is correct and useful.