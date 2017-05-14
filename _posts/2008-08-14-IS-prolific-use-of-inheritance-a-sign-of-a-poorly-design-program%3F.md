---
layout: post
title: IS prolific use of inheritance a sign of a poorly design program?
date:   2008-08-13 12:00:00 -0600
categories: ['Uncategorized']
tags:
- msmvps
---
[Source](http://blogs.msmvps.com/peterritchie/2008/08/14/is-inheritance-a-sign-of-a-poorly-design-program/ "Permalink to IS prolific use of inheritance a sign of a poorly design program?")

# IS prolific use of inheritance a sign of a poorly design program?

A principle that is used to validate inheritance is Liskov Substitution principle (LSP).  Basically, it implies that a subtype must be interchangeable with its super-type without adverse side effect.

With this principle in mind it's easy to discount many particular sub/super-type inheritances.  The quintessential Uncle Bob example of a Liskov Substitution violation are Rectangle and Square.  In geometry a Square is a type of Rectangle (and Rectangle is a type of polygon, etc…); but that maxim doesn't hold true in most OO implementations in light of LSP.

Let's say we implement a Rectangle class like this:

    public class Rectangle {

        private int width;

        private int height;

 

        public virtual int Width {

            get { return width; }

            set { width = value; }

        }

 

        public virtual int Height {

            get { return height; }

            set { height = value; }

        }

    }

 And we wrote unit tests like this:

    [TestFixture]

    public class RectangleTests {

        [Test]

        public void WhenWidthChanged_EnsureHeightUnchanged() {

            Rectangle rectangle = new Rectangle(10, 20);

            rectangle.Width = 30;

            Assert.AreEqual(rectangle.Height, 20);

        }

    }

Now, we know that a square is a specialized rectangle whose width and height are equal.  So, we'd be tempted to write Square like this:

    public class Square : Rectangle {

        public override int Height {

            get {

                return base.Height;

            }

            set {

                base.Height = value;

                base.Width = value;

            }

        }

        public override int Width {

            get {

                return base.Width;

            }

            set {

                base.Width = value;

                base.Height = value;

            }

        }

    }

 If we no substituted a Square object for the Rectangle object in the WhenWidthChanged_EnsureHeightUnchanged test (e.g. we registered Square for type Rectangle in our IoC) we'd get a failure.

In the same grain as Liskov, I believe that every non-static super-type should be used within the code base–meaning not only should a subtype be substitutable for a super-type but that subtype **must** be substituted at least somewhere in the code base.

I call this the Tangible Super-type principle.  Like a corollary to LSP, it states that every super type must be substituted by one or more subtypes.

This means I believe inheritance should be used for IS-A relationships.  It also means I don't believe inheritance is a means of sharing code.  I would suggest using something like the Service Pattern instead of "abstract" super-types.  And yes, this means I think there are better alternatives to the Layer Super-type pattern.

