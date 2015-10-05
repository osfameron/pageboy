---
layout: post
title: Sprint 1 retrospective
cover: pageboy_screenshot.png
date:   2015-10-05 19:50:00
categories: posts
tags: perl ox pageboy
---

As I recently got over the exhaustion of new job and flat move, it seemed like
a good idea to resurrect the [Pageboy](https://github.com/osfameron/pageboy)
project (back in April I'd got as far as creating a static HTML index page for,
and then decomposing it into an HTML::Zoom template with some hard-coded sample
data.)

I keep on describing Pageboy as "like Songkick, but for books" which works best
if you know what Songkick is (and books, I guess.)  Essentially, it's a way to
find out about author events near you.

I'm enjoying, and learning a lot about doing Agile properly at work, so as
the only developer on this, I thought I'd try to use the famous "one-man Scrum"
approach (amazingly, there is some prior art on this, mostly under the moniker
[Personal Scrum](http://blog.jgpruitt.com/2011/04/10/personal-scrum/)).

# The plan

 - The 4 ceremonies:
   - Sprint planning: github [milestone](https://github.com/osfameron/pageboy/milestones/Sprint%201) and detailed pointing, splitting tickets into vertical slices as much as possible.  This may in future trigger a blog post as well.
   - Daily scrum: ignoring this for now.
   - Sprint review: blog post focusing on What
   - Sprint retrospective: blog post/section focusing on How.  (So far, this post touches on both, may be useful to distinguish these better)
 - The 3 artefacts:
   - Product Backlog: github issues and backlog in [Huboard](https://huboard.com/osfameron/pageboy/)
   - Sprint Backlog: Ready/Working/Done in [Huboard](https://huboard.com/osfameron/pageboy/)
   - Burndown chart: TBD. I'm unsure of the value of this chart, though
http://www.scrumdesk.com/is-it-your-burn-down-chart/ looks usefulish.

This was roughly a 2 week sprint, scheduled to end Sat 10th, with an
intention to do about 8 hours a week.  This is what I pulled in.

 - DONE  #1 5pt Retrieve list of events from DB
 - DONE #2 2pt Filter events by area (just pass area via query)
 - DONE #3 3pt Choose area from geocoded IP
 - DONE #10 2pt Filter only upcoming events
 - #4 3pt Choose area from HTML geolocation

That's 15 points (I brough in #10 at the last minute). As this was the first
sprint, and I had no basis to choose how many points to work with, I
used the highly scientific "that feels about right" approach.

# How it went

By Sunday 4th, I'd decided the #4 was too big, or rather too untestable,
as it would require Javascript, and so I first need to look at my toolchain
(PhantomJS or similar).  Also, from totting up my very rough diary, it looks
like I've already spent ~16 hours -- I had some evenings/weekends free, and a
few nights of insomnia.  I'd like to avoid burnout, and in any case I won't
have those free times for remainder (and I'm hoping to do without the insomnia
too, thanks very much.)  So I decided to descope it, and spend last few days 
on review and retro instead.

So, that's a velocity of 13 points to help me plan what to bite off for next
sprint.

## What worked well

### Process

At my new job, there's a lot of focus on splitting things into vertical slices.
It's something that I partly understood intellectually, but never fully
internalized.  But with team planning sessions with a manager who's very good
at reminding us about what the minimum feature set is that will make progress
and be deployable, I've been getting real practice at thinking this way, and
it's very interesting.

It ties in with the idea of YAGNI, and I've found the way that affects thinking
to be quite fascinating.  Originally I wanted to model the location of events with
an "Area" like "Manchester" or "North West England", which could be then linked to
an ID, such as [mySociety's MapIt](http://mapit.mysociety.org/area/11807.html).
But for my original static demo, I'd coded it as a string (literally "Manchester"
or "Liverpool").  For every feature I've added, I've held off from making this
data structure more complicated, and for the entirety of this sprint, I've still
not had to model location as anything more than a string!

One lovely part about this is that, though I'm (fairly) sure I will have to
change the model eventually, I've already got some new intuitions about how
I'll do it, which are quite different from my starting assumptions!  It's also
very freeing to not have to worry about "But what about X?" and "Oh no, Y!" as
I've been coding.  It feels very meditative (in the way that during meditation
you gently push away distractions while concentrating on e.g. your breathing.)

I also decided to try to write tests in Cucumber , which I've previously
dismissed as being silly: mostly because trying to parse human language with
regular expressions makes me feel slightly queasy.  I'm very much enjoying that
once I've specified a feature with, e.g.

    Scenario: Liverpool
        Given I am in Liverpool (based on my IP address)
        When I visit the landing page
        Then I should see 3 events

Now, when this test passes, I know that I've finished working.  And because I'm
still doing big refactors about how components fit together (because I'm using
the lovely [OX web framework](https://metacpan.org/pod/OX), which is only really
a few small steps more elaborate than Plack + Moose, so you have a lot of
freedom/rope to structure things how you want, and because of YAGNI, the actual
methods used are changing all the time.  Not focusing on unit-testing the internals
means I'm less worried about constantly rewriting my tests at a micro-level.

(This may be a bad habit to get into - certainly, I suspect I may need to focus
on unit testing more too.)

### Modules

Loving [OX](https://metacpan.org/pod/OX): building up your framework from
scratch is very much in the spirit of YAGNI I think -- *arguably*, using
something like Catalyst in Perl or Django in Python that has a huge ecosystem
with rich libraries, convention, and masses of documentation, means that it's
harder to get going until you've internalised a whole lot of stuff.  Or to put
it another way, you get a whole lot of bundled *I* that you may never *YAGN*.

[GeoIP2](https://metacpan.org/pod/GeoIP2) (as recommended by Trelane, who I
believe works with MaxMind) is powerful and Just Works, really impressed.

Pete's [Test::BDD::Cucumber](https://metacpan.org/pod/Test::BDD::Cucumber)
for the feature tests works great, though the output is a little hard to debug
on failures

## What didn't work well

I never even thought about doing a standup.  Perhaps this is less useful for a 1-man
team.  Otherwise, all has gone pretty well.  Because I pair at work all day, it's quite
nice to not have to for a personal project (but I'm sure I'll regret it in the future
in one of those moments where you need a pair to unblock you.)

In terms of module choices, the only thing I felt I wasted time on was
[DateTime::Moonpig](https://metacpan.org/pod/DateTime::Moonpig).  While I fear and
hate DateTime's mutability, I didn't understand how to get ::Moonpig to nicely
inflate/deflate, and play with e.g. DT's ::Format::Pg, and so on.  In the end it's
so much more convenient to use the DateTime ecosystem for now.  I may come back to
this in a later refactor though.

## What's next

May do further analysis and maybe some playing during week, but I think that's
me done till the weekend, when I'll plan the next sprint!  Comments welcome
below, or ping me @osfameron on twitter or irc.
