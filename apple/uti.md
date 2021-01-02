# Uniform Type Identifier

A UTI is a text string which uniquely identifies a given class or type of item.

One of the primary design goals for UTI was to eliminate the ambiguities inferring a file's content from its MIME type, or filename extension.

UTIs use a reverse-DNS naming structure (`com.apple.TextEdit`).

Macintosh systems hve attached `type codes` and `creator codes` as part of file metadata.

* Creator code: the application that created the file.
* Type code: the type of file.

MIME types were created to identify data transferring over the web.

UTIs are hierarchial. This allows you to search for any kind of image using `public.image`. You could create a UTI like `com.damonallison.com.fancyimage` and specify it inherit from `public.image` to tell the OS it's an image.

* public.image
  * public.png
  * public.jpeg
  * com.damonallison.fancyimage

Apple maintains the `public.*` domain.