---
layout: post
title: 'Code Analysis: How to Correctly Resolve CA1300 – "Specify MessageBox Options"'
tags: ['C#', 'Code Analysis/FxCop Warning Resolutions', 'Visual Studio 2005', 'msmvps', 'October 2006']
---
[Source](http://blogs.msmvps.com/peterritchie/2006/10/15/code-analysis-how-to-correctly-resolve-ca1300-specify-messagebox-options/ "Permalink to Code Analysis: How to Correctly Resolve CA1300 – "Specify MessageBox Options"")

# Code Analysis: How to Correctly Resolve CA1300 – "Specify MessageBox Options"

This is the first installment of what I hope to be many short bits of guidance about correctly resolving some of the more complex warnings coming out of FxCop and Code Analysis.

The CA1300 warning is specifically about the right-to-leftor left-to-right reading order of a message box. The documentation for the warning alludes that a message box doesn't automatically inherit the containing form's reading order or the reading order from the user's current culture. Although, I can't find any documentation that confirms either.

In any case, this is a rather complex warning to resolve, youpossibly have to traverse the form's lineage (when reading order is inherited) to find the reading order setting. The example fix in the documentation basically puts this logic in the code that calls MessageBox.Show. This is very un-resuable and couples the logic not only to the containing class but to the method it's contained within. My solution attempts to allow resolution of CA1300 with as little coupling as possible and little or no changes to existing code.

My solution is obviously going to implement the extra logic in a new class; but I'll be implementing in a way where you don't have to change your existing calls to MessageBox.Show. My resolution extends the Form class and provides a MessageBox property that is implemented with a protected nested class that provides Show methods with all the same signatures as System.Windows.Forms.MessageBox.Show. The only requirement to using this class is that you haven't explicitly used the full namespace when calling MessageBox.Show, like 'System.Windows.Forms.MessageBox.Show("text", "caption")'.

The following is the class that extends Form using a protected class to implement a MessageBox property to redirect calls to MessageBox.Show–which eventually creates the appopriate MessageBoxOptions value and delegates to System.Windows.Forms.MessageBox.Show.

namespace PRI.Windows.Forms

{

 public class RtlAwareForm : Form

 {

  private MessageBoxProxy messageBoxProxy;



  protected MessageBoxProxy MessageBox

  {

   get

   {

    return messageBoxProxy;

   }

  }



  public RtlAwareForm ( )

  {

   messageBoxProxy = new MessageBoxProxy(this);

  }



  [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design",

   "CA1034:NestedTypesShouldNotBeVisible")]

  protected class MessageBoxProxy

  {

   private Control parent;

   public MessageBoxProxy (Control parent)

   {

    this.parent = parent;

   }



   private static Boolean IsRightToLeft ( Control control )

   {

    if (control.RightToLeft == RightToLeft.Inherit)

    {

     Control parent = control.Parent;

     while (parent != null)

     {

      if (parent.RightToLeft != RightToLeft.Inherit)

      {

       return parent.RightToLeft == RightToLeft.Yes;

      }

     }

     return CultureInfo.CurrentUICulture.TextInfo.IsRightToLeft;

    }

    else

    {

     return control.RightToLeft == RightToLeft.Yes;

    }

   }



   public DialogResult Show ( string text )

   {

    return Show(text,

     string.Empty,

     MessageBoxButtons.OK,

     MessageBoxIcon.None,

     MessageBoxDefaultButton.Button1);

   }



   public DialogResult Show ( string text, string caption )

   {

    return Show(text,

     caption,

     MessageBoxButtons.OK,

     MessageBoxIcon.None,

     MessageBoxDefaultButton.Button1);

   }



   public DialogResult Show ( string text,

    string caption,

    MessageBoxButtons buttons )

   {

    return Show(text,

     caption,

     buttons,

     MessageBoxIcon.None,

     MessageBoxDefaultButton.Button1);

   }



   public DialogResult Show ( string text,

    string caption,

    MessageBoxButtons buttons,

    MessageBoxIcon icon )

   {

    return Show(text,

     caption,

     buttons,

     icon,

     MessageBoxDefaultButton.Button1);

   }



   public DialogResult Show ( String text,

    String caption,

    MessageBoxButtons messageBoxButtons,

    MessageBoxIcon icon,

    MessageBoxDefaultButton defaultButton )

   {

    MessageBoxOptions options =

     IsRightToLeft(parent) ?

      MessageBoxOptions.RightAlign | MessageBoxOptions.RtlReading : 0;



    return System.Windows.Forms.MessageBox.Show(parent,

     text,

     caption,

     messageBoxButtons,

     icon,

     defaultButton,

     options);

   }



   public DialogResult Show ( IWin32Window owner, string text )

   {

    return Show(owner,

     text,

     string.Empty,

     MessageBoxButtons.OK,

     MessageBoxIcon.None,

     MessageBoxDefaultButton.Button1);

   }



   public DialogResult Show ( IWin32Window owner, string text, string caption )

   {

    return Show(owner,

     text,

     caption,

     MessageBoxButtons.OK,

     MessageBoxIcon.None,

     MessageBoxDefaultButton.Button1);

   }



   public DialogResult Show ( IWin32Window owner,

    string text,

    string caption,

    MessageBoxButtons buttons )

   {

    return Show(owner,

     text,

     caption,

     buttons,

     MessageBoxIcon.None,

     MessageBoxDefaultButton.Button1);

   }



   public DialogResult Show ( IWin32Window owner,

    string text,

    string caption,

    MessageBoxButtons buttons,

    MessageBoxIcon icon )

   {

    return Show(owner,

     text,

     caption,

     buttons,

     icon,

     MessageBoxDefaultButton.Button1);

   }



   public DialogResult Show ( IWin32Window owner,

    string text,

    string caption,

    MessageBoxButtons buttons,

    MessageBoxIcon icon,

    MessageBoxDefaultButton defaultButton )

   {

    MessageBoxOptions options = parent != owner ?

     0 : (IsRightToLeft(parent) ?

      MessageBoxOptions.RightAlign | MessageBoxOptions.RtlReading : 0);



    return System.Windows.Forms.MessageBox.Show(owner,

     text,

     caption,

     buttons,

     icon,

     defaultButton,

     options);

   }



   public DialogResult Show ( string text,

    string caption, MessageBoxButtons buttons,

    MessageBoxIcon icon,

    MessageBoxDefaultButton defaultButton,

    MessageBoxOptions options )

   {

    return System.Windows.Forms.MessageBox.Show(parent,

     text,

     caption,

     buttons,

     icon,

     defaultButton,

     options);

   }



   [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance",

    "CA1822:MarkMembersAsStatic")]

   public DialogResult Show ( string text,

    string caption,

    MessageBoxButtons buttons,

    MessageBoxIcon icon,

    MessageBoxDefaultButton defaultButton,

    MessageBoxOptions options,

    bool displayHelpButton )

   {

    return System.Windows.Forms.MessageBox.Show(text,

     caption,

     buttons,

     icon,

     defaultButton,

     options,

     displayHelpButton);

   }



   public DialogResult Show ( string text,

    string caption,

    MessageBoxButtons buttons,

    MessageBoxIcon icon,

    MessageBoxDefaultButton defaultButton,

    MessageBoxOptions options,

    string helpFilePath )

   {

    return System.Windows.Forms.MessageBox.Show(parent,

     text,

     caption,

     buttons,

     icon,

     defaultButton,

     options,

     helpFilePath);

   }



   [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance",

    "CA1822:MarkMembersAsStatic")]

   public DialogResult Show ( IWin32Window owner,

    string text,

    string caption,

    MessageBoxButtons buttons,

    MessageBoxIcon icon,

    MessageBoxDefaultButton defaultButton,

    MessageBoxOptions options )

   {

    return System.Windows.Forms.MessageBox.Show(owner,

     text,

     caption,

     buttons,

     icon,

     defaultButton,

     options);

   }



   public DialogResult Show ( string text,

    string caption,

    MessageBoxButtons buttons,

    MessageBoxIcon icon,

    MessageBoxDefaultButton defaultButton,

    MessageBoxOptions options,

    string helpFilePath,

    string keyword )

   {

    return System.Windows.Forms.MessageBox.Show(parent,

     text,

     caption,

     buttons,

     icon,

     defaultButton,

     options,

     helpFilePath,

     keyword);

   }



   public DialogResult Show ( string text,

    string caption,

    MessageBoxButtons buttons,

    MessageBoxIcon icon,

    MessageBoxDefaultButton defaultButton,

    MessageBoxOptions options,

    string helpFilePath,

    HelpNavigator navigator )

   {

    return System.Windows.Forms.MessageBox.Show(parent,

     text,

     caption,

     buttons,

     icon,

     defaultButton,

     options,

     helpFilePath,

     navigator);

   }



   [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance",

    "CA1822:MarkMembersAsStatic")]

   public DialogResult Show ( IWin32Window owner,

    string text,

    string caption,

    MessageBoxButtons buttons,

    MessageBoxIcon icon,

    MessageBoxDefaultButton defaultButton,

    MessageBoxOptions options,

    string helpFilePath )

   {

    return Show(owner,

     text,

     caption,

     buttons,

     icon,

     defaultButton,

     options,

     helpFilePath);

   }



   public DialogResult Show ( string text,

    string caption,

    MessageBoxButtons buttons,

    MessageBoxIcon icon,

    MessageBoxDefaultButton defaultButton,

    MessageBoxOptions options,

    string helpFilePath,

    HelpNavigator navigator,

    object param )

   {

    return System.Windows.Forms.MessageBox.Show(parent,

     text,

     caption,

     buttons,

     icon,

     defaultButton,

     options,

     helpFilePath,

     navigator,

     param);

   }



   [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance",

    "CA1822:MarkMembersAsStatic")]

   public DialogResult Show ( IWin32Window owner,

    string text,

    string caption,

    MessageBoxButtons buttons,

    MessageBoxIcon icon,

    MessageBoxDefaultButton defaultButton,

    MessageBoxOptions options,

    string helpFilePath,

    string keyword )

   {

    return System.Windows.Forms.MessageBox.Show(owner,

     text,

     caption,

     buttons,

     icon,

     defaultButton,

     options,

     helpFilePath,

     keyword);

   }



   [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance",

    "CA1822:MarkMembersAsStatic")]

   public DialogResult Show ( IWin32Window owner,

    string text,

    string caption,

    MessageBoxButtons buttons,

    MessageBoxIcon icon,

    MessageBoxDefaultButton defaultButton,

    MessageBoxOptions options,

    string helpFilePath,

    HelpNavigator navigator )

   {

    return System.Windows.Forms.MessageBox.Show(owner,

     text,

     caption,

     buttons,

     icon,

     defaultButton,

     options,

     helpFilePath,

     navigator);

   }



   [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance",

    "CA1822:MarkMembersAsStatic")]

   public DialogResult Show ( IWin32Window owner,

    string text,

    string caption,

    MessageBoxButtons buttons,

    MessageBoxIcon icon,

    MessageBoxDefaultButton defaultButton,

    MessageBoxOptions options,

    string helpFilePath,

    HelpNavigator navigator,

    object param )

   {

    return System.Windows.Forms.MessageBox.Show(owner,

     text,

     caption,

     buttons,

     icon,

     defaultButton,

     options,

     helpFilePath,

     navigator,

     param);

   }

  }

 }

}

I've attached a non-web-sitefriendly version of the class in the attachements, that includes more comments andless line breaks.

Now, the only change to the original code to resolve the warnings is the addition of a using namespace directive and a change to the form's base class (and in this example, a change to the CodeAnalysis suppression):


