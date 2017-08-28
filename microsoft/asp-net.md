# Professional ASP.NET MVC 5 #

## High level thoughts on ASP.NET

* Completely reactionary / clone of RoR. Patterns, principles, community "vibe". They even stole the terminology. "Action", "Routing", etc.

* Like the strongly typed nature of C# over Ruby. Will scale better.

* Visual studio is way too bloated. Tries too hard to make things simple, actually makes things more difficult.
  * Example : so many "templates" for everything - new files, "add view" actions, etc. There is no need to handhold users that much - look @ the trend toward minimal editors.

* "Classic" ASP.NET abused session and form posting in attempt to mimic an event driven model. It failed miserably, it's not the correct model for the request/response, stateless web.

* Moving everything into the package manager allows each package to version independently.
  * You can update a package without having to release a new VS.NET update, for example.
  * It also handles dependency checking and updating.
  * This was a smart move by Microsoft.

* Why do we have special command line tools, like `NuGet`'s `Package Manager Console` which uses powershell. Powershell is yet another proprietary shell (the only proprietary shell?) we don't need.

* There is a **huge** impedance mismatch between strongly typed .NET and weakly typed JS. Hacks exist (unobtrusive JS) which attempt to bridge the gap between the .NET world and the JS world.

* Always use CDNs to host .js - allows browsers to use cached versions, saves on bandwidth.

* ASP.NET MVC and WebAPI are copies of eachother in many places. Combining them into "One ASP.NET" with the newer .NET initiatives will hopefully eliminate this "same but different" problem MS developed.

* The split between Web API and ASP.NET MVC makes it confusing. So much the same, yet completely different libraries.
* They should not try to combine the two projects. Minor differences between the two stacks makes them appear the same, however differences are difficult to track down.

* Lame :

>  To keep Web API from having any hard dependencies on ASP.NET, the team took a copy of the routing code from ASP.NET and ported it to Web API.

* Why not move the routing code into a separate library? They must be sufficiently different to warrant "copying code"

> Model binding in Web API works mostly the same way as MVC (model binders and providers, and value providers and factories), although it’s been re-factored quite a bit, based on the alternate model binding system from MVC Futures.

* How are you supposed to even *try* to understand the differences?

* This is why vNext will combine MVC and WebAPI into a single library.


## Authors / ASP.NET leadership

* Jon Galloway (MSFT)
* Phil Haack (github)
* Brad Wilson (Ode to code)

* Paul Irish (Author of Respond.js) - Developer Advocate @ Google.

## ASP.NET Core (a.k.a., ASP.NET MVC 6.0)

ASP.NET v6 is a rewrite of ASP.NET. This looks to be a container friendly version capable of running in a docker container.

* MVC 6 (vNext) features. Expected release 2016.
  * Unify all ASP.NET frameworks (MVC, Web API, Web Pages).
  * Self contained (no GAC). Probably done for container models.
  * Open source (github).
  * Apps can be self-hosted, in addition to running in IIS.
  * Built on .NET Execution Environment (DNX). Can run on the full .NET Framework or .NET Core.
  * Cross platform (Windows, Mac, Linux).
  * All Nu-Get packaged.
  * ASP.NET MVC 6 : unified web framework for UI and API.
  * Roslyn dynamic compiler. Avoids a project rebuild for each file change. This will speed development.
  * DI built in.

## Generic ASP.NET Notes

* Configuration transforms : allow your configs to vary based on the build configuration.
  * `Web.Release.config`, `Web.Debug.config`, etc.
  * Their implementation is absolute shit - they actually do `XSD` transforms. Lame.
    They should allow sections / values to be overridden from a base config (xcode).

## Chapter 1 : Getting started

* The MVC stack was a direct response to RoR.

* Funny to watch MS completely copy RoR's terminology, concepts, and motivations
  as well (CoC, DRY, pluggability, get out of the way). RoR had way better
  engineering principles than ASP.NET's WebForm "try to replicate desktop
  events" model.

* MVC was developed in an OSS model. Released in 2009.
* MVC 2 was polish. Released in 2010.
* MVC 3 added razor, nuget, json support. Released in 2011.
* MVC 4 added Web API. Easier than WCF.

* Web API includes many MVC features
  * Request routing.
  * Model binding (mapping request values (URI) -> model).
  * Filters. Action attributes (e.g., `[Authorize]`) for adding behaviors to
    actions.
  * Scaffolding.

* Web API added HTTP specific features
  * HTTP programming model. Strongly typed `HTTPRequest` and `HTTPResponse`
    objects.
  * Action dispatching based on HTTP verbs. Do not use - use attributes.
  * Content negotiation : web API will serialize your response object
    appropriately based on negotiated `Content-Type` headers.
  * Web API is configured via code only for simplicty.

* MVC 5 "One ASP.NET" : Mostly a tooling feature - one ASP.NET project type in
  VS.NET, unified code, etc. Released in 2013.

  * "Display Modes" : different views chosen based on the browser agent.
  * Bundling / JS minification : bundles all JS together into a "bundle". So
    jQuery, etc, can be referenced using a bundle reference. If you update
    versions, you don't have to rename the bundle references in code.
    * Bundles reduce HTTP congestion (single URL for entire bundle).
    * Bundles improve performance (entire bundle can be minified, cached).

  * ASP.NET identity : simplifies storing user credentials / information.
    * Look into "claims based" authentication (authorization?).
  * Attribute routing (use this for Web API).
  * Scaffolding (who cares).
  * Filters. Allows you to participate in the HTTP pipeline (logging, auth, etc).

## Chapter 2 : Controllers

* The controller is the first piece of code which handle an incoming request.
* Routing maps a URI to an action.
* `ActionResult` is returned from an action. `ActionResult` handles
  * HTTP Status Code
  * Invoking a template.

## Chapter 3 : Views

* Ultimately, a view engine's purpose is to take an object (a model) and return
  some text (called a view) that is returned back to the caller.

* Razor is ASP.NET's view engine.

* `ViewBag` is used to pass a small amount of state from a controller to a view.
* `ViewBag` is dynamic, so you must cast each property to a strongly typed
  object when used. You also lose intellisense.
* "Strongly typed views" is their term for passing a strongly typed model object
  from the controller -> view.

```
    // Controller
		public ActionResult List() {
			var albums = new List<Album>();
			for (int i = 0; i < 10; i++) {
				albums.add(new Album { Title = "Album " + i});
			}
			return View(albums);
		}

		// View
		@model IEnumerable<Album>
		<ul>
		@foreach (Album a in Model) {
			<li>@a.Title</li>
		}
		</ul>
```

* Razor (introduced in ASP.NET 3) view engine a ligherweight response to ASP.NET's bloated Web Forms view engine.

* Razor is smart enough to parse expressions properly. Razor knows that " at " breaks these two expressions. It's smart about transitioning in / out of markup.

* In cases where razor is not smart enough to understand what a valid identifier is, give it an explicit expression block with (). Here, we don't want razor to attempt to call the "2" method on System.String.

```
<h1>Listing @model.name at @model.time </h1>

@{
    string distance = 26;
 }
 <span>Your marathon is @(marathon).2 miles.</span>


Comment out a block of markup and code with @* and *@;

	@*

	This is commented out - not rendered or evaluated.

	*@
```

## Chapter 4 : Models

* This book used EF as their ORM. All model classes had `virtual` properties
  to allow EF to overwrite and wrap the properties.

* Scaffolding is simply a code generator. It's pointless in a serious
  application.

* EF is MS's ORM. Attributes allow you to map columns -> fields, specify PKs,
  etc. Similar to CoreData in that objects are lazy loaded by default (faults).

* EF has a lot of bullshit. If it doesn't find a DB for you, it creates
  one. That sucks.

* If you use EF, you essentially have to let EF control it or override
  it's defaults.

* Model binding : binds request values to a model.
  * The model binder uses multiple sources of data to find values:
    * Route data.
    * Querystring.
    * Form collection.

* Using the `[Bind]` attribute allows you to bind only specific parameters to prevent an "over-posting" attack.

```
///
/// This example uses a model binder to automatically bind an Album.
/// The "Bind" attribute allows you to specify only specific properties to bind.
///
/// When the binder moves state into a model, a `ModelState` object
/// is used to keep track of changes. Use `IsValid` to determine if
/// the model was bound correctly.
///
[HttpPost]
public ActionResult Edit([Bind(Includes="Id,FirstName,LastName")]Album album) {
  if (ModelState.IsValid) {
    // Save model, etc.
  }
}

///
/// This example uses a model binder to manually bind an Album.
///
[HttpPost]
public ActionResult Edit() {
  var album = new Album();
  try {
    UpdateModel(album);
    // .. Save model, etc...
  }
  catch {
    // Binding failed.
  }
}

```

## Chapter 5 : Forms and HTML Helpers

* The authors made the point multiple times that HTML helpers do not abstract away HTML generation by using "magic" (as ASP.NET did), rather they bring you "closer" to the metal by allowing you to interact with the ASP runtime (model state, error handling, URL generation, etc).

* HTML helpers simplify HTML generation. Helpers understand the context of the application and can output correct values.
  * Link generation (routing aware)
  * Correct field names to match models.
  * Error handling.

* HTML Forms primer.
  * The default form HTTP method is GET - all values put into QS. GET should not modify the state on a server.
  * POST will keep form values in the HTTP body. POST is intended to modify state on a server. Browsers will prompt users to resubmit POSTs.

* Helpers are found in the `Html` property on a view.
  * See `System.Web.Mvc.HtmlHelper<T>`.
  * Most properties implemented as extensions in the `System.Web.Mvc.Html` namespace.
  * You can build custom extension methods.

* Annotations can be applied on models. HTML helpers will use these annotations to control what HTML is ultimately rendered. Validtors will use annotations to determine how to validate.
  * The following renders as "Genre" when using `@Html.Label("GenreId")`

```
[DisplayName("Genre")]
public int GenreId {get; set; }
```

## Chapter 6 : Data Annotations and Validation

* Annotations are used to provide extra metadata to the MVC framework for validation, display.
* `System.ComponentModel.Annotations` contains (most - except for one) all attributes.

* Validation annotations provide rules fields must conform to.
  * Annotation Examples
    * `[Required]` : error if field is null or empty.
    * `[StringLength(160)]` : specifies max string length.

  * Validation runs during model binding or when calling `UpdateModel / TryUpdateModel`.
  * Validation "results" are put into the `ModelState` property.
    * `@Html.ValidationMessageFor(m => m.LastName)`

* Display / Edit annotations control how a model is shown to the user.


## Chapter 7 : Membership, Authorization, and Security

* Don't trust user data.
* Always use HTTPS - for everything.
* Encode (`Html.Encode() Encoder.JavaScriptEncode()`) *all* data being rendered on browser (eliminates injection).
* Secure controllers and actions, don't try to secure URL routes - URLs can change.
  Web Forms tried to secure sites by URL. With MVC, this isn't ideal. Different routes
  map to different URLs. You want to secure the controller and action, the route used
  to get to the controller/action is not relevant.

* Controllers / actions can be role and/or user based. Use roles - not users.
  `[Authorize(Roles="Administrator", Users="Damon,Steve")]`.

* Roles vs. Claims based auth. Roles are boolean - in or out. Claims include
  more information (what your level is, your hire date, etc), you set permissions
  based on individual data points (claims).

* OWIN : "Open Web Interface for .NET" - terrible name. It's essential a rack clone,
  a common middleware spec.
* OAuth : auth is provided by a 3rd party. No need to keep auth credentials local.
* XSS : injecting code into user input fields.
* AntiXSS : Better library than the default MVC library. When you use `Html.Encode()`,
  that library is used instead of the default encoder.

* CSRF : When one site uses the browser privileges (cookies, etc) to execute an
  invalid command on behalf of the user.
  * Attacker enters a bad URL on a website (for a bank), tricks user into clicking it.
  * User clicks it, the browser uses the bank cookies for the user to successfully
    execute the action.

* How to prevent CSRF attacks?
  * Verify tokens!
  * Include an `@Html.AntiForgeryToken()` when submitting a form. The ASP.NET Framework
    will add a hidden input field with the value of a browser cookie. The Framework
    will verify the form field matches the browser cookie.
  * Include `[ValidateAntiforgeryToken]` on your form `POST` action to verify the
    hidden form field.
  * `GET` should not modify state.

* XSS allows the attacker to write any script. The attacker could:
  * `POST` your cookies to their server.
  * Trick you into `POST`ing data to their servers.

* Cookies can be set to `HttpOnly` to prevent access to the cookie from JS. JS doesn't
  typically need access to cookies, so add this to all cookies.
  * `Response.Cookies["MyCookie"].HttpOnly = true;`

* Over-posting attacks occur by hackers sending in extra form fields knowing
  how binding layers (RoR, ASP.NET) work. If they know an object's definition or
  relationships, they can spoof those values.

  * To prevent over-posting, specify only the values you want the model binder to bind.
    * `[Bind(Include="Name,Comment")]`.
  * Another way to prevent over-posting : only expose a "view model" or "service model"
    which has properties that are bindable.

* "Open Redirection" is a hack that takes advantage of having URLs in a URL. For example,
  including a "return to" URL when attempting to login. An attacker could specify a URL
  for a different site, ask you to login again, and steal your credentials.

* Don't leave important information (debug information, stack traces) in your logs.

## Chapter 8 : Ajax

* ASP.NET MVC AJAX is based on jQuery.
* jQuery encapsulates browser differences.
* `jQuery` is aliased to `$`.

```
$(function () {
  // Select all img elements with id of "album-list"
  $("#album-list img").mouseover(function() {
    $(this).animate({ height: '+=25', width: '+=25' })
           .animate({ height: '+=25', width: '+=25' })

    })
}
```

* jQuery selectors : allow you to find elements based on CSS classes, ids,
  positions in the DOM.

* jQuery Events : allow you to attach functions to an event. In the above, the `mouseover`
  event
  * jQuery attemtpts to simplify interacting with JS events. For example, jQuery
    wraps common "on/off" event handlers into `toggle` classes.
* Do *not* put JS code into HTML (manually attaching on onclick handler). Use jQuery.

* ASP.NET MVC includes "unobtrusive ajax" that provides `data-` attributes which assist in the process of making AJAX requests. The "unobtrusive" part is their term used for simplifying the plumbing of making the HTTP request and wiring up JS events and DOM manipulation.

The following is an example of "unobtrusive" Ajax. Notice that the confirmation dialog, the `id` of the DOM element to update, and the desired Http parameters are given as properties on the `ActionLink` generator.

```
  <div id="jokeoftheday">
    @Ajax.ActionLink("Joke of the day!", "JokeOfTheDay", null, new AjaxOptions
    {
        Confirm= "Are you ready for the joke of the day?",
        UpdateTargetId = "jokeoftheday",
        InsertionMode = InsertionMode.Replace,
        HttpMethod = "GET"
    },
    new { @class = "btn btn-primary" })
  </div>
```

* ASP.NET MVC allows you to specify custom client side validation for a model property. For example, you could have custom client validation which validated the property does not exceed a maximum number of words.
  * To perform custom client side validation, you need to:
    * Create a custom attribute which inherits `IClientValidatable`.
    * Override the `GetClientValidationRules` method to return validation information which the client will use to invoke JS during validation.
    * Write JS which performs the desired validation.
    * Add the new validation "adapter" to ASP.NET MVC's unobtrusive JS valiation list:
      `$.valiator.unobtrusive.adapters.addSingleVal("maxwords", "wordcount")`

  * Client side validation feels flaky - you have to attribute the model, write a custom validator, and implement custom JS for the validation. That's a lot of moving parts. It does provide a nice way to write generic valiation logic which is reusable across fields.

* jQuery UI provides autocomplete, custom UI controls (sliders, buttons, etc) along with custom theming (css).

## Chapter 9 : Routing

* Routing maps URIs to method calls (controller actions).
* Helpers exist to generate URLs.

* ASP.NET has both implicit (yuk) and explicit (attribute based routing).
  * Attribute based routing was introduced later, after they realized
    some URI's were hard to describe via their implicit syntax.
  * Always use explicit, attribute based routing.
  * The community agrees that attribute based routing is preferred : easier, keeps routes with controller code.

* Routing was split off from ASP.NET into the .NET Framework. Web API is hostable outside of ASP.NET. It introduces a clone of the Routing code (failure!).

* Attribute based routes were introduced with ASP.NET v5.

* Traditional routing uses name strings. You need to name your methods appropriately to conform to ASP.NET's naming expectations. This is precisely why traditional routing sucks.

* MVC has "areas" : divides models/views/controllers into separate functional sections.
  * Use `[RouteArea("admin", AreaPrefix="manage")]` to require the "manage" prefix for all URLs in an area.

* There is pain when dealing with attribute based routing, traditional routing, and areas in tandem. You want to declare and include the most specific routes (attribute routes) in the routing table first, prior to the more ambiguous "traditional" routes. Or don't use areas and traditional routing at all.

* Use the `RouteDebugger` NuGet package to debug routes. It will add a setting to `appSettings` in `web.config` to turn on / off remote debugging.

* Always use names when generating a route. This will prevent any ambiguity on which route you are asking the router to generate for you.
  * `@Html.ActionLink("Click Here", "NameOfRoute", {""})`

## Chapter 10 : NuGet

* See [NuGet Docs](https://docs.nuget.org)

* NuGet is the package / dependency manager for .NET.
* Discovery, dependency management, and component lifecycle are issues that package managers solve.

* NuGet updates your local environment in the following ways (depending on the requirements of the packages being installed):
  * Creates a `packages.config` file.
  * A `packages` folder is created, all libraries are installed in that folder.
  * Updates `web.config` with settings for the newly installed packages.
  * Potentially copies files into the project's root. Whatever files are located in the package's `content` folder.

* Do **not** commit the packages folder to git. It bloats the repo.

* XML Document Transform (xdt) is used to modify `web.config` and `app.config`
* You can run PowerShell scripts on install / uninstall.
  * `Init.ps1` : run the first time a package is installed to any package in the solution.
  * `Install.ps1` : Runs when a package is installed into a project.
  * `Uninstall.ps1` : Runs when a package is uninstalled from a project.

* Powershell has the concept of "modules", in which you can create new commands. These commands become available in the Package Manager Console.

* Prerelease packages should support the concept of "semabtic versioning"
  * Follow a `major.minor.patch` part structure. i.e., `1.0.0`
  * Prerelease versions attach an arbitrary string to the patch number. i.e., `10.0.0-dra-test2`. The appended string does not matter. If there is a string there, it's a pre-release version.

* From NuGet's perspective, `1.0.0` is considered higher than `1.0.0-test`, which allows you to increment the version number in your prerelease, then release by dropping the prerelease string.

* Prerelease versions are taken in alphabetical order. Consider using a date for your prerelease version string. This allows you to create incrementally higher versions by date. Another approach would be to use a numeric counter somewhere within the string:
  * `1.0.0-20160602-dra1`


* HttpConfiguration contains:
  * Routes, filters, parameter binding rules, formatter configuration, etc.

* WebAPI is a similar, but still different API from MVC. This feels lame. Why did they do this?
* MVC's `Response` objects are not in WebAPI (only data structures are returned).

* Objects that WebAPI return are serialized via content negotiation.
  * TODO : determine how this works. (`Accept` headers?)

* Always attribute your routes. Don't use their magic HTTP-verb-to-method-name bullshit. Error prone magic.

* All Web API controllers are async by design. See `ApiController.ExecuteAsync`.

* Model binding : WebAPI assumes that all non-complex values are retrieved from non-body. Complex types are taken from the HTTP body.

* Incoming / outgoing bodies are handled by `formatters` which are not part of MVC.
* Only a single object can be bound from the HTTP body.

* WebAPI methods typically return either
  * Raw object value.
  * Action result `IHttpActionResult`.

* If you define an action with a strong return value, the return value will be serialized using content negotiation. To return an error, throw an HttpResponseException(). This will allow you to return a HttpResponseMessage and thus a non-200 error code.

public IHttpActionResult Get(int id) {
  try {
      // get person

  } catch (Exception ex) {
      throw new HttpResponseException(); // allows you
  }
}

* `HttpConfiguration` contains configuration (ASP.NET MVC uses global state - Web API uses a dedicated configuration class.
  * You can run multiple Web API servers in the same application (why would you do this?)
  * Easy to mock for test execution.

## Request Filters

* Each HTTP request is handled via a pipeline. Filters can be added at the action and controller level. A filter is a generic piece of code which executes at different stages of the request pipeline. The request pipeline has the following stages:

* IAuthenticationFilter -> IAuthorizationFilter -> Parameter Binding -> IActionFilter -> Action -> IExceptionFilter

## Chapter 13 : Dependency injection
​
* IoC - inversion of control. Moving the creation of dependencies outside the class which requires the dependency. Often used when discussing dependency injection.

* Examples of DI
  * Service locator. A service locator is an object who's purpose is to vend other objects ("services"). The service locator provides an object with its dependencies. The problem with the service locator is it hides what dependencies each class needs. Specifying the dependents on an object's constructor makes its required dependencies explicit.

```
  /// <summary>
  /// ServiceLocator is a singleton object with is used to provide service objects.
  ///
  /// An instance of the ServiceLocator is passed to each class during construction.
  /// Each class creates references to the services it needs.
  /// </summary>
  public class ServiceLocator {
    public INameFactory NameFactory { get; set; }
    public IDbFactory DbFactory { get; set; }
    public IAuthenticationService AuthService { get; set; }
  }

  public class SqlExecutor {
    private IDbFactory dbFactory;

    /// The ServiceLocator is used to retrieve all dependencies.
    public SqlExecutor(ServiceLocator sl) {
      this.dbFactory = sl.DbFactory;
    }
  }

```

* Constructor argument injection is more popular than public property injection.
* Constructor injection requires the dependencies are provided during object creation. The dependencies must always exist.
