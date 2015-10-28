---
layout: post
title: Introducing "design view"
cover: pageboy_design_view.png
date:   2015-10-28 19:15
categories: posts
tags: perl ox pageboy design
---

## Introducing pageboy's "Designer view"
    
One of the appealing ideas of the "Template Animation" approach is that
designers can just edit HTML and CSS.  Why is this attractive?

 - designers are expert in editing HTML and CSS.
   - yes, of course, some designers know Template::Toolkit, some know
     mustache, some (dear $deity) know haml.  *All* of them know HTML and
     CSS.
 - designers don't have to install a mass of dependencies just to get
   your code running.
   - let's be honest, installing code isn't fun for anyone, even
     developers.  Here's what a developer said recently when trying to
     install Pageboy:

```
     <@pete> 0/10 would not install again :-P
```

   - designers already have tooling set up, probably on their shiny
     Macbook, and they don't want to install Ubuntu just to be able to
     understand what all your templates do.

That's great, but there are a few problems:

 - you probably still want to refactor your templates into components
   like the container and various "partial" fragments.
   - which means the editor has to manually construct some static
     HTML out of the relevant partials and hack on it.
   - then they have to extract all the data back into the fragments
   - (only kidding.  The developer will end up doing that bit.)
   - (or the designer will end up having to install all of those
     dependencies and you both lose several days of your time
     babysitting the process.)

So... this commit adds a `bin/manage design` command which starts up a
small web-app that simply concatenates all the partials and (optionally)
runs View logic on the result using some fixtures (which the developer
has created).

The Views, and the Management command do require some Perl dependencies,
but they're relatively light-weight:

 - Mojo::DOM (at this point the almost excessive mania in the
   Mojolicious community for keeping their framework lightweight
   really wins: we're basically installing an entire web framework
   just to get a DOM manipulation library, and it takes seconds.)
 - Moo, for the bin/manage command, but also for the View subclasses.
   Usually Pageboy components are Moose (as is the standard way with
   OX, which is already Moose-based) but there is no issue just using
   Moo, which means the developer install can be much faster.)
 - Plack does have a few dependencies, but it's worth it.

Because the Views don't do anything with business objects at all, we
don't have to install anything at all to do with the database etc.

This requires some refactoring of the cpanfile, which is now split into:

 - all modules
 - just design view modules
 - develop phase modules (including test)

Also required some fixes to Vagrantfile, including installing sass with
gem (as ubuntu version doesn't work in --watch mode)

So... I got rather carried away with this because it caught my imagination
(and was fun to implement).  Will it be useful?  I guess it depends on whether
I ever manage to persuade a designer to hack on it.

Do you (as a developer, designer, or other interested party) think that this
kind of feature will help your design work?  Or do you have other suggestions
on how to manage this interaction?  Comments welcome below or via twitter!

_(tags: perl ox pageboy design)_
