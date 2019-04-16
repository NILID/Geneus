![Geneus logo](https://raw.githubusercontent.com/NILID/Geneus/master/geneus-github.png)

# Geneus

Geneus is a Ruby on Rails based genealogy application that operates on the wiki principle: all users edit the same record for an individual.

## Status

This project is in pre-alpha state, meaning you won't find a full set of features to work with. At this point you can:

* Create, edit and delete people
* Add basic genealogical relationships
* Add basic personal information
* Navigate the family tree
* View change history

It is conspicuously missing:

* User accounts of any kind
* Editing permissions (open to the world)
* Relationship validations

## Setup

    bundle install
    rake db:migrate
    rails server

## Bugs?

If you find a bug please add an [issue on GitHub](https://github.com/NILID/Geneus/issues) or fork the project and send a pull request.