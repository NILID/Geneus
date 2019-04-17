# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Coppola family tree
# Get from https://en.wikipedia.org/wiki/Coppola_family_tree

# creating persons
italia  = Person.create(name: 'Italia Pennino',       gender: 'female', date_of_birth: '1912-12-12', date_of_death: '2004-01-21')
carmine = Person.create(name: 'Carmine Coppola',      gender: 'male'  , date_of_birth: '1910-11-06', date_of_death: '1991-04-26', bio: 'American composer, flautist, editor, musical director, and songwriter.')
joy     = Person.create(name: 'Joy Vogelsang',        gender: 'female')
august  = Person.create(name: 'August Floyd Coppola', gender: 'male'  , date_of_birth: '1934-02-16', date_of_death: '2009-10-27', bio: 'American academic, author, film executive and advocate for the arts.')
nicolas = Person.create(name: 'Nicolas Kim Coppola',  gender: 'male'  , date_of_birth: '1964-01-07', bio: 'Known professionally as Nicolas Cage, is an American actor, director and producer.')
alice   = Person.create(name: 'Alice Kim',            gender: 'female')
kal_el  = Person.create(name: 'Kal-El Coppola Cage',  gender: 'male')

# updating parentships
 kal_el.parentship.update( father: nicolas, mother: alice  )
nicolas.parentship.update( father: august,  mother: joy    )
 august.parentship.update( father: carmine, mother: italia )

# creating partnerships
Partnership.create([
  { person: nicolas, partner: alice  },
  { person: august,  partner: joy    },
  { person: carmine, partner: italia }
])