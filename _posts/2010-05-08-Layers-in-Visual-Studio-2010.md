---
layout: post
title:  "Layers in Visual Studio 2010"
date:   2010-05-07 12:00:00 -0600
categories: ['DevCenterPost']
tags:
- msmvps
---
[Source](http://blogs.msmvps.com/peterritchie/2010/05/08/layers-in-visual-studio-2010/ "Permalink to Layers in Visual Studio 2010")

# Layers in Visual Studio 2010

Visual Studio 2010 has a new featured called Layer Diagrams.  In the Ultimate edition you can create layer diagrams that model the logical layers in your software system.

## What is a Layer?

I'm glad you asked what a layer is.  A layer is a logical grouping of types with similar external assembly dependencies.  Dependencies between layers occur only in one direction from a higher-level layer to a lower-level layer.  I.e. a higher-level layer can use types in a lower-level layer, but not vice versa. A canonical example is the Data Access Layer (or DAL).  The DAL contains all the types that directly use types responsible for data-access.

## Using the Layer Diagram

Within the Layer Diagram user interface, it can be unclear what a layer is.  The Layer Diagram is really just a dependency diagram that allows creation of a logical layer that can be linked to physical artefacts.

Creating a layer diagram in Visual Studio Ultimate is easy, select New Diagram from the Architecture menu and the Add New Diagram dialog will be displayed.

![vs-arch-new diagram][1]

In the Add New Diagram dialog, select the Layer Diagram entry and enter the name of the layer diagram file.

![vs-add new diagram][2]

If your solution does not currently contain a Modeling project, one will be created automatically when you press OK as indicated by "Create a new modelling project…" in the **Add to modeling project** combo box.

Once the modeling project is created and the new layer diagram is added to that project, you will be presented with the Layer Diagram design surface.  You have many options to creating a layer in the diagram, you can use entries in the toolbox to create layers, dependencies, and comments:

![layer diagram toolbox][3]

Or, you can drag artefacts from the Solution Explorer or the Architecture Explorer to create layers in various ways.  Normal dragging of a single artefact onto the design service creates a new layer with a one-to-one mapping (a "link" in Layer Diagrams) from layer to artefact.  This is especially useful for projects from the solution explorer.  It's not uncommon for logical layers to be implemented as tiers (or physical assemblies).  Or, you can create a one-to-many mapping from layer to artefacts by normal dragging of artefacts onto the design surface.  This is useful when you're modeling layers but haven't modeled them as tiers and multiple layers exist in a single assembly or project.  Via the Architecture Explorer and the Solution Explorer you can link assemblies (projects), types, namespaces, methods, properties, fields, and files to a layer.

Regardless of how the layer was created on the diagram, you can add links to it by dragging them from the Solution Explorer or Architecture Explorer onto a layer to create a link to it.  Oddly, although you can link to classes and namespaces, you can't drag classes or namespaces from the Class View onto the Layer Diagram design surface.

The following diagram was created by dragging three projects from the Solution Explorer to the design surface and invoking Generate Dependencies on all three of the created layers:

![Layer Diagram][4]

Once a layer model has been defined, you can then ask Visual Studio to validate the solution against that logical architecture. Within the layer diagram you can have a one-to-one mapping of layer to links, or a one-to-many mapping.  i.e. a layer can consist of one or more links (at least in terms of validation—you can have zero links in a layer if you want; but then VS has no information with which to validate anything). If, for whatever reason, the current solution doesn't follow the logical architecture, an error will result.   You can also configure the solution to automatically validate the solution against the layer diagram during a build.  This build-time validate can occur in both the Ultimate and Premiums editions of Visual Studio 2010.

## Why is it really just a Dependency Diagram?

Another really good question!  The Layer Diagram is really just a dependency diagram because there's no inherent recognition for layer levels.  Because there's no way of defining a level, there's no way to group layers within a specific level.  Layer diagrams also allow bi-directional dependencies; a definite no-no with two layers at different levels.  It's also really difficult to really enforce only a particular layer having references to particular external references.  You can declare forbidden namespaces for a particular layer, but it's a cumbersome method of enforcing references to particular components only occur in a certain layer.  For example, if I had a DAL and I wanted to make sure only data-access occurred in that layer, I could add "System.Data" to the Forbidden Namespace Dependencies for all layers expect the DAL and incur an error with Layer Validation should any types from System.Data be used in any of those Layers.  But, things like DataGridView in Windows Forms are used primarily with types in System.Data so it becomes difficult to manage these dependencies.

[1]: http://msmvps.com/cfs-file.ashx/__key/CommunityServer.Blogs.Components.WeblogFiles/peterritchie.metablogapi/8053.vsarchnewdiagram_5F00_thumb_5F00_46279258.png "vs-arch-new diagram"
[2]: http://msmvps.com/cfs-file.ashx/__key/CommunityServer.Blogs.Components.WeblogFiles/peterritchie.metablogapi/1425.vsaddnewdiagram_5F00_thumb_5F00_2DD4783D.png "vs-add new diagram"
[3]: http://msmvps.com/cfs-file.ashx/__key/CommunityServer.Blogs.Components.WeblogFiles/peterritchie.metablogapi/2086.layerdiagramtoolbox_5F00_thumb_5F00_46EFD275.png "layer diagram toolbox"
[4]: http://msmvps.com/cfs-file.ashx/__key/CommunityServer.Blogs.Components.WeblogFiles/peterritchie.metablogapi/2570.LayerDiagram_5F00_thumb_5F00_0575201C.png "Layer Diagram"

