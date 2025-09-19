---
layout: post
title: 'Dealing with Primitive Obsession with Entity Framework Core'
categories: ['DDD', 'Code Smells', 'Entity Framework', 'Domain-Driven Design']
comments: true
excerpt: Primitive Obsession is when intrinsic types are used to represent values in a domain that may be better served by a Value Object. This post shows how you can deal with addressing Primitive Obsession while still persisting data via Entity Framework Core.
tags: ['.NET', 'DDD', 'Code Smells', 'Domain-Driven Design', 'Entity Framework']
---
![obsessed only with creating with primitive shapes](../assets/obsessed-with-primitive-shapes.png)

Unlike object-oriented languages, serialization and data transfer are limited to a small set of primitive types. These primitive types are often text, numbers (integers, floating point), booleans, arrays, etc. Sometimes, you're fortunate enough to have a more modern framework and have fancy types like date, time, and date/time, UUID/GUID, monetary, or binary data.

Primitive types are _value types_&mdash;they don't have identity semantics, and their equality/equivalence is based on their _value_. Entity Framework Core supports _value types_ as attributes but only insomuch as what the underlying provider supports. Any complex types are "entities" in Entity Framework, despite not having an "identity".

|Note|
|---|
|Every type that Entity Framework is configured to recognize is an _Entity_ (e.g., via `ModelBuilder.Entity<T>()` or `IEntityTypeConfiguration<T>`), despite an entity traditionally (English definition, philosophically, ontologically, or even entity-relationship diagrams) being an individual/instance with an independent (of its attributes) existence.|

Domains invariably have many value types. Some may be complex (multiple attributes), and some may be simple (subsets of primitive types.) Even _simple_ domain value types have unique semantics&mdash;that constrain value validity. A common value type _Name_, for example, is textual and thus can be implemented with a textual primitive type (like `string` or `VARCHAR`.) A textual primitive type like `string` is a sequence of characters up to 2,146,483,647 characters of any value. This is unrealistic for a "name" in most domains: e.g., a name over 2 billion characters in length or containing characters like `%'`, `<`, or `>` is problematic. Unlike how an integer is not a valid text value, and there exists no way to assign an integer to a string (e.g., `string text = 1;` is not valid and cannot be compiled and thus never be executed), re-using a primitive type for _domain types_ with validity (consistency) constraints means instances of these domain values may not be valid (e.g., `name = "%"` or `name = new string('<', int.MaxValue);`) until being checked. Enter **Primitive Obsession**.

|Hint|
|---|
|Entity Framework "entities" are not the same as Domain-Driven Design "entities." Despite being based on relational entities, Entity Framework considers groups of nested (owned) attributes to be entities even if they don't map to their own table (with key.)|

### Primitive Obsession

_Primitive Obsession_ is a type of code smell<span title="Fowler, M. (2018). &quot;Refactoring: Improving the Design of Existing Code&quot; "><sup>[1]</sup></span> where&mdash;in an object-oriented context&mdash;something that realistically  has unique behavior and semantics has been implemented with a primitive type that doesn't guard that concept's invariants. Primitive Obsession recommends that invariants be abstracted within a unique type so that invalid or inconsistent instances of that type cannot exist.

### Value Object Mapping in Entity Framework

Fortunately, Entity Framework Core supports mapping from domain-specific value types to database primitive types. The domain-specific types then maintain their consistency, and correct usage is enforced.

|Note|
|---|
|The converse is also important; not all uses of primitive types need to be abstracted away within a custom domain type. For example, a domain type may have attributes that realistically won't have values outside a specific range, but a type does not need to be created to abstract a primitive type. For example, making a `Length` value type that wraps an integer value that provides no added value increases complexity rather than reduces it.|

I've encountered some complex domains that treat identity very specifically. In cases like this, custom value types like _Identifier_ that may use one of many primitive types are created to abstract the underlying primitive type. For example, a high-level view of an Identifier class (that doesn't include details like validation, parsing, etc.):

```csharp
public record Identifier<T> where T : struct, IEquatable<T>
{
    private readonly T _value;
    public Identifier(T value) => _value = value;
}
```

Implemented as a `record`, `Identifer<T>` operates as a value type (`struct`, at the runtime level to implement a domain-level _value type_) and provides equality and isolation (`Identifier<int>` is not the same as `Identifier<Guid>`. They cannot be equal, or compared.)

Inferring the mapping of instances of this type to primitive database column types isn't possible (and EF will let you know with an `InvalidOperationException` detailing _The 'Identifier' property 'ShippingCompany.Identifier' could not be mapped because the database provider does not support this type._ We need to tell Entity Framework Core how to map to a type the database provider supports. This is done with the `PropertyBuilder<TProperty>.HasConversion` method when configuring the containing entity type.

```csharp
protected override void OnModelCreating(ModelBuilder modelBuilder)
{
    modelBuilder
        .Entity<ShippingCompany>()
        .Property(e => e.Identifer)
        .HasConversion(identifier => identifer.Value, value => new Identifier<Guid>(value));
}
```

The above shows how you can address Primitive Obsession when using Entity Framework but, it assumes that you're directly persisting domain objects through Entity Framework. Focusing on behavior over attributes in a domain may not make all domain objects persistable by Entity Framework. Still, you can at least push off the mapping of non-primitive value types to Entity Framework if you don't want to introduce another layer of mapping (treating the types persisted via Entity Framework as persistence DTOs).  You could still have a non-primitive-DTO (e.g., `IdentifierDto`) persisted through Entity Framework.  I'll leave it up to you to decide if that's "proper" for your domain.

### References

- \[1\]: [Refactoring: Improving the Design of Existing Code][1]
- [Replace Data Value With Object Refactoring][replace-data-value-with-object]

[1]: https://amzn.to/3KkcnDT
[replace-data-value-with-object]: https://wiki.c2.com/?ReplaceDataValueWithObject
[ef-value-conversions]: https://learn.microsoft.com/en-us/ef/core/modeling/value-conversions?tabs=data-annotations
