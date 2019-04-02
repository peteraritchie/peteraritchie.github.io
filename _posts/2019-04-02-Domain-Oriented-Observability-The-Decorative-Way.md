---
layout: post
title: "Domain-Oriented Observability: The Decorative Way"
date: 2019-04-02
categories: ['Patterns', 'Decorator', 'Observability']
comments: true
excerpt: "When separating non-domain logic from domain logic, make use patterns for full separation."
---
# Domain-Oriented Observability
I read an interesting article by Pete Hodgson on Martin Fowler's blog/site titled [Domain-Oriented Observability](https://martinfowler.com/articles/domain-oriented-observability.html).  In this article, Pete suggests separating the responsibility of observability out of a domain class that might initially look like this:
```java
  applyDiscountCode(discountCode){
    this.logger.log(`attempting to apply discount code: ${discountCode}`);

    let discount; 
    try {
      discount = this.discountService.lookupDiscount(discountCode);
    } catch (error) {
      this.logger.error('discount lookup failed',error);
      this.metrics.increment(
        'discount-lookup-failure',
        {code:discountCode});
      return 0;
    }
    this.metrics.increment(
      'discount-lookup-success',
      {code:discountCode});

    const amountDiscounted = discount.applyToCart(this);

    this.logger.log(`Discount applied, of amount: ${amountDiscounted}`);
    this.analytics.track('Discount Code Applied',{
      code:discount.code, 
      discount:discount.amount, 
      amountDiscounted:amountDiscounted
    });

    return amountDiscounted;
  }
```

...into something like this:


```java
  applyDiscountCode(discountCode){
    this.instrumentation.applyingDiscountCode(discountCode);

    let discount; 
    try {
      discount = this.discountService.lookupDiscount(discountCode);
    } catch (error) {
      this.instrumentation.discountCodeLookupFailed(discountCode,error);
      return 0;
    }
    this.instrumentation.discountCodeLookupSucceeded(discountCode);

    const amountDiscounted = discount.applyToCart(this);
    this.instrumention.discountApplied(discount,amountDiscounted);/*sic*/
    return amountDiscounted;
  }
```

I applaud the effort to put the responsibility of observability of the applying discounts into a singly-responsible class.  But, the domain-oriented class is still burdened with the responsibility of observability even if it simply delegates to another class.  It's now *also* responsible for knowing about another class/interface, and possibly responsible for instantiating it.

In my mind, this *is* better, but really just trades some responsibilities for others.  And if the shopping cart is composed and the instrumentation class abstracted by an interface this **minimizes** those responsibilities,  but they're still *in* the shopping cart.

When working with team members, my recommendation is to choose composability over mixing responsibilities or concerns in cases like this.  You can do this through the use of the [Decorator Pattern](https://en.wikipedia.org/wiki/Decorator_pattern).  For example, if we create a decorating shopping cart that passes through to a production shopping cart, we can "inject" the observability into the use of that production shopping cart without having to clutter up the domain-oriented class (after all, the point was *cleaning up the mess*):

```csharp
class InstrumentingShoppingCart : IShoppingCart
{
	private readonly IShoppingCart component;
	private readonly DiscountInstrumentation instrumentation;


	public InstrumentingShoppingCart(IShoppingCart component, DiscountInstrumentation instrumentation)
	{
		this.component = component;
		this.instrumentation = instrumentation;
	}

	public float applyDiscountCode(int discountCode)
	{
		this.instrumentation.applyingDiscountCode(discountCode);
		try
		{
			var discountAmount = component.applyDiscountCode(discountCode);
			this.instrumentation.discountCodeLookupSucceeded(discountCode);
			this.instrumentation.discountApplied(discountAmount);
			return discountAmount;
		}
		catch (Exception error)
		{
			this.instrumentation.discountCodeLookupFailed(discountCode, error);
			return 0;
		}
	}
}
```

An `InstrumentingShoppingCart` instance can be used where any `IShoppingCart` is used and can be composed in whatever fashion is necessary (IoC container, Composition Root, etc.).

Now we get instrumentation, instrumentation as a responsibility is separated, *and* the domain-oriented class is not messed up with other concerns and responsibilities.  For example, the original unincumbered method:

```Java
  applyDiscountCode(discountCode){

    let discount; 
    discount = this.discountService.lookupDiscount(discountCode);

    const amountDiscounted = discount.applyToCart(this);
    return amountDiscounted;
  }
```
