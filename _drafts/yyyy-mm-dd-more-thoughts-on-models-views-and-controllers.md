---
layout: post
title: More thoughts on Models, Views, and Controllers
cover: book.jpg
date: {% date %}
categories: posts
tags: perl ox pageboy
---

## More thoughts on Models, Views, and Controllers

I thought the "Design View" implementation discussed in the previous post fell
into place because of some nice properties of the Template Animation, but I've
been thinking a lot about this and am wondering if the enabling thing isn't
actually MVC itself.

The idea of splitting concerns between Model, View, and Controller is popular,
but easy to interpret in various ways.  For example:

 - (me as a novice developer)
   - *Model*: um?
   - *View*: um?
   - *Controller*: everything goes here

 - (me as an intermediate developer)
   - *Model*: some core database routines
   - *View*: the core templates
   - *Controller*: controller logic, but this bit of database stuff is controller
     logic right?  And it was really hard to template that bit in the view, so
     I generated it in code.

 - (me a bit later)
   - *Model*: most database stuff and logic.
   - *View*: templates, including UI logic
   - *Controller*: anything else.

In this latest iteration, I've learnt the lesson that most business logic goes
in the model.  But Controllers still do too much, and the View may even call
Model logic (e.g. in Template::Toolkit, the template variables may be database
objects... this is very powerful, and quite cute if used in moderation.
Personally, I find I tend to overuse it, with sanity harming effect.)

(A useful tip from mst: if you find yourself overdoing this, is to `local
$schema->{storage};` before your resultsets get to the view, which means they
will only have the data already contained in the object, but can't speak to the
database for more.)

### MVC in Pageboy

Through some mixture of experience, intuition, curiosity, and luck, I've settled on
something like the following:

 - (Pageboy)
   - *Model*: high level routines that call functionality in Model/Schema (the
     actual database objects) and return data structures
   - *View*: HTML templates + a view plugin that animates it using the data from
     Controller
   - *Controller*: parse the request, potentially call Model methods, and return
     a data structure to be passed onto the View.

Now, one of the things that rather impressed me when I (rather briefly) did
some Ruby dev was how the tests pushed you to test only the concerns of a given
component - for example the controller tests, though they did indeed go through
the dispatch mechanism would refuse to output any HTML, so that instead of your
tests being written in terms of `$mech->html_like(...)` you have to test the
data.  This was one of the first things I implemented for Pageboy testing, and
I think it influenced the decision to pass data-structures rather than objects
to the View.

So, as I realised, the Design View could be lightweight, because the View
objects never receive database objects, and so there is no risk of them ever
depending on having to connect to a database just to output some HTML.

But that's only part of the story: because the Model doesn't return database
objects, not only the View but also the Controller simply *can not* be tempted
to overstep the bounds of their authority by doing additional database work.
While the original idea of the Model returning structures rather than objects
was that it would be a convention, it's increasingly feeling so important that
I realise I need to make it an invariant.  Obviously, as I'm writing in Perl and
not Haskell, that's hard to enforce at runtime, but I can make sure all my
`t/controller` (and even better, though harder to test exhaustively, `t/model`)
tests limit what they pass onto the other components.

(Now, mst pointed out that this more rigorous scheme is in fact better called
'Model-View-Adaptor': in traditional MVC for GUI applications, the View could
"subscribe" to changes made in the model and update itself as a result.  In
MVA, the Model and View are entirely separate, mediated only by the Adaptor.)

### "Encouraging" separation of concerns

All in all, it feels like I finally *really* understood MVC (or MVA), after
years of mostly understanding it.  After all, it's one thing to know "it's a
best practice to separate concerns like X" and another to realise that this
isn't just an abstract concept, but a set of constraints or assertions that
*enable* powerful constructs.

Does this seem reasonable, or is enforcing the separation of concerns with
test-time invariants a step too far?  *Did* I really understand MVC?  And what
else am I missing?  Comments below or by twitter very welcome!

*(Thanks to mst, pflanze, schmooster, kd on `#london.pm` for comments on a draft of this post.)*


_(tags: perl ox pageboy)_
