---
layout: post
title: 'Unit testing WCF data contract serialization.'
tags: ['C#', 'WCF', 'msmvps']
---
[Source](http://blogs.msmvps.com/peterritchie/2009/05/04/unit-testing-wcf-data-contract-serialization/ "Permalink to Unit testing WCF data contract serialization.")

# Unit testing WCF data contract serialization.

WCF service define "data contracts" for their interfaces. These contracts are often defined in an XML schema document and used to generated WCF data contract code. This process effectively creates a .NET type that will serialize to a chunk of XML text. 

Depending on the operation of the WCF service, its code may be responsible for creating some of these objects. A return value from an operation, for example. While the framework handles XML serialization of these object behind the scenes. But, if your have complex types and you end up not setting all the properties correctly in your object tracking down what properties haven't been set properly can be a chore as the server would have to enable passing exceptions back to the client, etc. 

A technique that I've found useful is to add unit tests to ensure the creation of my contract objects are indeed serializable. 

For example, I may have an method GetCustomer that retrieves a customer. Where I would like to create this contract Customer I would create a method to create this contract object based on parameters, like a Model Customer object. 

For example: 

 PRI.ExampleWcfService.Customer ToWcfContractCustomer(PRI.Model.Customer customer)

 {

 //…

 } 

Now, one of the unit tests would call this method and attempt to serialize the object to XML text, for example: 

 [Test]

 public void WhenCreatingCustomerContract_EnsureXmlSerializationSucceeds()

 {

 PRI.ExampleWcfService.Model.Customer customer = CustomerRepository.Get(1);

 PRI.ExampleWcfService.Application.Customer contractCustomer = ToWcfContractCustomer(customer);

 String text = Utility.ContractObjectToXml(contractCustomer);

 } 

where Utility.ContractObjectToXml is declared as:

 public static class Utility

 {

 public static string ContractObjectToXml<T>(T obj)

 {

 DataContractSerializer dataContractSerializer = new DataContractSerializer(obj.GetType());



 String text;

 using (MemoryStream memoryStream = new MemoryStream())

 {

 dataContractSerializer.WriteObject(memoryStream, obj);

 byte[] data = new byte[memoryStream.Length];

 Array.Copy(memoryStream.GetBuffer(), data, data.Length);



 text = Encoding.UTF8.GetString(data);

 }

 return text;

 }

 }

Now, when this unit test is run, it will fail if the serialization process throws an exception because the resulting XML would violate the schema. 

See [DataContractSerializer.ReadObject is easily confused] for why I'm creating a new buffer and copying the serialized data before converting it to a string.


