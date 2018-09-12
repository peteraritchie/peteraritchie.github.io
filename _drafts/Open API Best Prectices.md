open api best practices

# REST (OpenAPI is about REST)
Open API (formerlly Swagger) is a specficiation for vendor-neutral, machine-readable interface files for describing, producing, consuming, and visualizing RESTful APIs.

## Avoid RPC
RPC or Remote Procedure Calls, is a form of inter-process communication. RPC attempts to make the ability to perform a task available on a network.  RPC attempts to model requesting the excution of a procedure: something that is given parameters, executes, and then provides results.  Procedures are typically named with a verb to signify the act of doing something.

RPC is meant to provide the ability to execute a particular procedure or function in another address space.  It is a request-response protocol that is synchronous at the procedure level.  RPC is really just a remote representation of a procedure and provides only location transparency.  RPC-style is meant to easily port procedural or imperative code to use remote resources.  Typically RPC calls match name and argument ordering of the implemented procedure.  Any changes to the signature of the procedure are echoed in the RPC signature, resulting in a tight coupling to the implementation.

See also [Prefer Message-passing](#message-passing)

### Succeeding
If you find that you're providing APIs that are mostly verbs, you may be using the RPC-style.  If you're implementing in HTTP, maintain the native semantics: consider the end-point a resource that can be acted upon with one or more of the standard verbs (POST, GET, PATCH, DELETE, PUT).

If you find that standard HTTP status codes are not representative of the URIs status, consider you may be using RPC-style.

## <a name="message-passing" />Use Message-passing Semantics (REST Communicates Resource Representations)
Message-passing differs from RPC and other imperative styles such that the request is not a request to invoke a particular procedure or function, but to send information (message) for processing and possible response.  The sending/receipt of the message is independent of the processing and indepdent of a response.

### Succeeding
If you find that the name of the API describes the action to be performed more than the content of the request, you might not be following message-passing style.
If sending a message is blocked until the message is processed, you might be implementing an RPC model.

# Resources

# Collections

# Naming
Nouns for URLs

# Use HTTP Verbs Correctly

|Verb|Description|
|----|-----------|
|GET|U|
|POST|U|
|PUT|U|
|PATCH|U|
|DELETE|U|


# Standardized Naming (Use The Same Name For The Same Thing)
A RESTful API provides an interface to access and manipulate a textually representation of a *resource*.  A resource is ["anything that can be named"][fielding-resources].

REST APIs are a means to allow two components to interoperate--i.e. a realization of the relationship between those two components.  The resource used to represent what is communicated should be based on something conceptually--typically a business or domain concept.  It should be independent of logical information and implementation details.  That concept should be structural, not behavioral.  That **name should have the part of speech of a noun**, not a verb.

See also [Ubiquitous Language][DDD]

### Succeeding
If it can be named, the name of the resource (and thus that API) should be a noun.  If you find that your resource names are verbs, you might be designing in RPC-style.
If there is more than one name for something, before settling on a single name, be sure that they're not named two different things because they need to be distinguishable from one another.
If you find a resource is causing a high degree of coupling, it may not be conceptual enough.
If naming is based on technical details, dig deeper into what conceptual resource should be represented.

## standardized data models (Use The Same Format For the Same Type of Data)
Along the same likes as naming (i.e. use the same name for the same thing), the same type of data should have the same format.

### Succeeding
If you find that deciding on one format results in much redundant data, consider a fine-grained types.  (e.g. only ISO 8601 combined date and time, instead of also ISO 8601 date, ISO 8601 time, etc.)

## standardized policies
Each REST API deals with a resource, a representation of that resource, as well as behavior fulfilling a request.  A policy describes the terms of use for that API.  That includes a defined or expected level of service often referred to a Service Level Aggreement (SLA).  SLAs are typically descriptions of the quality attribute requirements of a system or interface.  These could involve a number of things like performance, latency, mean-time-to-failure, scalability, reliability, etc.  In order to be a policy, it must be objective, measurable, reasonable, attainable, and enforcable.

### Succeeding

# Use OpenAPI to Define/Describe APIs
OpenAPI 3.0.1 is now considered the [de facto standard](https://www.infoq.com/articles/open-api-initiative-update) for API descriptions on the web.

# What to Document
##Authentication
##Error Messages
##Resources
##Terms of use
##Versioning/Change log
##Include Every API Call and Every Response

# decompose complex domains into multiple domains

["total unification of the domain model for a large system will not be feasible or cost-effective"][DDD].  It has become apparent that software systems are like any other task: breaking larger tasks into many smaller ones is easier to manage and more efficient.  Domain models are the same way.  By breaking a domain into smaller parts, with clear separation between the parts, the domain can be implemented easier and with greater quality.
There are many ways to break down any task, domains are no exception.  When breaking down domains, it is important that their breakdown models what is important and unique to the business.  For example, a Debt domain could be broken down into three domains: Mortgage, Credit Card, and Education.
[Conway's law][conway] also comes into play here.  Conway's law suggests that software structure mirrors organization communication structure in many ways.  So, if you organization has many team, and many sub-teams, that communication structure will work agains the software structure (and vice versa).
When dealing with multiple domains that interoperate, ensure that the boundary of those domains contain abstractions based on the concepts of that domain to insulate the implementation details from the other components/domains.

See also [Bounded Context][DDD]

## Succeeding
When breaking down a domain into smaller parts, if the names of those parts are not representative of something in the domain/business, it may not be broken down in the right way.
See also [Domain-Driven Design][DDD].

# Versioning
API requests and responses are a contract.  If, after deployment, a change is necessary; first consider *why*.  Is this a new version of the request or response, or another version of the API?  If it's another version of the API, why does it have the same name (URL?).  Consider naming the API something new to accommodate this type of context change.

## Succeeding
- Version APIs when fixing the API
- Create new APIs when implementing new functionality

# Prefer YAML
APIs can be defined in JSON or YAML.  YAML is a variant of JSON, in fact an offical subset.  But, it's a lot less verbose.  While Open API supports JSON for defineing APIs, prefer to use YAML.  It's easier to read and write.

# Use References for Duplicate Information
Many concepts in a single API can be used many times.  Rather than re-enter or copy/paste the information around the definition file, put it in one place and reference from other places.
```yaml
components:
  schemas:
    User:
      properties:
        id:
          type: integer
        name:
          type: string
#...
responses:
  '200':
    description: The response
    schema: 
      $ref: '#/components/schemas/User'
#...
```
Note the single quote around the reference because `#` specifies a comment.

# Use External References
APIs can get very complex.  APIs share concepts, especially within the same domain.  `$ref` syntax also supports external references. Rather than trying to manage the duplicated information in a large definition file, break the API definition into reusable files.

```yaml
#...
responses:
  '200':
    description: The response
    schema: 
      $ref: '../definitions/User.yaml'
#...
```

```yaml
    User:
      properties:
        id:
          type: integer
        name:
          type: string
```

# recognize real-time use cases
Real-time


# References

https://swaggerhub.com/blog/api-design/api-design-best-practices/
https://app.swaggerhub.com/help/domains/about-domains?_ga=2.229671582.308687186.1513554868-1878798599.1513554868
https://www.blazemeter.com/blog/whats-new-in-swagger-open-api3

[fielding-resources]: https://www.ics.uci.edu/~fielding/pubs/dissertation/rest_arch_style.htm#sec_5_2_1_1

[DDD]: https://www.amazon.com/gp/product/0321125215?ie=UTF8&tag=martinfowlerc-20&linkCode=as2&camp=1789&creative=9325&creativeASIN=0321125215

[conway]: https://en.wikipedia.org/wiki/Conway%27s_law