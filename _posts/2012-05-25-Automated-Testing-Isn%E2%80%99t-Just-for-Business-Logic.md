---
layout: post
title:  "Automated Testing Isn’t Just for Business Logic"
date:   2012-05-24 12:00:00 -0600
categories: ['.NET Development', 'C#', 'DevCenterPost', 'Software Development', 'Software Development Guidance', 'TDD', 'Unit Testing']
tags:
- msmvps
---
[Source](http://blogs.msmvps.com/peterritchie/2012/05/25/automated-testing-isn-t-just-for-business-logic/ "Permalink to Automated Testing Isn’t Just for Business Logic")

# Automated Testing Isn’t Just for Business Logic

I had a conversation with [Kelly Sommers][1] the other day that was partially a short _support group session_ on the annoying tendencies of development teams to completely lose focus on the architecture and design principles of a system and let the code base devolve into a ball of muddy spaghetti.

One particular area that we discussed, and it's one area I've detailed [elsewhere][2], has to do with layers.  Our gripe was that developers seem to completely ignore layering principles once they start coding and introduce cycles, put things in the wrong layer, etc.  **A brief recap of layering principles**:  Types in one layer can only access types in the adjacent lower layer.  That's it.  Types that access types in a layer above are violating layering (or aren't layer) and types that access types in a layer lower than the adjacent lower level (e.g. two layers down) are violating layering.

I've blogged about Visual Studio and layers (and [validation][3]) before; but not everyone uses the part of Visual Studio or doesn't have that edition of Visual Studio.  I mentioned in our conversation it's fairly easy to write unit tests to make these verifications.  I've written tests like this before, but the assumption was that "layers" were in different assemblies.  The verification for this scenario is quite a bit simpler; so, I thought I'd tackle a test that verifies layering within a single assembly where namespaces are the scope of layers.

My initial code used Enumerable.Any to see if any types from a lower layer not adjacent to the current layer where used in this layer or whether any types from any layers above the current layer where used in this layer.  This did the validation, but basically left the dev with a "test failed and I'm not giving you any details" message because we couldn't tell where the violation was and what violated it—which isn't too friendly.  So, I expanded it out to detail **all **the violations.  I came up with a utility method ValidateLayerRelationships would be used as follows:
    
    
    
    
    
    
    public enum Layer {
        // Order is important!
        Data,
        Domain,
        UI
    }
     
    [TestMethod]
    public void ValidateLayerUsage()
    {
        var relatedNamespaces = new[] { "PRI.Data", "PRI.Domain", "PRI.FrontEnd", "PRI.ViewModels" };
     
        var levelMap = new Dictionary<string, Layer> {
                        {relatedNamespaces[0], Layer.Data},
                        {relatedNamespaces[1], Layer.Domain},
                        {relatedNamespaces[2], Layer.UI},
                        {relatedNamespaces[3], Layer.UI},
                        };
     
        var assemblyFileName = "ClassLibrary.dll";
        ValidateLayerRelationships(levelMap, assemblyFileName);
    }

In this example I have two namespaces in one layer (the UI layer) FrontEnd and ViewModels and two other layers with just one namespace in each (Data with Data and Domain with Domain). mostly to show you can have more than one namespace per layer…   We define a layer map, and the filename of the assembly we want to validate and call ValidateLayerRelationships.  ValidateLayerRelationships is as follows:
    
    
    
    
    
    
    private static void ValidateLayerRelationships(Dictionary<string, Layer> levelMap, string assemblyFileName) {
        // can't use ReflectionOnlyLoadFrom because we want to peek at attributes
        var groups = from t in Assembly.LoadFrom(assemblyFileName).GetTypes()
                        where levelMap.Keys.Contains(t.Namespace)
                        group t by t.Namespace
                        into g
                        orderby levelMap[g.Key]
                        select g;
     
        var levelsWithClasses = groups.Count();
        Assert.IsTrue(levelsWithClasses > 1, "Need more than two layers to validate relationships.");
     
        var errors = new List<string>();
        foreach (var g in groups){
            var layer = levelMap[g.Key];
            // verify this level only accesses things from the adjacent lower layer (or layers)
            var offLimitSubsets = from g1 in groups where !new[] {layer - 1, layer}.Contains(levelMap[g1.Key]) select g1;
            var offLimitTypes = offLimitSubsets.SelectMany(x => x).ToList();
            foreach (Type t in g){
                foreach (MethodInfo m in t.GetAllMethods()){
                    var methodBody = m.GetMethodBody();
                    if (methodBody != null)
                        foreach (LocalVariableInfo v in methodBody
                            .LocalVariables
                            .Where(v => offLimitTypes
                                            .Contains(v.LocalType)))
                        {
                            errors.Add(
                                string.Format(
                                    "Method "{0}" has local variable of type {1} from a layer it shouldn't.",
                                    m.Name,
                                    v.LocalType.FullName));
                        }
                    foreach (ParameterInfo p in m
                        .GetParameters()
                        .Where(p => offLimitTypes
                                        .Contains(p.ParameterType)))
                    {
                        errors.Add(
                            string.Format(
                                "Method "{0}" parameter {2} uses parameter type {1} from a layer it shouldn't.",
                                m.Name,
                                p.ParameterType.FullName,
                                p.Name));
                    }
                    if (offLimitTypes.Contains(m.ReturnType)){
                        errors.Add(
                            string.Format(
                                "Method "{0}" uses return type {1} from a layer it shouldn't.",
                                m.Name,
                                m.ReturnType.FullName));
                    }
                }
                foreach (PropertyInfo p in t
                    .GetAllProperties()
                    .Where(p => offLimitTypes.Contains(p.PropertyType)))
                {
                    errors.Add(
                        string.Format(
                            "Type "{0}" has a property "{1}" of type {2} from a layer it shouldn't.",
                            t.FullName,
                            p.Name,
                            p.PropertyType.FullName));
                }
                foreach(FieldInfo f in t.GetAllFields().Where(f=>offLimitTypes.Contains(f.FieldType)))
                {
                    errors.Add(
                        string.Format(
                            "Type "{0}" has a field "{1}" of type {2} from a layer it shouldn't.",
                            t.FullName,
                            f.Name,
                            f.FieldType.FullName));
                }
            }
        }
        if (errors.Count > 0)
            Assert.Fail(String.Join(Environment.NewLine, new[] {"Layering violation."}.Concat(errors)));
    }

This method groups types within a layer, then goes through any layers that layer shouldn't have access to (i.e. any layer that isn't the lower adjacent layer, or "layer – 1, layer" where we create offLimitSubsets).  For each type we look at return values, parameter values, fields, properties, and methods for any types they use.  If any of those types are one of the off limit types, we add an error to our error collection.  At the end, if there's any errors we assert and format a nice message with all the violations.

This is a helper method that you'd use somewhere (maybe a helper static class, within the existing test class, whatever).

This uses some extension classes to make it a bit more readable, which are here:
    
    
    
    
    
    
    public static class TypeExceptions {
        public static IEnumerable<MethodInfo> GetAllMethods(this Type type) {
            if (type == null) throw new ArgumentNullException("type");
            return
                type.GetMethods(BindingFlags.Instance | BindingFlags.NonPublic | BindingFlags.Static | BindingFlags.Public).Where(
                    m => !m.GetCustomAttributes(true).Any(a => a is CompilerGeneratedAttribute));
        }
        public static IEnumerable<FieldInfo> GetAllFields(this Type type) {
            if (type == null) throw new ArgumentNullException("type");
            return type.GetFields(BindingFlags.Instance | BindingFlags.NonPublic | BindingFlags.Static | BindingFlags.Public)
                .Where(f => !f.GetCustomAttributes(true).Any(a => a is CompilerGeneratedAttribute));
        }
        public static IEnumerable<PropertyInfo> GetAllProperties(this Type type) {
            if (type == null) throw new ArgumentNullException("type");
            return
                type.GetProperties(BindingFlags.Instance | BindingFlags.NonPublic | BindingFlags.Static | BindingFlags.Public).Where
                    (p => !p.GetCustomAttributes(true).Any(a => a is CompilerGeneratedAttribute));
        }
    }
    

Because the compiler generates fields for auto properties and methods for properties, we want to filter out any compiler-generated stuff (what caused the compiler to generate the code will raise a violation) so we don't get any duplicate violations (and violations the user can't do anything about).  (which is what the call to GetCustomAttributes is doing)

I wasn't expecting this to be that long; so, in future blog entries I'll try to detail some other unit tests that validate or verify specific infrastructural details.  If you have any specific details you're interested in, leave a comment.

[1]: http://bit.ly/LAcF5n
[2]: http://bit.ly/c13trs
[3]: http://bit.ly/MAXJUp

