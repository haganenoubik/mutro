# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

moods = [
  { name: '選択しない', image_filename: nil },
  { name: '都会的', image_filename: 'urban-image.png' },
  { name: '気分を上げる', image_filename: 'energy-image.png' },
  { name: 'リラックス', image_filename: 'chill-image.png' },
  { name: '懐かしい', image_filename: 'nostalgic-image.png' }
]

moods.each do |mood_data|
  Mood.find_or_create_by(name: mood_data[:name]) do |mood|
    mood.image_filename = mood_data[:image_filename]
  end
end
