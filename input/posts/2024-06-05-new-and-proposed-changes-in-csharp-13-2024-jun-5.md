---
layout: post
title: 'New And Proposed Changes For C# 13 - June 5, 2024'
categories: ['June 2024', '.NET', 'C#', '.NET 9', 'C# 13']
comments: true
excerpt: C# 13 preview offers several improvements that prove to be exciting.
tags: ['.NET', 'C#', '.NET 9', 'C# 13']
---
![Extensions, extensions, extensions](../assets/types-of-extensions.png)

C# 13 is shaping up to introduce some interesting and useful additions to the C# language. Let's look at what we know as of June 5, 2024.

## Extension Types

_Extension Types_ (announced at Build 2024) are the latest proposed addition to C# 13. Microsoft introduced _Extension Methods_ in C# 3, and since C# 4, the concept of "Extension Everything" has been an anticipated addition. _Extension Methods_ added the ability to extend non-static classes with statically-defined methods in unrelated static classes. _Extension Types_ extend the extensibility that Extension Methods offer, a huge leap towards Extension Everything.

Extension Methods syntax stays the same, but you can be clearer about the intent of your extension methods by declaring implicit extension classes.

An extension method in C#3-C#12 may look like this:

```csharp
public static class StringExtensions
{
    public static bool IsNotNullOrEmpty(this string text)
    {
        return !string.IsNullOrEmpty(text);
    }
}
```

The above code introduces the ability to do something like `myText.IsNotNullOrEmpty()`. In C# 13, you can be more direct (I'm trying to avoid using the word "explicit"; you'll see why in a sec.) by declaring an _implicit extension_ class with what looks like an instance method `IsNotNullOrEmpty`:

```csharp
implicit extension StringExtensions for string
{
    public bool IsNotNullOrEmpty()
    {
        return !string.IsNullOrEmpty(this);
    }
}
```

This alternative way to re-implement an extension method implements an instance method on the extension class&mdash;which is how the extension method appears when used: a call to a method on an instance of a type (`string` in our example.) We're not limited to extending the _instance_ of a type; we can also extend the type with static methods. `IsNotNullOrEmpty` is looking to be the opposite of the static `string` method `IsNullOrEmpty`. With Extension Types we will be able to implement `IsNotNullOrEmpty` as a static method on `string`

```csharp
implicit extension StringExtensions for string
{
    public static bool IsNotNullOrEmpty(string text)
    {
        return !string.IsNullOrEmpty(text);
    }
}
```

The above code adds a **static extension method** that allows for `string.IsNotNullOrEmpty(myText)`.

But, since the code will truly be in the context&mdash;or scope of&mdash;`string`, I don't need to qualify the call to `IsNullOrEmpty` with the type `string`! So, we could do this instead:

```csharp
implicit extension StringExtensions for string
{
    public static bool IsNotNullOrEmpty(string text)
    {
        return !IsNullOrEmpty(text);
    }
}
```

Since this is "Extensions Types," we will also have _extension properties_. Continuing with my theme of IsNotNullOrEmpty (potentially in a controversial way), we could implement my original extension method as an extension property:

```csharp
implicit extension StringExtensions for string
{
    public bool IsNotNullOrEmpty => !IsNullOrEmpty(this);
}
```

The above code allows us to write `myText.IsNotNullOrEmpty`. (Feel free to comment that I'm mad for making a property on a potentially `null` instance of a `string`, this is just an example.)

Extension Types isn't limited to extension methods and properties but also includes extension indexers. Stealing from Dustin and Mads' demo, let's say we want to provide access to individual bits with a `UInt64`; I could write an implicit extension type like this:

```csharp
public implicit extension Bits for Uint64)
{
    public bool this[int index]
    {
        get => (this & Mask(index)) != 0;
        set => this = value ? this | Mask(value) : this & !Mash(index);
    }
    
    static ulong Mask(int index) => `ul << index;
}
```
... so I could obtain the first bit of an unsigned 64-bit number with `unsigned64BitNumber[0]`!

What's with `implicit`? Like implicit operators that will be resolved to based on inferred scope or that it _implicitly_ applies to all cases of the underlying type (`... for <type>`.) The keyword `explicit` means a caller can only use the member in an explicitly-qualified scope. So, if I made my `StringExtensions` class `explicit` instead, the use of `IsNullOrEmpty` would only be callable by qualifying with `StringExtensions`: `(StringExtensions)myText.IsNotNullOrEmpty`. At least, that's what's currently proposed.

Extension Types is a work in progress, so some of these things may change&mdash;I expect details around `explicit` usage to change.

## New `field` Contextual Keyword

A feature that almost made it into C# 12 is the `field` contextual keyword--contextual in autoproperties. `field` is an "alias" got access the auto-generated backing field.

Since you could declare a variable within the context of an autoproperty, `field` is technically a breaking change.

## `params` Collections

`params` has existed in C# since the start as a means of declaring a method that takes a variable number of arguments. Generic types were not available at the time, so `params` only works with _arrays_, for example, `void Method(params string[] args)` or `void Method(params int[] numbers)`.

This means that `ReadOnlySpan<T>` may be used with `params` to realize the performance improvements of spans.

## `System.Threading.Lock` Type and `lock`

.NET 9 introduces an improved lock type `System.Threading.Lock`. `System.Threading.Lock` offers improvements over `Monitor` in that `Lock` supports a narrower locking scope and avoids the overhead of SyncBlock.

C# 13 `lock` recognizes if the target is `System.Threading.Lock` and uses its updated API.

## New Escape Sequence For <kbd>Esc</kbd> Character

You can now enter <kbd>Esc</kbd> as a string/character literal with `'\e'`. Prior to C# 13, having the <kbd>Esc</kbd> character in a string would require typing `\u001b` (or `\x1b`, but that's not recommended.) I believe this accepts the existing Regular Expression character sequence of `\e` as an escape for <kbd>Esc</kbd>.

## Improved Overload Resolution For Method Groups

C# 13 will improve overload resolution of method groups when determining the method group's natural type. Oversimplication: instead of generating all possible candidate methods and selecting the best candidate, candidates will be constructed scope by scope. If, after pruning all the candidates at one scope, candidates at the next scope are constructed and considered. If you're interested at that level, see [Generic constraints should prune out candidates for method group natural type](https://github.com/dotnet/roslyn/issues/69222)

## Index operator `^` Now Available In Object Initializer Expressions

You can now use the "From the end" operator in object initializer expressions. e.g.:

```csharp
var countdown = new TimerRemaining()
{
    buffer =
    {
        [^1] = 0,
        [^2] = 1,
        [^3] = 2,
        [^4] = 3,
        [^5] = 4,
        [^6] = 5,
        [^7] = 6,
        [^8] = 7,
        [^9] = 8,
        [^10] = 9
    }
};
```

## Caveat

"C# 13" is a work in progress, and the above was accurate when it was published. Hopefully we'll get everything detailed above but we may not. We may not get some of these features or we may get more!

## References

- [Language Feature: Extension Everything](https://github.com/dotnet/roslyn/issues/11159)
- [\[Proposal\]: Extensions](https://github.com/dotnet/csharplang/issues/5497)
- [Proposal: Semi-Auto-Properties; field keyword](https://github.com/dotnet/csharplang/issues/140)
- [`params` Collections Feature Proposal](https://learn.microsoft.com/en-us/dotnet/csharp/language-reference/proposals/params-collections)
- [Lock Object Feature Specification](https://learn.microsoft.com/en-us/dotnet/csharp/language-reference/proposals/lock-object)
- [\[Proposal\]: String/Character escape sequence \e as a short-hand for \u001b (\<ESCAPE\>)](https://github.com/dotnet/csharplang/issues/7400)
- [Method group natural type improvements](https://learn.microsoft.com/en-us/dotnet/csharp/language-reference/proposals/method-group-natural-type-improvements)
- [\[Proposal\]: Method group natural type improvements](https://github.com/dotnet/csharplang/issues/7429)
- [Open issue: evaluation of implicit indexers in object initializers](https://github.com/dotnet/csharplang/issues/7684)
