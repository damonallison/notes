# Enngineering Notes

A collection of notes on tech / tools I've gathered over the years.




## Unix 

* What are the standards around local file system packaging and configuration directories?
  * `~/.local`
  * `~/.config`

## .NET 

* Which testing framework should we use? `MSTest`, `xunit`, `NUnit`.

### NuGet 

* `dotnet nuget locals --list all`   // list all local 
* `dotnet nuget locals --clear all`  // clear 


* NuGet on disk storage:
  * "/Users/allidam/.dotnet/store/|arch|/|tfm|"
  * "/Users/allidam/.nuget/packages"
  * "/Users/allidam/.dotnet/NuGetFallbackFolder"
  * "/usr/local/share/dotnet/sdk/NuGetFallbackFolder"

* How to clean the nuget cache, force a clean download when doing restore?
* Publish a NuGet package.


* What are the `csc` command line options?
* What's the relationship between `dotnet build` and `msbuild`?
