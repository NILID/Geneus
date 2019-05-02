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
carmine = Person.create(name: 'Carmine Coppola',      gender: 'male'  , date_of_birth: '1910-11-06', location_of_birth: 'New York City, New York, U.S.', date_of_death: '1991-04-26', location_of_death: 'Northridge, California, U.S.', bio: 'American composer, flautist, editor, musical director, and songwriter.')
# anton   = Person.create(name: 'Anton Coppola',        gender: 'male'  , date_of_birth: '1917', bio: 'American opera conductor and composer')
joy     = Person.create(name: 'Joy Vogelsang',        gender: 'female')
august  = Person.create(name: 'August Floyd Coppola', gender: 'male'  , date_of_birth: '1934-02-16', location_of_birth: 'Hartford, Connecticut, U.S.', date_of_death: '2009-10-27', location_of_death: 'Los Angeles, California, U.S.', bio: 'American academic, author, film executive and advocate for the arts.')
nicolas = Person.create(name: 'Nicolas Kim Coppola',  gender: 'male'  , date_of_birth: '1964-01-07', location_of_birth: 'Long Beach, California, U.S.', bio: 'Known professionally as Nicolas Cage, is an American actor, director and producer.')
alice   = Person.create(name: 'Alice Kim',            gender: 'female')
christy = Person.create(name: 'Christina Fulton',     gender: 'female', date_of_birth: '1962-07-26', location_of_birth: 'Boise, Idaho, U.S.')
kal_el  = Person.create(name: 'Kal-El Coppola Cage',  gender: 'male',   date_of_birth: '2005-10-03')
weston  = Person.create(name: 'Weston Coppola Cage',  gender: 'male',   date_of_birth: '1990-12-26')

# updating parentships
 weston.parentship.update( father: nicolas, mother: christy )
 kal_el.parentship.update( father: nicolas, mother: alice   )
nicolas.parentship.update( father: august,  mother: joy     )
 august.parentship.update( father: carmine, mother: italia  )

# creating partnerships
Partnership.create([
  { person: nicolas, partner: alice   },
  { person: nicolas, partner: christy },
  { person: august,  partner: joy     },
  { person: carmine, partner: italia  }
])

# attach avatars (disable for heroku)
  italia.avatar.attach( io: File.open(Rails.root.join('db/example_images/italia.png')),  filename: 'italia.png'  )
 carmine.avatar.attach( io: File.open(Rails.root.join('db/example_images/carmine.png')), filename: 'carmine.png' )
  august.avatar.attach( io: File.open(Rails.root.join('db/example_images/august.png')),  filename: 'august.png'  )
 nicolas.avatar.attach( io: File.open(Rails.root.join('db/example_images/nicolas.png')), filename: 'nicolas.png' )
   alice.avatar.attach( io: File.open(Rails.root.join('db/example_images/alice.png')),   filename: 'alice.png'   )
 christy.avatar.attach( io: File.open(Rails.root.join('db/example_images/christy.jpg')), filename: 'christy.jpg' )