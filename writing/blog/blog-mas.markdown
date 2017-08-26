## Apps Pulled / do not exist in MAS ##

* Sandbox restrictions

      Accessing multiple files (directories)


[SourceTree](https://blog.sourcetreeapp.com/2012/06/29/mac-app-store-sandboxing-update/)

> "Going forward with future releases, however, the changes that have been made to the sandbox still do not quite address all of the issues we have with it. While we could work around them, it would downgrade the user experience, which has always been a red line for us. We also have to consider the fact that the main alternatives to SourceTree are not distributed on the Mac App Store and are therefore not constrained by these rules."

> "We continue to recommend using the direct version from sourcetreeapp.com which receives updates much faster (review delays on MAS are running at several weeks) and is also able to support some features which MAS does not allow."

> "Pixelmator is also a typical document-based app, which is a lot easier to sandbox. It doesn’t doesn’t share system tool configuration like SSH, nor does it have cases using defaultdestination paths etc – it’s a typical single-file, document-based app where using simple save dialogs all the time makes sense. That’s not the case with SourceTree."

> "One UX thing is that sandboxing forces you to operate in a ‘per-document mode’ where the user must explicitly open a ‘document’ through File > Open and the OS blocks all other kinds of file access. Given that SourceTree doesn’t operate in that mode, and we need to integrate with & configure other non-sandboxed tools, primarily git and hg, in a way which is prevented by sandboxing, there’s just basically lots of little UX breakages that add up to a huge support headache and it’s just not worth it."

> "Supporting sandboxing in ST is like a hundred little cuts – on their own a bit annoying, but together a major inconvenience when you’re used to things just working. I wish Apple had launched MAS with the current rules, because we would probably have never joined it in the first place (adhering to the original rules took some work too), like pretty much all the other Git tools out there, hardly any of which are on MAS so competing with them is harder if we take on extra limitations. Our view is it’s more important to keep focussing our efforts on making the best dev tool we can for the majority of our users who aren’t on MAS."
