---
---
# Static to Wrapper/Interface Refactoring
## Why
mockability

## How
### Refactor to Instance (temporarily)
1. **Select the entire static class you want to wrap**  
	Hint:
	1. Click the squared minus (&boxminus;) in the left margin at the line the class starts on.  This collapses the class and changes to a squared plus.
	2. Click to the left of the squared plus (&boxplus;) to select the entire class
	3. Optionally, press &boxplus; to re-expand the class
1. **Find/Replace "`static `" in the selection and replace with *nothing***  
	Hint:
	1. <kbd>Ctrl</kbd>+<kbd>h</kbd>
    2. Ensure *Selection* scope
    3. Enter `static ` in *Search term* box
    4. Ensure *Replacement term* is empty
    5. Replace all: <kbd>Alt</kbd>+<kbd>a</kbd>
### Extract Interface
1. Click on the name of the class (e.g. `StaticClassName`)
1. Extract interface refactoring: <kbd>Shift</kbd>+<kbd>Ctrl</kbd>+<kbd>r</kbd>, *Extract interface*
1. *Select Public*
1. *Next >*
1. Type name of new interface, e.g. `IInterface`
### Remove "` : IInterface`"
Remove `IInterface` from interface list of original class.
### Un-refactor
Restore the `static`s to the original class.
### Create new *`IInterface`* Implementation
1. Click on the name of the interface (e.g. `IInterface`)
1. Create derived type: <kbd>Shift</kbd>+<kbd>Ctrl</kbd>+<kbd>r</kbd>, *Create derived type*
### Add *`IInterface`* Field to New Implementation
Add a field to the newly created implementation that is the type of the interface  
E.g.:
```csharp
private IInterface StaticClassName;
```
Ignore any warnings about naming, you'll understand shortly.
### Generate Delegating Members
1. Click new field name (e.g. `StaticClassName`) in editor
1. <kbd>Alt</kbd>+<kbd>Ins</kbd>, *Delegating members*
1. *Select all* members for the interface
1. Finish.

All the members will now be delegated to your member variable, but it is this class that must implement *`IInterface`**.  So, remove the member variable.  Since the name of the field was the same as the static class, your new methods are now delegating to the static class.

Now you have functionality to mock.  Replace all the uses of the static class with instance calls to a private field.  Inject an implementation where needed, with your favorite means, and mock away!

