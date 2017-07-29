---
layout: post
title: Bridges, Facades, and Adapters
date: 2017-07-28 23:32:00 -0500
categories: ['Software', 'Patterns']
comments: true
excerpt: "Avoiding confusiong when dealing with the structural patterns Bridge, Façade, and Adapter."
---
# Bridges, Facades, and Adapters
I try to keep up with my craft by doing a fair amount of reading.  And to be honest, patterns are a great tool for me to communicate with my teams and members of the community in order to convey complex concepts.  Some patterns are easy to grok, but some are very subtle.  Bridge, Adapter, and Façade are such subtle structural patterns that I've noticed considerable confusion in some of the material I've read and with some of the people I talked to.  These patterns are very similar in some ways, but have very different applications.  I hope to reduce the confusion of these patterns with this post.

[Bridge], [Adapter], and [Façade] are similar: they are all about providing a more useful interface.  How and why they produce those interfaces are very different.

Let's first look at some of the principles behind each pattern.

## Principles
*Bridge*: to decouple an abstraction from its implementations so that they can vary independently.

*Façade*: provide a simplified interface to a larger body of code.

*Adapter*: allows incompatible interfaces to work together by wrapping an already existing interface.

## Subtleties
*Bridge*: Bridge is about decoupling an abstraction from its implementations.  This means it provides an abstraction to an abstraction; or in other words it's about the interaction of three things.

*Façade*: Façade is about providing a simpler abstraction to an existing interface.  This means it provides an abstraction to  set of interfaces

*Adapter*: Adapter is about providing an interface that accepts existing data formats to translate to other formats used by another interface.

## Adapter Deep Dive
An an Adapter is effectively a function or a transformation.  It transforms one set of data compatible with a known interface into a set of data compatible with another known interface. At its most complex, it's still only dealing with transformation/mapping--providing an abstraction to *how to transform* data, not an abstraction from the data.  It's a one-to-one relationship between two interfaces that existed before the Adapter.  If we viewed it in a method calling context: something like this:

```csharp
var result = ExternalInterface(AdaptToExternal(internalData));
```

### Possible Adapter Pattern Specializations
[Mapper] ([Object-Relational] aka ORM, [Data Access Object] aka DAO), [ActiveRecord].

## Façade Deep Dive
A Façade at it's simplest can act like an Adapter but it provides an abstraction to an interface rather than data: a simple pass-through Façade that performs some adaption.  An Adapter pattern could be used in a Façade or Bridge, but the Adapter pattern would be implemented independently from the implementation of either of other two.  e.g. some sort of Adapter class or method would exist regardless of the Façade or Bridge implementation.  At its most complex, a Façade is a managed workflow or a process that integrates several independent interfaces along with state to provide a new, simpler interface.  i.e. a Façade can abstract behavior while being a structural pattern.  It's a one-to-many relationship between interfaces.  At the heart of both. the Bridge and the Adapter is to provide a more useful (better) interface, which is common to Façade, but it's the purpose of that new interface that distinguishes it as one pattern or another.

We often think of these patterns are the interface or class level; but they're applicable more broadly. Extension methods, for instance, can be a good example of a Façade implementation.  The following extension method is from Productivity Extensions:
```csharp
public static bool ReferencesMethod<T>(this Type sourceType, Expression<Action<T>> func)
{
	if (sourceType == null)
	{
		throw new ArgumentNullException(nameof(sourceType));
	}

	if (func == null)
	{
		throw new ArgumentNullException(nameof(func));
	}

	var methodCallExpression = func.Body as MethodCallExpression;
	if (methodCallExpression == null)
	{
		return false;
	}

	MethodInfo memberInfo = methodCallExpression.Method;
	MethodInfo getTypeMethodInfo = typeof(object).GetMethods().Single(x => x.Name == "GetType"); // && x.GetParameters().Count() == 0 && x.ReflectedType == typeof(Object));
	bool getTypeCall = memberInfo == getTypeMethodInfo;

	foreach (var methodInfo in sourceType.GetMethods())
	{
		var methodBody = methodInfo.GetMethodBody();
		if (methodBody == null)
		{
			continue;
		}

		var il = methodBody.GetILAsByteArray();
		IEnumerable<IlInstruction> instructions = GetMethodInstructions(methodInfo, sourceType.Module, il);

		for (int i = 0; i < instructions.Count(); ++i)
		{
			var instruction = instructions.ElementAt(i);
			if (getTypeCall && instruction.Code == OpCodes.Ldtoken && i < instructions.Count() && instructions.ElementAt(i + 1).Code == OpCodes.Call)
			{
				var calledMethodInfo = instructions.ElementAt(i + 1).Operand as MethodInfo;
				if (calledMethodInfo == null)
				{
					continue;
				}

				if (calledMethodInfo == typeof(Type).GetMethods().Single(x => x.Name == "GetTypeFromHandle"))
				{
					return true;
				}
			}

			if (instruction.Code == OpCodes.Call || instruction.Code == OpCodes.Callvirt)
			{
				var calledMethodInfo = instruction.Operand as MethodInfo;
				if (calledMethodInfo == null)
				{
					continue;
				}

				if (calledMethodInfo == memberInfo)
				{
					return true;
				}
			}
		}
	}

	return false;
}
```
Obviously, the interfaces are there to figure out if a particular method is referenced within a type, but `ReferencesMethod` provides a more convenient interface (a façade).

## Bridge Deep Dive
The Bridge provides a third interface (abstraction) so that one known interface never needs to be coupled to by a future unknown interface.  A Bridge is very useful in some languages/frameworks to provide compile-time independence between two implementations.  You often want a bidirectional independence in Bridges and as such the interfaces are often in their own link-time unit (class library).  The code that uses the Bridge is decoupled from and implementation of the a Bridge as well as whatever the Bridge is bridging to (so bridge implementations and what they bridge to can be implementated after the fact).  Façade is used when defining what is being bridged to because Bridge is used to abstract multiple implementations and often need that Façade interface to provide a better (consistent) interface.

For me, an example really helps my understanding.  Here are some example interfaces to support a Bridge pattern (the Abstraction and Implementor from the pattern):
```csharp
namespace Primitives
{
    public interface IShapeBridgeAbstraction
    {
        void Draw();
    }

    public interface IGraphicalViewBridgeImplementor
    {
        void DrawCircle(double x, double y, double radius);
    }
}
```
Then, implementations of those interfaces provided by another party (vendor?):
```csharp
namespace VendorX
{
    using Primitives;

    public class GraphicalViewBridgeConcreteImplementor : IGraphicalViewBridgeImplementor
    {
        void DrawCircle(double x, double y, double radius);
    }

    public class CircleShapeBridgeRefinedAbstraction : IShapeBridgeAbstraction
    {
        double x, y, radius;
        IGraphicalViewBridgeImplementor view;
        public void CircleShapeBridgeRefinedAbstraction(double x, double y, double radius, IGraphicalViewBridgeImplementor view)
        {
            this.x = x;
            this.y = y;
            this.radius = radius;
            this.view = view;
        }

        public void Draw()
        {
            view.DrawCircle(x, y, radius);
        }
    }
}
```
Or, to get away from the pattern-parlance:
```csharp
namespace Primitives
{
    public interface IShape
    {
        void Draw();
    }

    public interface IGraphicalView
    {
        void DrawCircle(double x, double y, double radius);
    }
}
```
And:
```csharp
namespace Microsoft
{
    using Primitives;

    public class WinFormsGraphicalView : IGraphicalView
    {
        void DrawCircle(double x, double y, double radius);
    }

    public class WinFormsCircleShape : IShape
    {
        double x, y, radius;
        IGraphicalView view;
        public void WinFormsCircleShape(double x, double y, double radius, IGraphicalView view)
        {
            this.x = x;
            this.y = y;
            this.radius = radius;
            this.view = view;
        }

        public void Draw()
        {
            view.DrawCircle(x, y, radius);
        }
    }
}
```
### Possible Bridge Pattern Specializations
[PImpl], Driver, [Mediator]

## Final Thoughts
An important thing to remember is the category of the pattern.  Adapter, Façade, and Bridge are structural patterns.  Their intention is to provide benefits to the structure of a body software through composition.  Another category of patterns is behavioral; which attempt to improve cohesion by separating responsibilities through composition.  The mediator pattern may structurally be a Bridge pattern but its use is to achieve a separation of communication behavior responsibilities.  i.e. certain structural considerations are needed to obtain separation of responsibilities: to implement cohesive mediation behavior, you may need a Bridge structure.

[PImpl]: http://wiki.c2.com/?PimplIdiom
[Mediator]: https://en.wikipedia.org/wiki/Mediator_pattern
[Mapper]: https://en.wikipedia.org/wiki/Data_mapper_pattern
[Object-Relational]: https://en.wikipedia.org/wiki/Object-relational_mapping
[Data Access Object]: https://en.wikipedia.org/wiki/Data_access_object
[ActiveRecord]: https://en.wikipedia.org/wiki/Active_record_pattern
[Bridge]: https://en.wikipedia.org/wiki/Bridge_pattern
[Adapter]: https://en.wikipedia.org/wiki/Adapter_pattern
[Façade]: https://en.wikipedia.org/wiki/Facade_pattern
