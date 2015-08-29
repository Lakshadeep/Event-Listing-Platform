# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:


tags = Tag.create([{tag: "Music"},{tag: "Sports"},{tag: "Dance"},{tag: "Party"},{tag: "Public"},{tag: "Travel"},{tag: "Health"},{tag: "Technology"}])

# users = User.create([{ name: 'Lakshadeep',email: 'lakshadeep@vacationlabs.com',password: '12345678',password_confirmation: '12345678',is_admin: true,profile_pic:  File.new("test/fixtures/photos/avatar5.jpg") },
# 	{ name: 'Sanoop',email: 'sanoop@vacationlabs.com',password: '12345678',password_confirmation: '12345678',is_admin: false,profile_pic:  File.new("test/fixtures/photos/avatar6.jpg") },
# 	{ name: 'Pradosh',email: 'pradosh@vacationlabs.com',password: '12345678',password_confirmation: '12345678',is_admin:false,profile_pic:  File.new("test/fixtures/photos/avatar2.png") },
# 	{ name: 'Ankita',email: 'ankita@vacationlabs.com',password: '12345678',password_confirmation: '12345678',is_admin: false,profile_pic:  File.new("test/fixtures/photos/avatar4.jpg") }])

users = User.create([{ name: 'Lakshadeep',email: 'lakshadeep@vacationlabs.com',password: '12345678',password_confirmation: '12345678',is_admin: true,profile_pic:  File.new("test/fixtures/photos/avatar5.jpg") }])


# u = User.all

# u1 = u[0]
# u2 = u[1]
# u3 = u[2]
# u4 = u[3]

# events = Event.create([{title: 'Dudhsagar Waterfall Trek',latitude: 15.312683,longitude: 74.314098, address: 'Sonaulim Goa India', start_time: Time.zone.parse('2015-08-21 12:00'),end_time: Time.zone.parse('2015-08-22 12:00'), total_seats: 50, creator_id: u1.id,is_approved: true,count_confirmed_people: 0,price: 1000},
# 	{title: 'Goa Going Gone Retreat',latitude: 15.147792,longitude: 73.949798, address: 'Bamboo Retreat Center Goa India', start_time: Time.zone.parse('2015-08-18 15:00'),end_time: Time.zone.parse('2015-08-20 12:00'), total_seats:0, creator_id: u2.id,is_approved: true,count_confirmed_people: 0,price: 1000},
# 	{title: 'Furniture and Furnishing Show',latitude: 15.482424,longitude: 73.822565, address: 'Taleigao Goa India', start_time: Time.zone.parse('2015-09-24 12:00'),end_time: Time.zone.parse('2015-09-28 23:00'), total_seats:0 , creator_id: u3.id,is_approved: true,count_confirmed_people: 0,price:100},
# 	{title: 'TechHub Bangalore demo night',latitude: 12.969353,longitude: 77.592721, address: 'Bangalore Karnataka India', start_time: Time.zone.parse('2015-09-04 18:00'),end_time: Time.zone.parse('2015-09-05 9:00'), total_seats: 200, creator_id: u4.id,is_approved: true,count_confirmed_people: 0,price:0},
# 	{title: 'Maker Mela 2015',latitude: 19.073583,longitude: 72.899308, address: 'Vidhyanagar, Vidhyanagar East, Mumbai India', start_time: Time.zone.parse('2015-10-10 18:00'),end_time: Time.zone.parse('2015-10-12 12:00'), total_seats: 100, creator_id: u1.id,is_approved: true,count_confirmed_people: 0,price:0},
# 	{title: 'EDM night',latitude: 15.539957,longitude: 73.759467, address: 'Calangute Goa India', start_time: Time.zone.parse('2015-09-29 18:00'),end_time: Time.zone.parse('2015-09-30 00:00'), total_seats: 200, creator_id: u1.id,is_approved: true,count_confirmed_people: 0,price:2000},
# 	{title: 'Independance day celebration',latitude:15.489141,longitude: 73.815801, address: 'Panaji India', start_time: Time.zone.parse('2015-09-15 9:00'),end_time: Time.zone.parse('2015-09-15 11:00'), total_seats: 0, creator_id: u1.id,is_approved: true,count_confirmed_people: 0,price:0},
# 	{title: 'India Tour of Sri Lanka Cricket',latitude: 6.881261,longitude: 79.862438, address: 'Colombo Sri Lanka', start_time: Time.zone.parse('2015-09-10 09:00'),end_time: Time.zone.parse('2015-10-10 9:00'), total_seats: 200000, creator_id: u1.id,is_approved: true,count_confirmed_people: 0,price:50000},
# 	{title: 'Real Madrid Vs Barcelona El classico',latitude: 40.453058,longitude: -3.688629, address: 'Santiago Bernabeau Madrid Spain', start_time: Time.zone.parse('2015-11-04 18:00'),end_time: Time.zone.parse('2015-11-04 20:00'), total_seats: 90000, creator_id: u1.id,is_approved: true,count_confirmed_people: 0,price:50000}
# 	])

# t1 = Tag.find(1)
# t2 = Tag.find(2)
# t3 = Tag.find(3)
# t4 = Tag.find(4)
# t5 = Tag.find(5)
# t6 = Tag.find(6)
# t7 = Tag.find(7)
# t8 = Tag.find(8)


# u1 = User.find(1)
# u2 = User.find(2)
# u3 = User.find(3)
# u4 = User.find(4)

# u1.tags << t1
# u1.tags << t2
# u1.tags << t7


# u2.tags << t1
# u2.tags << t2
# u2.tags << t4

# u3.tags << t8
# u3.tags << t6
# u3.tags << t4

# u4.tags << t3
# u4.tags << t7
# u4.tags << t5

# e1 = Event.find(1)
# e2 = Event.find(2)
# e3 = Event.find(3)
# e4 = Event.find(4)
# e5 = Event.find(5)
# e6 = Event.find(6)
# e7 = Event.find(7)
# e8 = Event.find(8)
# e9 = Event.find(9)


# e1.tags << t6

# e2.tags << t7

# e3.tags << t5

# e4.tags << t5
# e4.tags << t8

# e5.tags << t5
# e5.tags << t8


# e6.tags << t1
# e6.tags << t3
# e6.tags << t4

# e7.tags << t5

# e8.tags << t2

# e9.tags << t2

# photos = Photo.create([{ event_pic:  File.new("test/fixtures/photos/dudhsagar1.jpg") },
# 	{ event_pic:  File.new("test/fixtures/photos/ggg1.jpg") },
# 	{ event_pic:  File.new("test/fixtures/photos/furniture2.jpg") },
# 	{ event_pic:  File.new("test/fixtures/photos/techhub1.jpg") },
# 	{ event_pic:  File.new("test/fixtures/photos/makerfest1.png") },
# 	{ event_pic:  File.new("test/fixtures/photos/edm1.jpg") },
# 	{ event_pic:  File.new("test/fixtures/photos/independance1.jpg") },
# 	{ event_pic:  File.new("test/fixtures/photos/classico1.jpg") },
# 	{ event_pic:  File.new("test/fixtures/photos/indsl2.jpg") }])

# p1 = Photo.find(1)
# p2 = Photo.find(2)
# p3 = Photo.find(3)
# p4 = Photo.find(4)
# p5 = Photo.find(5)
# p6 = Photo.find(6)
# p7 = Photo.find(7)
# p8 = Photo.find(8)
# p9 = Photo.find(9)

# p1.events << e1
# p2.events << e2
# p3.events << e3
# p4.events << e4
# p5.events << e5
# p6.events << e6
# p7.events << e7
# p8.events << e9
# p9.events << e8








