# Making Utils Utils

This is a sample app which combines a few concepts as pitched by different blog posts and talks, all of which tries to reduce some of the pain points found in the static/global behavior of the iOS apps.

The key to reading the code is opening the `AppDelegate` and the `RootCoordinator`, and looking at how it defines the root of the ownership graph.

The `CallProvider`  and  `MeetingCoordinator` is an example how one could handle an incoming call. Notice how `MeetingCoordinator` is owned by `AuthorizedCoordinator`.

The `OnfidoController` and `OnfidoViewController` is also a no-op example of how a real controller and view controller can be set up to benefit from some simple dependency injection and how they would interact with the coordinator that created it. 

## Goal

### Expand the toolbox beyond MVC and utils
Right now, there are a lot of things in the app that's called `XyzController` and `XyzUtils`, but these suffixes rarely declare any specific contract for the types.

In the app, types called `XyzController` currently behave as all of the following types
* View models in classic MVVM
* Presenters in MVP
* Coordinators (specifically `AppController` is extremely close to the Coordinator pitched further down)
* Other supporting types, such as URL parsers and message broadcasters

And types called `XyzUtils` behave as
* APIs
* Formatters
* Persistence/databases
* UI navigation

I think the codebase could become more flexible and easy to understand if we expand our toolbox with a few new concepts. The goal would be to give a more specific contract to something given a specific name.

### Make utils utils again
Utils and statics (currently) creates really fuzzy behavior with regards to:
* Ownership (who owns what and who is in charge)
 * Some utils speak to other utils, which in turn speak to even more utils   
* Scope (what needs to be visible to whom)
  * All utils are global, which in turns favors them being called from all corners of the app 
* Lifecycle (when is state present and when is it now)
  * Since static state is ever-present, it always has to be optional
  * It's not obvious when state exists and when it seizes to exist. And who is in charge of responding to these changes? 
  * Shared state is quite often an implicite side-effect of some types. There are APIs which implicitly set user and session IDs as static state side effects when performing other calls.

A lot of code tries to show new views on "the current top view controller". Some of these even specifically filter out specific view controllers where their new views shouldn't be displayed. This creates a system without ownership, which in turn makes for a world where it's hard to read the intent and purpose of code.

### Ownership
Personally I think we should aim to create a more explicit ownership graph. It's hard to summarize exactly what steps would be taken, but I think moving more towards "something" (maybe coordinators) owning VCs and dependencies would give a great starting point towards that. 

## Inspiration

### Managing objects using Locks & Keys in Swift
A blog post (and a talk) which pitches a way to control relationships and the lifecycle of types which "exist broadly in the app, but not always". This is a **GREAT** piece of inspiration on how to get rid of global state in the app, and the proposed solution is extremely simple. No libraries or frameworks needed, just a plain old object and design pattern. 

In the example app, I didn't go as far as calling the ownership object "factories". Instead I made them simpler and called them `XyzContext`. Similar to how the dependency injection pattern at the bottom of this page works.

https://www.swiftbysundell.com/posts/managing-objects-using-locks-and-keys-in-swift
https://www.youtube.com/watch?v=a1g3k3NObkE&t=1128s

### Coordinators
A blog post (and a talk) about a way to separate the tyranny of UIKit's presentation tools. One problem with view controllers is that they live in a world where view controllers are both handlers of UI and user input events - but they are also the routers of subsequent view controllers.

What's worse, the whole navigation system is built upon the idea that view controllers always try to dismiss and pop themselves, which doesn't make any sense from a "parent/child" relationship perspective.

If view controller **A** is in charge of dismissing itself, then it also needs to be in charge of the context in which it is shown; Is it presented or pushed? Is it fullscreen or embedded? This produces a very tightly coupled pattern where you usually convert to building a system where all things need to be aware of everything always, because nobody rarely becomes clearly responsible for presentation.

The pattern Apple designed isn't even very consistent: What almost always happens in apps is that if **A** presents **B**, then most often **B** will dismiss itself. Why is one thing in charge of presenting and the other dismissing? That's backwards.

Coordinators try to give a simple and lightweight solution to this problem. View controllers are responsible for themselves, coordinators are responsible for navigation. What's better is the coordinators are _not_ view controllers, so they need not fiddle around with arcane view controller lifecycle bullshit.

They are also prime candidates for controlling dependency injection between view controllers. VCs no longer need to pass around dumb state just because "the next VC needs it". The coordinator is in charge of that too. 

http://khanlou.com/2015/10/coordinators-redux/
https://youtu.be/ujOc3a7Hav0?t=879


### Using protocol compositon for dependency injection
A very simple way of managing dependency injection, without using any crazy 3rd party stuff. It's small, it's ergonomic and really readable - but most of us probably wouldn't havae  

http://merowing.info/2017/04/using-protocol-compositon-for-dependency-injection/
