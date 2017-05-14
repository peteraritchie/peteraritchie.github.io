---
layout: post
title:  "Visual Studio 2008 Managed Code Analysis"
date:   2007-08-26 12:00:00 -0600
categories: ['Visual Studio 2008']
tags:
- msmvps
---
[Source](http://blogs.msmvps.com/peterritchie/2007/08/27/visual-studio-2008-managed-code-analysis/ "Permalink to Visual Studio 2008 Managed Code Analysis")

# Visual Studio 2008 Managed Code Analysis

I had a quick look at the managed code analysis (FxCop) rules the other day to see what's new and what's been removed.  Unfortunately, one of the analysis engines wasn't able to be "resurrected" in time for the release, so there's a few really useful rules that haven't stayed with Beta 2 the reslease of Visual Studio 2008.  Fortunately, there have been some additions too.  Fortunately, there is not a deficit, we're up by 12 new rules.

Following are the new rules:

  

  

* DoNotRaiseExceptionsInUnexpectedLocations

  

* NormalizeStringsToUppercase

  

* SpecifyMarshalingForPInvokeStringArguments

  

* SpecifyStringComparison

  

* UseOrdinalStringComparison

  

* AvoidUnmaintainableCode

  

* ReviewMisleadingFieldNames

  

* AvoidExcessiveClassCoupling

  

* IdentifiersShouldBeCasedCorrectly

  

* IdentifiersShouldBeSpelledCorrectly

  

* IdentifiersShouldDifferByMoreThanCase

  

* IdentifiersShouldNotContainTypeNames

  

* OnlyFlagsEnumsShouldHavePluralNames

  

* ResourceStringCompoundWordsShouldBeCasedCorrectly

  

* ResourceStringsShouldBeSpelledCorrectly

  

* MarkAssembliesWithNeutralResourcesLanguage

  

* RemoveEmptyFinalizers

  

* CatchNonClsCompliantExceptionsInGeneralHandlers

  

* TestForNaNCorrectly

  

* AttributeStringLiteralsShouldParseCorrectly

  

* SecurityTransparentAssembliesShouldNotContainSecurityCriticalCode

  

* SecurityTransparentCodeShouldNotAssert

  

* SecurityTransparentCodeShouldNotReferenceNonpublicSecurityCriticalCode

  

* CatchNonClsCompliantExceptionsInGeneralHandlers

And following are the rules that were removed:

  

  

* ProvideCorrectArgumentsToFormattingMethods

  

* DisposeMethodsShouldCallBaseClassDispose
  

* DoNotCallPropertiesThatCloneValuesInLoops

  

* DoNotDisposeObjectsMultipleTimes

  

* SpecifyMarshalingForPInvokeStringArguments

  

* DoNotPassLiteralsAsLocalizedParameters

  

* LongAcronymsShouldBePascalCased

  

* ShortAcronymsShouldBeUppercase

  

* AvoidUnnecessaryStringCreation

  

* DoNotConcatenateStringsInsideLoops
  

* SecureGetObjectDataOverrides

  

* AssembliesShouldDeclareMinimumSecurity

