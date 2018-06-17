# Markdown

* [Markdown Syntax Specification](https://daringfireball.net/projects/markdown/syntax)

The goal of markdown is writing for the web. Where HTML is a *publishing* format, Markdown is a *writing* format.

## Markdown and HTML

Markdown is meant to be translated into HTML. For any HTML markup tag that is *not* covered by Markup, just add HTML to the document. For example, you can add a table to your Markdown document.

<table>
  <tr>
    <th>Header 1</th>
    <th>Header 2</th>
  </tr>
  <tr>
    <td>Col 1</td>
    <td>Col 2</td>
  </tr>
</table>

Markdown will also translate `<` and `&` characters into the HTML entity equivalents (`&lt; and &amp;`).

```html
<!-- 

//
// In code blocks, Markdown will *always* replace `<` and `&` 
// characters with their HTML entity equivalents.
//
// This allows you to embed code within a Markdown document.
//

-->
<html>
    ...
</html>
```

## Block Elements

### Paragraphs

Markdown treats multiple contiguous lines of text without a blank line
to be considered the same paragraph. This allows you to hard wrap lines
and still have them treated as a single paragraph.

### Blockquoting

> Creates a block quote. Block quotes look best if you hard wrap
> lines at a certain

> > Creates a second level block quote.

> > > And a third level.

### Lists

* A bulleted list item.

  Another paragraph associated with this list item. You can have 
  multiple paragraphs associated with each list item.

* Another bulleted list item.

  > You can also attach blockquotes to a list item.

      // Or associate code with a list item.
      // The block just needs to be indented 2 tabs (4 spaces in VS Code)

1. An ordered list item.
1. Another ordered list item.

### Code Blocks

Code blocks are really simple.

    // All you need to do to create a code block is indent the block
    // 4 spaces or 1 tab.

    // All HTML special characters will be escaped in the resulting HTML.
    // This makes it simple to write about code.

### Horizontal Rules

A horizontal rule can be added with `***`.

*** 

### Emphasis

* Use single asterisks for *italics*.
* Use double asterisks for **bold**.

### Inline Code Blocks

* Use backticks `printf()` for inserting an inline code block.
* Escape the backtick if you want to insert a \` in the text with `// code blocks`.

```java
import com.sun.*;

if (x > 10) {
    // something java here.
    System.out.println("Printing a line");
}
```

### Links

Markdown supports two versions of links - *inline* and *reference*:

* Inline links like this - [Google](https://google.com/ "Google Homepage")
* Reference links like this - [Google][GOOG].
* If the text of the link is the same as the reference title, you can omit the reference title. Like [Apple][].

Reference links are cleaner and better looking when interspersed with text.


Note that reference links do not show up in the resulting HTML. You can declare reference links anywhere in the document. 

[GOOG]: http://google.com "Google Homepage"
[Apple]: http://apple.com "Apple Homepage"

### Images

Images are very similar to links - using inline and reference versions. Markdown has no syntax for specifying image dimensions. If you need dimensions, use `<img>` tags.

Inline:

![Apple](images/apple.png "Apple Logo")
![Android](images/android.png "Android Logo")

Reference:

![Apple-Logo][] ![Android-Logo][]

[Apple-Logo]: images/apple.png "Apple Logo"
[Android-Logo]: images/android.png "Android Logo"

