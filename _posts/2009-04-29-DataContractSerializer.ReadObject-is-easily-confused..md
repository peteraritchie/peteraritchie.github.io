---
layout: post
title: DataContractSerializer.ReadObject is easily confused.
date:   2009-04-28 12:00:00 -0600
categories: ['.NET 3.5', 'C#', 'WCF']
tags:
- msmvps
---
[Source](http://blogs.msmvps.com/peterritchie/2009/04/29/datacontractserializer-readobject-is-easily-confused/ "Permalink to DataContractSerializer.ReadObject is easily confused.")

# DataContractSerializer.ReadObject is easily confused.

With WCF services you need to declare contracts and generate contract classes that encapsulate those contracts.  Most of the time you can simply let the framework deal with whatever it needs to do to deal with these objects.  Sometimes, you need to actually see without running a service what XML would result from a contract object or serialize a contract object from XML text. 

In .NET 3.5 there exists the System.Runtime.Serialization.DataContractSerializer class that perform serialization of data contracts. 

Based on its documentation it seems fairly simple to create data contract object to/from XML methods.  For example: 

    public static T XmlToContractObject<T>(string xml) where T : class, IExtensibleDataObject

    {

        MemoryStream memoryStream = new MemoryStream(Encoding.Unicode.GetBytes(xml));

        using (

        XmlDictionaryReader reader = XmlDictionaryReader.CreateTextReader(memoryStream, Encoding.Unicode,

                   new XmlDictionaryReaderQuotas(), null))

        {

            DataContractSerializer dataContractSerializer = new DataContractSerializer(typeof(T));

            return dataContractSerializer.ReadObject(reader) as T;

        }

    }

 

    public static string ContractObjectToXml<T>(T obj) where T : IExtensibleDataObject

    {

        DataContractSerializer dataContractSerializer = new DataContractSerializer(obj.GetType());

 

        String text;

        using (MemoryStream memoryStream = new MemoryStream())

        {

            dataContractSerializer.WriteObject(memoryStream, obj);

 

            text = Encoding.UTF8.GetString(memoryStream.GetBuffer());

        }

        return text;

    }

But, when you try to perform a round-trip from a contract object to XML and back you'll notice that you get SerializationException with the cryptic message of "There was an error deserializing the object of type <sometype>.  The data at the root level is invalid", despite that the XML seems view when examined. 

When Encoding.UTF8.GetString is called, it literally translates the entire array into a String object.  This means that it reads any and all 0 bytes in the array and dumps out null characters (") into the string.  Why do I mention this?  Well, MemoryStream uses a self-expanding buffer to write to.  When MemoryStream runs out of space in its buffer, it doubles the size of the buffer, zeroes it out, then copies the original buffer to the start of the new buffer.  When MemoryStream.GetBuffer is called it simply gets a reference to this buffer, regardless of how many bytes have been written to the stream.  So, most of the time you get a buffer with zeroes padded to the end of it. 

If you look closely at the resulting XML, there are a bunch of " characters at the end of the string. 

As it turns out, DataContractSerializer.ReadObject (or something it calls) doesn't like all the extra null characters and this is the cause of the SerializationException. 

Irritating as this may be, the fix is fairly straightforward.  Simply, create a new buffer equal to the length of the stream and copy the data from the MemoryStream buffer to the new one–trimming all the extra zeroes.  For example: 

    public static string ContractObjectToXml<T>(T obj) where T : IExtensibleDataObject

    {

        DataContractSerializer dataContractSerializer = new DataContractSerializer(obj.GetType());

 

        String text;

        using (MemoryStream memoryStream = new MemoryStream())

        {

            dataContractSerializer.WriteObject(memoryStream, obj);

**            byte[] data = new byte[memoryStream.Length];**

**            Array.Copy(memoryStream.GetBuffer(), data, data.Length);**

 

            text = Encoding.UTF8.GetString(data);

        }

        return text;

    }

