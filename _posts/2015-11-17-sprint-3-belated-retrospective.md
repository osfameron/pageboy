---
layout: post
title: Sprint 3 belated retrospective
cover: book.jpg
date: 2015-11-17 20:58
categories: posts
tags: perl ox pageboy
---

# The plan 

So, this was a 2-week sprint, scheduled to finish on the 7th November.
It's now 10 days later, so clearly I got side-tracked...

I've already mentioned how I got carried away with the design work and ended up
creating a [templating system](/pageboy/posts/2015/10/25/accidental-templating-system.html)
and a new [design view](pageboy/posts/2015/10/28/design-view.html) idea.
I ended up pulling the latter into the sprint. 

 - *DONE*  [#29](https://github.com/osfameron/pageboy/issues/29) 5pt Design view 
 -         [#16](https://github.com/osfameron/pageboy/issues/16) 5pt Search for an author 

So 3-week average velocity = (10+7+5)/3 = 7.

# How it went

The design view work was fun and felt productive, it'll be interesting to see
if it turns out as useful as I imagine it might.

Though I didn't complete the author search task, I did a useful research spike on it.
My initial idea was that the feature just meant doing a Full Text Search on author
records in the database.  But where am I going to get the data in the first place?

I ended up looking at various APIs, of which [OpenLibrary](https://openlibrary.org/dev/docs/api/search)
seemed like a promising contender. But the API and the barely documented data-dump seem
slightly hacked together, and I was left hankering after something more standardised.

Suddenly, querying [DBPedia](http://wiki.dbpedia.org/), which turns crowdsourced
knowledge from Wikipedia into structured information you can query with standard 
semantic data tools like RDF and SPARQL began to seem appealing.  Even if
I know next to nothing about the topic, at least it seems *worth learning*.

The modules in the Perl world appear to be based around [RDF::Trine](https://metacpan.org/pod/RDF::Trine).
Nope, I'm none the wiser about why it's called "Trine", the vocabulary seems very odd
in general.  Consider the perldoc for [RDF::Endpoint](https://metacpan.org/pod/RDF::Endpoint).
It took me several reads of this page, and asking in the (very friendly and helpful) `#perlrdf`
channel before I confirmed that this is basically a semantic database server - e.g. comparable
to a SQL server like Postgres or SQLite!

A good starting route seems to be using [RDF::Query::Client](https://metacpan.org/pod/RDF::Query::Client)
to speak to DBPedia, and I was able to get a list of authors using this code:

{% highlight perl linenos %}
my $query = RDF::Query::Client->new(<<SPARQL);
    PREFIX dbpedia-owl: <http://dbpedia.org/ontology/>
    PREFIX dbpprop: <http://dbpedia.org/property/>
    PREFIX dbres: <http://dbpedia.org/resource/>

    SELECT DISTINCT ?author
    WHERE {
        ?book rdf:type dbpedia-owl:Book;
            dbpedia-owl:author ?author.
    }
    LIMIT 100
SPARQL
{% endhighlight %}

This is really useful, but it doesn't return *all* authors, only "notable" ones.  I suspect that
I'm going to end up collating details from multiple services.  In any case, lots more work is
needed, and I'll have to vertically slice this work much more thinly than I mis-planned!

## Distractions

I visited my parents and managed to persuade my dad to publish his novel
Magnetite, serialized, on the internet.  It's a bit of an epic, set over four
centuries, about migrations happening over four continents.  It has recurring
characters, and when I first saw it, I thought it'd be perfect as a hypermedia
narrative, that you could read in various different ways, for example: follow a
given character, or a location on a map, or a timeline etc.

Originally, I wanted to write a custom blog... but as we'd like to start getting
this serialized in early 2016, I needed something ready made.  My first thought
was Wordpress.  My original plan was:

 - The [Aesop Story Engine](http://aesopstoryengine.com/)
 - Using either the [Fable](http://aesopthemes.com/fable) or [Worldview](https://upthemes.com/themes/worldview/) theme
 - Hosted by [Flywheel](https://getflywheel.com/)

But I tried the Aesop "Story Engine" and found it rather weak.  It lets you add
widgets for a given post (like maps, character bios, or timelines), but doesn't
seem to have powerful ways of linking those posts together.  Thankfully
[Zarino](http://zarino.co.uk/) reminded me about Jekyll (which I'm using for 
this blog and others already) and I've been happily using that ever since.
It turns out Jekyll's collections and a few custom plugins do the job very well
(and it's much nicer to write Ruby than PHP as I'd have to with Wordpress).

# What's next...

I will now take an official hiatus to get *Magnetite* kicked off (as I empirically
don't have the mental energy to run both side projects at the same time!)  But that's
a finite project and I should be able to wind down my involvement by Jan (though
it'll be running till at least Autumn, the blog theme/framework should be fairly solid
and it's "just" editorial work after that) so will look to start Sprint 4 in February 2016!

(The book photo is CC licensed [by Ard Hesselink](https://www.flickr.com/photos/docman/5184048/))

_(tags: perl ox pageboy)_
