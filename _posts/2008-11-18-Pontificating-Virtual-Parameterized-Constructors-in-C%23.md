---
layout: post
title: Pontificating Virtual Parameterized Constructors in C#
date:   2008-11-17 19:00:00 -0500
categories: ['AntiPattern', 'C#', 'OOD', 'Patterns', 'Pontification', 'Software Development']
tags:
- msmvps
---
[Source](http://blogs.msmvps.com/peterritchie/2008/11/18/pontificating-virtual-parameterized-constructors-in-c/ "Permalink to Pontificating Virtual Parameterized Constructors in C#")

# Pontificating Virtual Parameterized Constructors in C#

[Tom Hollander recently posted][1] about a change he required to the Enterprise Library for date/time validation.  He had to create a new class (rather than modify the Enterprise Library) that derived from another, defective class.  One of his complaints was that in order to effectively implement the base class he had to also write matching constructors that simply called the base class.  His suggestion was effectively to add the concept of virtual parameterized constructors to C#.  I detail "parameterized constructors" because C# already effectively has virtual default constructors.  In the following example the base constructor (Form()) is automatically called by the derivative:

    public class MyForm : Form

    {

        public MyForm()

        {

        }

    }

Virtual parameterized constructors are not new, and from a mere language standpoint this seems reasonable.  Pragmatically though, I believe, this is another story.  It seems logical to be able to simply inherit the parameterized constructors of the base class; but, there are so many times that this isn't the case or some generally accepted principles that would be contravened by a language addition like this. 

Let's first look at the [open/closed principle][2] (OCP).  The OCP suggests classes should be open for extension but closed for modification.  Robert Martin suggests [1] properly designed class hierarchies that obey OCP implement an abstraction; i.e. derive from an abstract class or implement an interface.  For example: 

public interface IShape

{

    void Draw(Graphics graphics);

}

 

public class Rectangle : IShape

{

    //…

    public void Draw(Graphics graphics)

    {

        ///…

    }

}

 

Second, let's look at the "[prefer composition over inheritance][3]" principle.  The effect of a language change like this on a design that prefers composition should be fairly obvious.  Here's an example of this principle: 

public interface IPolygon {

    void Draw(Graphics graphics);

}

public sealed class Polygon {

    private readonly Point[] points;

    public Polygon(Point[] points) {

        this.points = points;

    }

    public void Draw(Graphics graphics) {

        for(int i = 1; i < points.Length; i++) {

            graphics.DrawLine(Pens.Black, points[i-1], points[i]);

        }

    }

}

 

public class Rectangle : IPolygon {

    private readonly Polygon polygon;

    public Rectangle(Point location, Size size) {

        Point[] points = new Point[5];

        points[4] = points[0] = location;

        points[1] = new Point(location.X + size.Width, location.Y);

        points[2] = new Point(location.X + size.Width, location.Y + size.Height);

        points[3] = new Point(location.X, location.Y + size.Height);

        polygon = new Polygon(points);

    }

    public void Draw(Graphics graphics) {

        polygon.Draw(graphics);

    }

}

 

Obviously there is no way to use virtual parameterized constructors here.

Clearly, designs that take into account OCP and prefer-composition-over-inheritance would not benefit from a "virtual parameterized constructor" language addition. 

Finally, let's look at why a class might have many constructors causing such friction for derivatives.  There's many reasons why a class might have many constructors.  I believe all are indications of a poorly designed class.  My first thought would be that many constructors is a result of a large class and that the large-class-code-smell should be an indication for redesign.  A large class could be in an indication of a motherclass; but in either case this is likely a single responsibility principle (SRP) violation and the class is doing much more than it should and be redesigned.  If the class isn't large but has many constructors, this was likely done not in response to how the class should/would be used but to cover every possible way of constructing the type.  This would then be a [YAGNI][4] violation and the number of constructors should simply be pared down. 

But, what about when you have to deal with poorly design hierarchies and don't have the ability to modify them?  A valid point; but, simply for the lack of friction of writing pass-through constructors I don't think adding to the language to support poorly designed classes is a good for the language or its developers. 

While an addition like virtual parameterized constructors seems benign, its limited actual usefulness makes the effort not worth the reward.  Plus, it introduces greater abilities to create poorly designed types. 

[1] <http://www.objectmentor.com/resources/articles/ocp.pdf>

[1]: http://blogs.msdn.com/tomholl/archive/2008/11/18/constructors-and-inheritance-why-is-this-still-so-painful.aspx
[2]: http://en.wikipedia.org/wiki/Open/closed_principle
[3]: http://www.ubookcase.com/book/Addison.Wesley/CPP.Coding.Standards.101.Rules.Guidelines.and.Best.Practices/0321113586/ch34lev1sec2.html
[4]: http://en.wikipedia.org/wiki/You_Ain't_Gonna_Need_It

