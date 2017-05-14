---
layout: post
title: Save CBitmap to File
categories: ['C++', 'MFC', 'Software Development']
tags:
- msmvps
---
[Source](http://blogs.msmvps.com/peterritchie/2006/09/25/save-cbitmap-to-file/ "Permalink to Save CBitmap to File")

# Save CBitmap to File

It has always astounded me why the CBitmap class never implemented saving to a file.  Here's a nice and tidy way:

#include <atlimage.h>

#include <Gdiplusimaging.h>

        //…

        CBitmap bitmap;

        bitmap.CreateBitmap(width, height, 1, 32, rgbData);

        CImage image;

        image.Attach(bitmap);

        image.Save(_T("C: est.bmp"), Gdiplus::ImageFormatBMP);

