---
layout: post
title: 'ETags in ASP.NET Core'
categories: ['ASP.NET', 'ETag', 'Azure', 'Cosmos DB', 'Domain-Driven Design', 'Repository', 'Application Service']
comments: true
excerpt: Dealing with concurrency issues and implementing concurrency control can be intimidating. In this post, I make it less intimidating by clarifying some specifics by showing an example implementation with ASP.NET Core and Azure Cosmos DB. Additionally, the Domain-Driven Design patterns Repository and Application Service are used to isolate etag implementation details from the Web API to delegate that to Azure Cosmos.
tags: ['June 2023', 'ASP.NET', 'ETag', 'Azure', 'Cosmos DB', 'Optimistic Concurrency', 'Domain-Driven Design', 'Repository', 'Application Service']
---
![lots of things going on at the same time, in the style of Farside](../assets/farside-etags-in-asp-dot-net.jpg)

A good software architect doesn't just provide expectations of structure; they also work with developers to give feedback and guidance for implementation. It's easy to say, "Use ETags for entity concurrency control in a Web API," it's another to empower teams to accomplish the objectives of entity versioning.

To review: entity-tags (Etags) are a method of implementing Optimistic Concurrency Control. Optimistic Concurrency Control is a means to avoid distributed locking in situations when two or more potentially concurrent operations rarely interfere with each other. You can see cases like this on the Web when multiple processes or people are not normally working on the same data simultaneously. With the Web, there are rare situations where a single process or single person can (usually inadvertently) modify data from two places at the same time. It's rare case like this where the low overhead of optimistic concurrency can avoid accidental overwrites.

Entity-tags are a moniker of a particular incarnation of an entity. The tag is opaque, so it shouldn't need to be interpretable by a requestor to your service. With opaque data, you want to make the value itself as unobvious as possible. 

The value, of course, could be an incrementing integer if you could reliably and efficiently increment an integer in a distributed environment (remember, we're addressing the possibility of two distributed transactions interfering with one another, the same transactions mechanisms that would be used to increment an integer.)  But, before choosing to increment an integer (an ordinal number), consider [RFC 9110 ETags][rfc9110#etag] and why ordinal version numbers are not specified.

| If you think an ordinal number will work, do you need entity-tags at all?

A time-stamp is something to consider, in which case, prefer the `Last-Modified` header field validator. Or in conjunction with entity-tags. If a time-stamp is reliable, `Last-Modified` offers better interoperability options than re-inventing the wheel. Also, be thoughtful when considering time-stamps, especially their granularity; per-second time-stamp granularity can only partially solve the problem of concurrent writes.

So, how do you reliably generate an entity-tag value? The first thing to consider is what you want to accomplish. Do you want to prevent accidental overwrites, or do you want entity versioning? If you said, "I want entity versioning," to what end? If a client gets version 1, and another client updates it to version 2, what action do you want to perform when the first client requests to update the entity? You don't need _versioning_ to prevent that first client from updating the entity. If you want to merge with version 2, you probably want versioning; in this case, you can stop reading now; I won't get into detail like that in this post.

If we're interested in preventing accidental overwrites, on the server side, we only really care about the current entity and the basis for the current request to update it. It doesn't matter if the basis is the previous version or ten versions behind; we only care that it's not based on the current version.

Another thing to consider is that entity-tags are also used in HTTP caching, which requires that an entity-tag be unique per encoding (e.g., a gzipped response should have a different entity-tag than a non-gzipped response.) The encoding value is often postfixed to the entity-tag to make it unique per encoding. But be careful to parse that out when checking for semantically identical entities. That's out of the scope of this post.

With an understanding of those constraints, a common method of generating an entity-tag is to use a hash of the entity representation.

Let's look at an example controller that tries to isolate the implementation detail of how the entity-tag is calculated. For my examples, I'm choosing to use controllers over minimal APIs; the controller class attributes make some of what is required easier. For clarity, my examples are stripped of error responses unrelated to conditional requests and exception middleware. For complete source, see [this repo].

```csharp
[ApiController] [Route("[controller]")]
public class AppointmentController : ControllerBase
{
	[HttpGet(Name = "GetAppointmentRequests")]
	[ProducesResponseType(typeof(WebCollectionElement<AppointmentRequestDto>[]),
		StatusCodes.Status200OK, MediaTypeNames.Application.Json)]
	public async Task<IActionResult> GetMany(CancellationToken cancellationToken = default)
	{
		var resource = appointmentRequestService.GetRequests(cancellationToken);

		List<WebCollectionElement<AppointmentRequestDto>> items = new();
		foreach (var (dto, guid, concurrencyToken) in await resource.ToListAsync(cancellationToken: cancellationToken))
		{
			items.Add(
				new WebCollectionElement<AppointmentRequestDto>(dto, Url.Action(nameof(GetById),
					new { id = guid })!, etag: concurrencyToken));
		}

		return base.Ok(items);
	}

	[HttpGet("{id}", Name = "GetAppointmentRequest")]
	[ProducesResponseType(typeof(AppointmentRequestDto), StatusCodes.Status200OK, MediaTypeNames.Application.Json)]
	[ProducesResponseType(typeof(AppointmentRequestDto), StatusCodes.Status304NotModified)]
	public async Task<IActionResult> GetById(Guid id, [FromHeader(Name = "If-None-Match")] string? ifNoneMatch,
		CancellationToken cancellationToken = default)
	{
		var (resource, concurrencyToken) = string.IsNullOrWhiteSpace(ifNoneMatch) 
			? await appointmentRequestService.GetRequest(id, cancellationToken) 
			: await appointmentRequestService.GetRequest(id, ifNoneMatch, cancellationToken);

		HttpContext.Response.Headers.Add(HeaderNames.ETag, concurrencyToken);

		return Ok(resource);
	}

	[HttpPost(Name = "CreateAppointmentRequest")]
	[Consumes(MediaTypeNames.Application.Json)]
	[ProducesResponseType(StatusCodes.Status201Created)]
	public async Task<IActionResult> Create([FromBody] AppointmentRequestDto appointmentRequest,
		CancellationToken cancellationToken = default)
	{
		var (id, concurrencyToken) = await appointmentRequestService.CreateRequest(appointmentRequest, cancellationToken);

		HttpContext.Response.Headers.Add(HeaderNames.ETag, concurrencyToken);

		return CreatedAtAction(nameof(GetById), routeValues: new { id }, value: null);
	}

	[HttpPut("{id}", Name = "ReplaceAppointmentRequest")]
	[Consumes(MediaTypeNames.Application.Json)]
	[ProducesResponseType(StatusCodes.Status204NoContent)]
	public async Task<IActionResult> Replace(Guid id, [FromBody] AppointmentRequestDto appointmentRequest,
		[FromHeader(Name = "If-Match")] string? ifMatch, CancellationToken cancellationToken = default)
	{
		var concurrencyToken = string.IsNullOrWhiteSpace(ifMatch)
			? await appointmentRequestService.ReplaceRequest(
				id, appointmentRequest, cancellationToken)
			: await appointmentRequestService.ReplaceRequest(
				id, appointmentRequest, ifMatch, cancellationToken);

		HttpContext.Response.Headers.Add(HeaderNames.ETag, concurrencyToken);

		return NoContent();
	}

	[HttpPatch("{id:guid}", Name = "UpdateAppointmentRequest")]
	[ProducesResponseType(typeof(AppointmentRequestDto), StatusCodes.Status200OK, MediaTypeNames.Application.Json)]
	[Consumes("application/json-patch+json")]
	public async Task<IActionResult> Update(Guid id, JsonPatchDocument<AppointmentRequestDto> patchDocument,
		[FromHeader(Name = "If-Match")] string? ifMatch, CancellationToken cancellationToken = default)
	{
		var (result, concurrencyToken) = string.IsNullOrWhiteSpace(ifMatch)
			? await appointmentRequestService.UpdateRequest(id, patchDocument, cancellationToken)
			: await appointmentRequestService.UpdateRequest(id, patchDocument, ifMatch, cancellationToken);

		HttpContext.Response.Headers.Add(HeaderNames.ETag, concurrencyToken);

		return Ok(result);
	}

	[HttpDelete("{id}", Name = "RemoveAppointmentRequest")]
	[ProducesResponseType(StatusCodes.Status204NoContent)]
	public async Task<IActionResult> Remove(Guid id, [FromHeader(Name = "If-Match")] string? ifMatch,
		CancellationToken cancellationToken = default)
	{
		if(string.IsNullOrWhiteSpace(ifMatch))
			await appointmentRequestService.RemoveRequest(id, cancellationToken);
		else
			await appointmentRequestService.RemoveRequest(id, ifMatch, cancellationToken);

		return NoContent();
	}
}
```

> There are inherent complexities in a Web API. It needs to present an interface usable on the Web and utilizes open standards as much as possible. You'll notice that the `AppointmentController` PATCH implementation uses `JsonPatchDocument`, an implementation of the [JSON Patch][jsonpatch] (IETF RFC 6902) standard. This standard is specific to the Web, specific to JSON, and deals with operations intended to be specifically applied to JSON representations equivalent to the model defined in the interface (i.e., the model, not what is represented in the database or an in-memory representation of a domain object.)

This controller is isolated from the collaboration with the database and delegates that interaction to an Application Service via the `appointmentRequestService` field (declaration removed for readability). In state-modifying HTTP methods (PUT, DELETE, PATCH), the actions have an `ifMatch` parameter passed in through the `If-Match` HTTP request header. When present, it is passed along to the application service for optimistic concurrency. This example shows an _optional_ use of `If-Match`; it's plausible that another implementation might _require_ the `If-Match` header and respond with status code 428 Precondition Required.

Of note is that this controller abstracts etag header values as _concurrency token_ text so that nothing else has to deal with HTTP headers.

Let's look at the MVC model (I prefer to refer to it as a Data Transfer Object).

```csharp
public class AppointmentRequestDto
{
	[Required]
	public DateTime? CreationDate { get; set; }
	public IEnumerable<string>? Categories { get; set; }
	[Required]
	public string? Description { get; set; }
	public string? Notes { get; set; }
	[Required]
	public AppointmentRequestStatus? Status { get; set; }
	[Required]
	public MeetingDuration? Duration { get; set; }
	[Required]
	public IEnumerable<string>? Participants { get; set; }
	[Required]
	public IEnumerable<DateTime>? ProposedStartDateTimes { get; set; }
}
```

Since we're delegating serialization to ASP.NET (which requires writable properties), the properties are nullable but annotated with `RequiredAttribute` to signal to the framework what properties are required. There is no identifier in the `AppointmentRequestDto` class because we don't want to duplicate it there and in the resource's URI.

Azure Cosmos has implemented optimistic concurrency control and stores an ETag per document. I'll use Azure Cosmos for the database implementation to show how this can be re-used in your WebAPI.

## Azure Cosmos Example

In Azure Cosmos, each document has several mandatory properties: `id`, `_rid`, `_self`, `_etag`, `_attachements`, and `_ts`. These are implementation details of the database that we don't want to leak into our API as body content. When we use the [Azure Cosmos SDK], we need serialization classes to serialize the data to and from a container. Let's see an example with a fictitious appointment request resource:

```csharp
public class AppointmentRequestEntity : CosmosEntityBase
{
    [JsonProperty(PropertyName = "id")]
    public Guid Id { get; set; }
    [JsonProperty(PropertyName = "_rid")]
    public string? ResourceId { get; set; }
    [JsonProperty(PropertyName = "_self")]
    public Uri? SelfUri { get; set; }
    [JsonProperty(PropertyName = "_etag")]
    public string? ETag{ get; set; }
    [JsonProperty(PropertyName = "_ts")]
    public int? TimestampText{ get; set; }
	public DateTime? CreationDate { get;  set; }
	public IEnumerable<string>? Categories { get; set; }
	public string? Description { get;  set; }
	public string? Notes { get;  set;  }
	public AppointmentRequestStatus? Status { get;  set; }
	public MeetingDuration? Duration { get;  set; }
	public IEnumerable<string>? Participants { get; set; }
	public IEnumerable<DateTime>? ProposedStartDateTimes { get;  set; }
}
```

Notice the first five properties that are necessary to access the Azure Cosmos implementation details. (in [this repo] this is split out into a `CosmosEntityBase` class.)

For my example, I'm going to draw on Domain-Driven design patterns and use a Repository implementation in the database collaboration. I want to delegate all the logic related to database-specific details to the repository implementation. This includes encapsulating the use of the database entity _serialization_ class (translation to/from the database entity class), associating an identifier and etag with the resource, etc. To separate the existence of the database entity class from clients of the repository, we'll define a generic interface that I'll name `IOptimisticallyConcurrentRepository` that works with different types of domain entity classes:

```csharp
public interface IOptimisticallyConcurrentRepository<TDomainEntity>
{
    Task<TDomainEntity> Get(Guid id, CancellationToken cancellationToken = default);
    IAsyncEnumerable<TDomainEntity> Get(CancellationToken cancellationToken = default);
	Guid GetId(TDomainEntity entity);

	bool TryGetIfModified(Guid id, string concurrencyToken, out TDomainEntity? entity);
	string GetConcurrencyToken(TDomainEntity entity);

    Task<Guid> Add(TDomainEntity entity, CancellationToken cancellationToken = default);
    Task Remove(Guid id, CancellationToken cancellationToken = default);
    Task Replace(Guid id, TDomainEntity entity, CancellationToken cancellationToken = default);

    Task RemoveIfMatch(Guid id, string token, CancellationToken cancellationToken = default);
    Task ReplaceIfMatch(Guid id, TDomainEntity entity, string token, CancellationToken cancellationToken = default);
}
```

Next is a generic repository class to support Azure Cosmos that deals with arbitrary domain (`TDomainEntity`) and database serialization classes (`TDbEntity`):

```csharp
public class CosmosOptimisticallyConcurrentRepository<TDomainEntity, TDbEntity> 
	: IOptimisticallyConcurrentRepository<TDomainEntity>
	where TDomainEntity : class
	where TDbEntity : CosmosEntityBase
{
	private class EntityContext
	{
		public EntityContext(Guid id, string concurrencyToken)
		{
			Id = id;
			ConcurrencyToken = concurrencyToken;
		}

		public Guid Id { get; }
		public string ConcurrencyToken { get; }
	}

	private readonly Container container;
	private readonly ITranslator<TDomainEntity, TDbEntity> dbEntityTranslator;
	private readonly Action<TDbEntity, Guid> setDbEntityId;

	protected CosmosOptimisticallyConcurrentRepository(Container container, ITranslator<TDomainEntity, TDbEntity> dbEntityTranslator,
		Action<TDbEntity, Guid> setDbEntityId)
	{
		this.container = container;
		this.dbEntityTranslator = dbEntityTranslator;
		this.setDbEntityId = setDbEntityId;
	}

	public async Task<Guid> Add(TDomainEntity entity, CancellationToken cancellationToken = default)
	{
		var id = Guid.NewGuid();
		var dbEntity = dbEntityTranslator.ToData(entity);
		setDbEntityId(dbEntity, id);

		try
		{
			var result = await container.CreateItemAsync(dbEntity, new PartitionKey(id.ToString("D")), cancellationToken: cancellationToken);
			conditionalWeakTable.Add(entity, new EntityContext(id, result.ETag));
			return id;
		}
		catch (CosmosException ex) when(ex.StatusCode == HttpStatusCode.PreconditionFailed)
		{
			throw new ConcurrencyException();
		}
	}

	public bool TryGetIfModified(Guid id, string concurrencyToken, out TDomainEntity? entity)
	{
		var idText = id.ToString("D");
		try
		{
			var result = container.ReadItemAsync<TDbEntity>(
					idText,
					new PartitionKey(idText),
					requestOptions: new ItemRequestOptions() { IfNoneMatchEtag = concurrencyToken })
				.Result;

			entity = dbEntityTranslator.ToDomain(result.Resource);
			conditionalWeakTable.Add(entity, new EntityContext(id, result.ETag));
			return true;
		}
		catch (AggregateException aggregateException) when (aggregateException.InnerExceptions.Count == 1 &&
		                                                    aggregateException.InnerExceptions.Single() is
			                                                    CosmosException
			                                                    {
				                                                    StatusCode: HttpStatusCode.NotModified
			                                                    })
		{
			entity = default;
			return false;
		}
		catch (AggregateException aggregateException) when (aggregateException.InnerExceptions.Count == 1 &&
		                                                    aggregateException.InnerExceptions.Single() is
			                                                    CosmosException
			                                                    {
				                                                    StatusCode: HttpStatusCode.NotFound
			                                                    })
		{
			throw new EntityNotFoundException(id);
		}
		catch (CosmosException ex) when(ex.StatusCode == HttpStatusCode.NotFound)
		{
			throw new EntityNotFoundException(id);
		}
	}

	public async IAsyncEnumerable<TDomainEntity> Get([EnumeratorCancellation] CancellationToken cancellationToken = default)
	{
		var iterator = container.GetItemQueryIterator<TDbEntity>();
		while (iterator.HasMoreResults)
		{
			var set = await iterator.ReadNextAsync(cancellationToken);
			foreach (var e in set)
			{
				var entity = dbEntityTranslator.ToDomain(e);
				conditionalWeakTable.Add(entity, new EntityContext(e.Id, e.ETag!));
				yield return entity;
			}
		}
	}

	public async Task<TDomainEntity> Get(Guid id, CancellationToken cancellationToken = default)
	{
		var idText = id.ToString("D");
		try
		{
			var result = await container.ReadItemAsync<TDbEntity>(idText, new PartitionKey(idText), cancellationToken: cancellationToken);
			var entity = dbEntityTranslator.ToDomain(result.Resource);
			conditionalWeakTable.Add(entity, new EntityContext(id, result.ETag));
			return entity;
		}
		catch (CosmosException ex) when(ex.StatusCode == HttpStatusCode.NotFound)
		{
			throw new EntityNotFoundException(id);
		}
	}

	public async Task Replace(Guid id, TDomainEntity entity, CancellationToken cancellationToken = default)
	{
		var dbEntity = dbEntityTranslator.ToData(entity);
		setDbEntityId(dbEntity, id);

		try
		{
			_ = await container.UpsertItemAsync(dbEntity, cancellationToken: cancellationToken);
		}
		catch (CosmosException ex) when(ex.StatusCode == HttpStatusCode.NotFound)
		{
			throw new EntityNotFoundException(id);
		}
	}

	public async Task ReplaceIfMatch(Guid id, TDomainEntity entity, string token, CancellationToken cancellationToken = default)
	{
		var idText = id.ToString("D");
		var dbEntity = dbEntityTranslator.ToData(entity);
		setDbEntityId(dbEntity, id);

		var requestOptions = new ItemRequestOptions { IfMatchEtag = token };
		try
		{
			_ = await container.ReplaceItemAsync(dbEntity, idText, new PartitionKey(idText), requestOptions: requestOptions, cancellationToken: cancellationToken);
		}
		catch (CosmosException ex) when (ex.StatusCode == HttpStatusCode.PreconditionFailed)
		{
			throw new ConcurrencyException();
		}
		catch (CosmosException ex) when(ex.StatusCode == HttpStatusCode.NotFound)
		{
			throw new EntityNotFoundException(id);
		}
	}

	public async Task Remove(Guid id, CancellationToken cancellationToken = default)
	{
		var idText = id.ToString("D");

		try
		{
			_ = await container.DeleteItemAsync<TDbEntity>(idText, new PartitionKey(idText), cancellationToken: cancellationToken);
		}
		catch (CosmosException ex) when(ex.StatusCode == HttpStatusCode.NotFound)
		{
			throw new EntityNotFoundException(id);
		}
	}

	public async Task RemoveIfMatch(Guid id, string token, CancellationToken cancellationToken = default)
	{
		var idText = id.ToString("D");

		var requestOptions = new ItemRequestOptions { IfMatchEtag = token };
		try
		{
			_ = await container.DeleteItemAsync<TDbEntity>(idText, new PartitionKey(idText), requestOptions: requestOptions, cancellationToken: cancellationToken);
		}
		catch (CosmosException ex) when (ex.StatusCode == HttpStatusCode.PreconditionFailed)
		{
			throw new ConcurrencyException();
		}
		catch (CosmosException ex) when(ex.StatusCode == HttpStatusCode.NotFound)
		{
			throw new EntityNotFoundException(id);
		}
	}
}
```

As a reminder, a "concurrency token" is synonymous with an "etag" in the context of the repository.

The persistence needs of an application are independent of a domain entity, so the domain entity is isolated from web/database identifiers, concurrency tokens, HTTP, etags, etc. So, the repository needs to translate from a domain object to the serialization object, which is performed mostly by an `ITranslator<TDomain, TData>` implementation but also with the assignment of the identifier to the serialization object. To keep the non-domain details isolated from the domain object, I've used the `ConditionalWeakTable<TKey, TValue>` type to associate database persistence details (ID and etag/concurrency token, as abstracted by `EntityContext`) to the object without too much management logic.

> `ConditionalWeakTable` is like a dictionary that associates a value with another object. It differs from a traditional dictionary in that when the key is no longer referenced, the associated value is freed/destroyed. This allows us to get associated data with minimal memory impact easily.

An implementation of the repository now just requires the type to use for the database serialization class, the domain entity type, and how to assign an identifier to the Azure Cosmos `id` property:

```csharp
public sealed class CosmosAppointmentRequestRepository : CosmosOptimisticallyConcurrentRepository<AppointmentRequest, AppointmentRequestEntity>
{
    public CosmosAppointmentRequestRepository(Container container, ITranslator<AppointmentRequest, AppointmentRequestEntity> appointmentRequestEntityTranslator)
        : base(container, appointmentRequestEntityTranslator, (entity, guid) => entity.Id = guid)
    {
    }
}
```

The only remaining part is the implementation of the application/database collaboration, the _application service_:

```csharp
public class AppointmentRequestService
{
	private readonly AppointmentRequestDtoTranslator appointmentRequestDtoTranslator;
	private readonly IOptimisticallyConcurrentRepository<AppointmentRequest> repository;

	public AppointmentRequestService(AppointmentRequestDtoTranslator appointmentRequestDtoTranslator, IOptimisticallyConcurrentRepository<AppointmentRequest> repository)
	{
		this.appointmentRequestDtoTranslator = appointmentRequestDtoTranslator;
		this.repository = repository;
	}

	public async Task<(Guid, string)> CreateRequest(AppointmentRequestDto appointmentRequest, CancellationToken cancellationToken = default)
	{
		var entity = appointmentRequestDtoTranslator.AppointmentRequestDtoToAppointmentRequest(appointmentRequest);
		var guid = await repository.Add(entity, cancellationToken);

		return (guid, repository.GetConcurrencyToken(entity));
	}

	public async Task<(AppointmentRequestDto, string)> GetRequest(Guid id, CancellationToken cancellationToken = default)
	{
		var appointmentRequest = await repository.Get(id, cancellationToken);
		return (appointmentRequestDtoTranslator.AppointmentRequestToAppointmentRequestDto(appointmentRequest), repository.GetConcurrencyToken(appointmentRequest));
	}

	public Task<(AppointmentRequestDto, string)> GetRequest(Guid id, string etag, CancellationToken _ = default)
	{
		if(repository.TryGetIfModified(id, etag, out var appointmentRequest))
		{ 
			return Task.FromResult((appointmentRequestDtoTranslator.AppointmentRequestToAppointmentRequestDto(appointmentRequest!), repository.GetConcurrencyToken(appointmentRequest!)));
		}

		throw new ConcurrencyException();
	}

	public async IAsyncEnumerable<(AppointmentRequestDto, Guid, string)> GetRequests([EnumeratorCancellation] CancellationToken cancellationToken = default)
	{
		var result = repository.Get(cancellationToken);
		await foreach (var item in result.WithCancellation(cancellationToken))
		{
			yield return (appointmentRequestDtoTranslator.AppointmentRequestToAppointmentRequestDto(item), repository.GetId(item),
				repository.GetConcurrencyToken(item));
		}
	}

	public async Task RemoveRequest(Guid id, CancellationToken cancellationToken = default)
	{
		await repository.Remove(id, cancellationToken);
	}

	public async Task RemoveRequest(Guid id, string etag, CancellationToken cancellationToken = default)
	{
		await repository.RemoveIfMatch(id, etag, cancellationToken);
	}

	internal async Task<string> ReplaceRequest(Guid id, AppointmentRequestDto appointmentRequest,
		CancellationToken cancellationToken = default)
	{
		var entity = appointmentRequestDtoTranslator.AppointmentRequestDtoToAppointmentRequest(appointmentRequest);
		await repository.Replace(id, entity, cancellationToken);

		return repository.GetConcurrencyToken(entity);
	}

	internal async Task<string> ReplaceRequest(Guid id, AppointmentRequestDto appointmentRequest, string etag,
		CancellationToken cancellationToken = default)
	{
		var entity = appointmentRequestDtoTranslator.AppointmentRequestDtoToAppointmentRequest(appointmentRequest);
		await repository.ReplaceIfMatch(id, entity, etag, cancellationToken);

		return repository.GetConcurrencyToken(entity);
	}

	public async Task<(AppointmentRequestDto, string)> UpdateRequest(Guid id, JsonPatchDocument<AppointmentRequestDto> patchDocument,
		CancellationToken cancellationToken = default)
	{
		var current = await repository.Get(id, cancellationToken);
		var currentDto = appointmentRequestDtoTranslator.AppointmentRequestToAppointmentRequestDto(current);
		patchDocument.ApplyTo(currentDto);
		await repository.Replace(id, appointmentRequestDtoTranslator.AppointmentRequestDtoToAppointmentRequest(currentDto), cancellationToken);
		return (currentDto, repository.GetConcurrencyToken(current));
	}

	public async Task<(AppointmentRequestDto, string)> UpdateRequest(Guid id, JsonPatchDocument<AppointmentRequestDto> patchDocument,
		string etag, CancellationToken cancellationToken = default)
	{
		var current = await repository.Get(id, cancellationToken);
		var currentDto = appointmentRequestDtoTranslator.AppointmentRequestToAppointmentRequestDto(current);
		patchDocument.ApplyTo(currentDto);
		await repository.ReplaceIfMatch(id, appointmentRequestDtoTranslator.AppointmentRequestDtoToAppointmentRequest(currentDto), etag, cancellationToken);
		return (currentDto, repository.GetConcurrencyToken(current));
	}
}
```

`AppointmentRequestService` contains the interaction logic specific to the application and the repository. Since there 

Dealing with translation to and from DTO, domain, and serialization classes is made less of a chore with tools like [Mapperly]. [Mapperly] will generate translation code based on property names. To create a translator to/from two types is easy as creating a partial class with a `MapperAttribute` attribute with partial methods that take one type as parameter and the other as a return:

```csharp
[Mapper]
public partial class AppointmentRequestDtoTranslator
{
	public partial AppointmentRequest AppointmentRequestDtoToAppointmentRequest(AppointmentRequestDto dto);
	public partial AppointmentRequestDto AppointmentRequestToAppointmentRequestDto(AppointmentRequest entity);
}
```

`AppointmentRequestDtoTranslator` translates `AppointmentRequestDto` instances to/from `AppointmentRequest` domain entity instances. And to translate to/from `AppointmentRequestEntity`:

```csharp
[Mapper]
public partial class AppointmentRequestEntityTranslator : ITranslator<AppointmentRequest, AppointmentRequestEntity>
{
	[MapperIgnoreSource(nameof(AppointmentRequestEntity.Id))]
	[MapperIgnoreSource(nameof(AppointmentRequestEntity.ResourceId))]
	[MapperIgnoreSource(nameof(AppointmentRequestEntity.ETag))]
	[MapperIgnoreSource(nameof(AppointmentRequestEntity.SelfUri))]
	[MapperIgnoreSource(nameof(AppointmentRequestEntity.TimestampText))]
	public partial AppointmentRequest ToDomain(AppointmentRequestEntity data);

	[MapperIgnoreTarget(nameof(AppointmentRequestEntity.Id))]
	[MapperIgnoreTarget(nameof(AppointmentRequestEntity.ResourceId))]
	[MapperIgnoreTarget(nameof(AppointmentRequestEntity.ETag))]
	[MapperIgnoreTarget(nameof(AppointmentRequestEntity.SelfUri))]
	[MapperIgnoreTarget(nameof(AppointmentRequestEntity.TimestampText))]
	public partial AppointmentRequestEntity ToData(AppointmentRequest domain);
}
```

Since `AppointmentRequestEntity` has some Azure Cosmos implementation details, we use Mapprerly's `MapperIgnoreTargetAttribute` and `MapperIgnoreSourceAttribute` to tell [Mapperly] that not all properties need translation.

Dealing with concurrency issues and implementing concurrency control can be intimidating. In this post, I make it less intimidating by clarifying some specifics by showing an example implementation with ASP.NET Core and Azure Cosmos DB. Additionally, the Domain-Driven Design patterns Repository and Application Service are used to isolate etag implementation details from the Web API to delegate that to Azure Cosmos.

> There are multiple ways of implementing optimistic concurrency; HTTP ETags are but one way. If you can't abide by the expectations set out by the HTTP standards, don't use Etags. There's nothing that forces you to use HTTP precondition header fields. But, remember, the means exist in HTTP, and embracing it will promote interoperability and reliability (to implement something different than something introduced at least 26 years ago fails to recognize the huge amount of validation and verification that's gone into making it correct.)

In a future post, I will show an example of a repository implementation that uses Entity Framework and its expectations for concurrency tokens.

[rfc9110#etag]: https://www.rfc-editor.org/rfc/rfc9110#field.etag
[jsonpatch]: https://jsonpatch.com/
[Mapperly]: https://github.com/riok/mapperly
[Azure Cosmos SDK]: https://www.nuget.org/packages/Microsoft.Azure.Cosmos
[this repo]: https://github.com/peteraritchie/Examples.Etag