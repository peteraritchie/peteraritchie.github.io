---
layout: post
title: 'Save CBitmap to File'
tags: ['C++', 'MFC', 'Software Development', 'msmvps', 'September 2006']
---
[Source](http://blogs.msmvps.com/peterritchie/2006/09/25/save-cbitmap-to-file/ "Permalink to Save CBitmap to File")

# Save CBitmap to File

It has always astounded me why the CBitmap class never implemented saving to a file. Here's a nice and tidy way:

#include <atlimage.h>

#include <Gdiplusimaging.h>

  //…

  CBitmap bitmap;

  bitmap.CreateBitmap(width, height, 1, 32, rgbData);

  CImage image;

  image.Attach(bitmap);

  image.Save(_T("C: est.bmp"), Gdiplus::ImageFormatBMP);


