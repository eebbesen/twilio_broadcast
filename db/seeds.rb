# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user = User.create(email: 'user@tb.tb.moc', password: 'Passw0rd!', password_confirmation: 'Passw0rd!')
user2 = User.create(email: 'user2@tb.tb.moc', password: 'Passw0rd!2', password_confirmation: 'Passw0rd!2')

Recipient.create(phone: '0005551212', user: user)
Recipient.create(phone: '0005551213', email: 'recipient3@tb.tb.moc', user: user)
Recipient.create(phone: '0005551213', email: 'recipient3.2@tb.tb.moc', user: user2)
Recipient.create(phone: '0005551214', email: 'recipient4@tb.tb.moc', user: user2)
Recipient.create(phone: '0005551215', email: 'recipient5@tb.tb.moc', user: user2)
