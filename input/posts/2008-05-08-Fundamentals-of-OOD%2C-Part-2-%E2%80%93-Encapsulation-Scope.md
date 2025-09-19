---
layout: post
title: 'Fundamentals of OOD, Part 2 – Encapsulation Scope'
tags: ['C#', 'Design/Coding Guidance', 'DevCenterPost', 'Software Development', 'msmvps']
---
[Source](http://blogs.msmvps.com/peterritchie/2008/05/08/fundamentals-of-ood-part-2-encapsulation-scope/ "Permalink to Fundamentals of OOD, Part 2 – Encapsulation Scope")

# Fundamentals of OOD, Part 2 – Encapsulation Scope

Let's look at the ubiquitous Person concept. It might seem logical that an application that deals with people should have a Person interface for classes to implement. For example:

public interface IPerson  
{  
 String GivenName { get; set; }  
 String SurName { get; set; }  
 IAddress Address { get; set; }  
}

At first glance this seems fine. The IPerson interface defines attributes that the application uses with most scenarios dealing with types of IPerson, it's "well encapsulated". But, the person concept is much more broad than what IPerson is modeling. IPerson hasn't fully encapsulated the person concept. A person could have parents, age, weight, height, etc. The application doesn't need this information so it's narrowed the concept of person to fit its needs. This is an incomplete abstraction. The type that the application needs (that is currently IPerson) should be fully abstract. Based on the IPerson interface, a better abstraction would be ILocatableIndividual.

Let's look at the opposite of not fully encapsulating a concept. 

Let's look at another common concept, the Invoice:

public class Invoice  
{  
 Customer BillToCustomer { get;set; }  
 Customer ShipToCustomer { get;set; }  
 Datetime InvoiceDate;  
 ICollection<InvoiceItem> InvoiceItems { get; }  
 Single ShippingAndHandlingPrice { get; set; }  
 Single CalculateSubTotal();  
 Single CalculateTotal();  
 Single CalculateGrandTotal();  
 PurchaseOrder PurchaseOrder { get; set; }  
 void Print();  
}

Again, seems like a reasonable encapsulation; but it has an issue. 

There's a fundamental principle of OOD called the Single Responsibility Principle. Robert Martin interprets the principle as "there should never be more than one reason for a class to change.". A class should model a single abstraction. For that abstraction to remain abstract the modeled class should have a single responsibility. In the case of Invoice, the invoice concept should only model behaviours and attributes of an invoice. An invoice does not print, something or someone else prints it. With the above Invoice definition should printing need to change Invoice must also change, event though what the invoice *is* doesn't change. Invoice is now coupled to how printing occurs. In Martin's terms, Invoice now has two reasons for it to change: when invoice attributes change, and when how printing occurs changes. 

The Invoice class should be refactored by moving the Print method to another class. Likely this would involve MVC, or MVP where a view would be responsible for the "printed view" and a controller or presenter would be responsible for communicating with the model (Invoice).  



![kick it on DotNetKicks.com][1]

[1]: http://www.dotnetkicks.com/Services/Images/KickItImageGenerator.ashx?url=http%3a%2f%2fmsmvps.com%2fblogs%2fpeterritchie%2farchive%2f2008%2f05%2f08%2ffundamentals-of-ood-part-2-encapsulation-scope.aspx


