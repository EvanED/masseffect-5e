---
layout: default
title: Mass Effect 5e
---

<div class="jumbotron jumbotron-fluid">
    <div class="container text-center">
        <img src="{{ site.baseurl }}assets/images/me5e_logo_notm.png" class="img-fluid" alt="mass effect 5e logo">
        <p class="lead mt-3">
            Love Mass Effect? Love the D&D 5th Edition System? Now you can enjoy them both!
        </p>
    </div>
</div>
<div class="container">
    <div class="row">
        <div class="col-12">
            <h2>Using the system</h2>
            <p>Mass Effect 5e takes the Mass Effect universe and maps onto the D&D 5e system. It's entirely experimental
                and a work in progress.</p>
            <p>
                Start by reading the <a href="{{ site.baseurl }}rules">Rules</a>. For the most part, all 5e rules still apply with some
                minor changes and some new rules added.
            </p>
            <p>The other sections of the site provide the necessary details about race, class, spells, and weapons.</p>

            <div class="row mt-5">
                <div class="col-12">
                    <h2>Races</h2>
                </div>
                {% for race in site.data.races %}
                    <div class="col-12 col-sm-4 col-md-3 col-lg-2 mt-1">
                        <a href="{{ site.baseurl }}races/#{{ race.race | slugify }}" class="clip-circle" data-name="{{ race.race }}" aria-label="{{ race.race }}">
                            <img src="{{ race.face }}" alt="{{ race.race }}">
                        </a>
                    </div>
                {% endfor %}
            </div>

            <div class="row mt-5">
                <div class="col-12">
                    <h2>Classes</h2>
                </div>
            </div>
            <div class="d-flex justify-content-around">
                {% for class in site.data.classes %}
                <a href="{{ site.baseurl }}classes/#{{ class.class | slugify }}" class="class-button" data-name={{ class.class }} aria-label="{{ class.class }}">
                    <img class="class-icon class-icon-xl" src="{{ site.baseurl }}assets/images/classes/{{ class.class | slugify }}.svg">
                </a>
                {% endfor %}
            </div>
        </div>
    </div>
</div>