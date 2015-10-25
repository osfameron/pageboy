---
layout: post
title: Oops, I wrote a templating system (again)
cover: book.jpg
date:   2015-10-25 18:30:00
categories: posts
tags: perl ox pageboy
---

## Reinventing the wheel

It used to be said that every programmer has written their own templating
language and an ORM.  In fact, the first module I ever wrote, in 1999, was a
terrible template language built using regular expressions.  I was just
learning Perl, and it turns out that reading module documentation is hard for
newbie programmers.  I learnt a lot from that experience however, such as how
to write modules, and also *never* to write a templating language again.

That said, I did end up building an ORM, twice.  First time was some code that
did report generation with lovingly hand-crafted SQL.  To support the dynamic
reporting criteria, this became more and more complicated until even I noticed
that it was basically a (really bad) ORM.

The second time, I was working at DADA.net in Florence, where we weren't
supposed to use code from CPAN: an influx of actual Perl programmers into
the company, including me and larsen did eventually change this ruling,
but not before I'd ended up creating another ORM.  This was perfectly adequate
for simple row-based filtering, and I'm not too ashamed of it (though I'd have
happily replaced with DBIx::Class of course.)

(I also ended up refactoring our accreted CGI conventions into a web-framework
called Cosimo, after the Medici family of Florence.  Apparently after I left,
one of the senior management grumbled about the module being named after a person,
and the tech lead, quick as a flash, invented a plausible acronym for COSIMO.)

So, after all these years, you'd think I'd have learnt my lesson.

## Why people write template languages

Of course, one of the problems with template languages is that *they all suck*.
Some suck more than others of course (I particulary dislike HTML::Template for
its lack of power, HTML::Mason for its lack of sanity, and HAML for being a
wrongheaded abomination.) For several years, I've liked [Template
Toolkit](https://metacpan.org/pod/Template) as it has a reasonable mix of power
and cleanliness.  (These days I'd probably look at [Text::Xslate's TT
compatible syntax](https://metacpan.org/pod/Text::Xslate::Syntax::TTerse)
instead).

But I'd been curious to try mst's [HTML::Zoom](https://metacpan.org/pod/HTML::Zoom)
for a while, and enjoyed it very much in the early phases of writing Pageboy.  The
idea is that instead of writing active templates, you write a piece of basic HTML
and then let your Perl code fill in the details for you.  This
[entertaining blog rant](http://www.workingsoftware.com.au/page/Your_templating_engine_sucks_and_everything_you_have_ever_written_is_spaghetti_code_yes_you)
calls the concept "template animation", which is quite a good way of describing this
concept.

When I decided HTML::Zoom's implementation was too toylike in its current state, I
moved to [Mojo::DOM](https://metacpan.org/pod/Mojo::DOM) as I mentioned in the
previous post.  That's not really a templating system, but rather a DOM manipulation
library, so it meant that each View plugin had to explicitly do things like

    $article->at('time')->attr(datetime => $date->strftime('%F'));

for every template variable.  So I created some methods inspired by HTML::Zoom
and [Template::Semantic](https://metacpan.org/pod/Template::Semantic), namely:

    # Bind a set of CSS selectors to new content
    $view->bind($dom,
        '.some-selector' => $content,
        '.other-selector' => [attr => 'foo', 'bar'],
    );

    # Repeat part of dom
    $view->repeat($dom->at('#some-template', sub {
        my ($node, $data) = @_;
        $view->bind($node, $data);
    });

    # in the template, a pseudo-tag for including other fragments:
    <include template="templates/foo.html" />

So, um, I think I accidentally wrote a template system, again. Sorry about that.
On the other hand, built atop Mojo::DOM, I've only had to add about 30 lines
of code to get binding, repetition, and inclusion.  Everything else is just
Perl code in the View modules.  If you're curious, the repeat and bind methods
are in [Pageboy::View::Base](https://github.com/osfameron/pageboy/blob/master/lib/Pageboy/View/Base.pm)
while inclusion and the management of the view plugins starts in 
[Pageboy::View](https://github.com/osfameron/pageboy/blob/master/lib/Pageboy/View.pm).

_(tags: perl ox pageboy)_
