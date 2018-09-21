---
---
# Mocking Frameworks Are For The Hard-to-Mock

I happened upon some code the other day, that looked something like this:

``` csharp
_configurationRoot = new Mock<IConfigurationRoot>();
_configurationRoot.SetupGet(x => x[It.IsAny<string>()]).Returns("the string you want to return");
```
