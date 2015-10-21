---
layout: post
title: Sprint 2 retrospective
cover: book.jpg
date:   2015-10-21 22:45:00
categories: posts
tags: perl ox pageboy
---

# The plan

Another ~2 week sprint, scheduled to end Sat 24th.  After last sprint, I
thought I'd done 12 points, but couldn't demo one feature, so final velocity
was in fact 10 points.  I persuaded C to be product owner, which was really
useful, and ended up with a change of direction towards author pages instead.
This is what we pulled in.

 - *DONE*  [#2](https://github.com/osfameron/pageboy/issues/19) 2pt Filter events by area (carried from last week)
 - *DONE*  [#8](https://github.com/osfameron/pageboy/issues/8) 2pt HTML form to create new event
 - *DONE* [#19](https://github.com/osfameron/pageboy/issues/19) 3pt Author information page
 -      [#16](https://github.com/osfameron/pageboy/issues/16) 3pt Search for an author

That's 7/10 points completed.

# How it went

Again, I'd pretty much finished any work I was going to on sprint early in week
2 (Tuesday 20th).  Got less done this time due to a) sleeping better, b)
getting distracted by a [refactor of HassleMe](https://github.com/HassleMe/hassleme/pull/1)
(another side project I run with some ex-colleagues from [mySociety](https://www.mysociety.org/)),
c) having understimated how much refactoring I'd need to do on #8 and #19
d) doing various other Important Work that had nothing to do with story points,
like creating a Vagrantfile.

(Obviously being able to create a virtual machine from scratch is of vital importance
for a one-person project.)

## Process

Sticking with the same approach as last sprint.  Tests are still exclusively
high level with Test::BDD::Cucumber, and I'm rather loving this as a way to
write tests.  Especially as it encourages writing idempotent tests (e.g.
where running one test should not and cannot ever affect the outcome of
running a subsequent test... this has been the bane of many test suites I've
worked with in the past and present.)  I added a flag to the test runner to
run just feature tests using the pretty Cucumber harness, and am now doing
this almost exclusively.

## Modules

Still loving [OX](https://metacpan.org/pod/OX).  It is very much a framework
to write frameworks in.  In theory using a complete framework like Catalyst
could be faster, but this way I get to learn _why_ something is implemented
this way _while doing it_, and this is making me happy.  I do worry this sounds
very Roll-Your-Own, but again, this is all built on Moose + Bread::Board +
Plack, so it's a very solid base to be building on, hopefully.

I had some hard-to-debug errors with
[HTML::Zoom](https://metacpan.org/pod/HTML::Zoom) and decided that in any case
it wasn't quite flexible enough for my liking, so I'd replace it with
[Web::Query](https://metacpan.org/pod/Web::Query).  Unfortunately, the latter
had the disadvantage of seemingly not doing anything sensible at all, so I
reluctantly substituted in [Mojo::DOM](https://metacpan.org/pod/Mojo::DOM).
This turns out to work _perfectly_, and be incredibly easy to play with.

Because I finally implemented a simple form, I plugged in
[HTML::FormHandler](https://metacpan.org/pod/HTML::FormHandler).  This is big,
robust, popular module, with lots of mindshare and swathes of documentation...
that I don't really connect with.  I don't love this module so far, and though
it's currently mediating my form post request, I haven't actually got it
validating very much as a result.

## What's next

Sprint average is 8.5, round to 9 points to be planned this weekend.
Comments welcome below, or ping me @osfameron on twitter or irc.

_(tags: perl ox pageboy)_
