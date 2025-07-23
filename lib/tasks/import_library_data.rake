# lib/tasks/import_library_data.rake
require "csv"

namespace :import do
  desc "Import library data from CSV"
  task libraries: :environment do
    csv_path = Rails.root.join("db", "library_data.csv")
    puts " Importing from: #{csv_path}"

    unless File.exist?(csv_path)
      puts " CSV file not found!"
      next
    end

    CSV.foreach(csv_path, headers: true) do |row|
      library_name = row["Location"]&.strip
      municipality = row["Municipality / Local Government"]&.strip
      bilingual = row["Bilingual?"]&.strip == "1"
      northern = row["Northern?"]&.strip == "1"
      population = row["Population"]&.gsub(",", "")&.to_i
      active_users = row["Active users"]&.gsub(",", "")&.to_i
     # If CSV has a value, use it; otherwise calculate it
percent_active = row["Active users as percent of population"]&.gsub("%", "")&.to_f

# Calculate percentage if missing or zero
if percent_active.zero? && active_users && population && population > 0
  percent_active = ((active_users.to_f / population) * 100).round(2)
end

      if library_name.blank?
        puts " Skipping row with blank location"
        next
      end

      # Create or find Library
      library = Library.find_or_create_by(name: library_name)
      puts " Library: #{library.name}"

      # Create or find ServiceArea
      service_area = library.service_areas.find_or_create_by(name: municipality.presence || "General")
      puts " ServiceArea: #{service_area.name}"

      # Create Statistic
      stat = service_area.statistics.create(
        population: population,
        active_users: active_users,
        percent_active: percent_active,
        bilingual: bilingual,
        northern: northern
      )

      if stat.persisted?
        puts " Statistic added: #{active_users} active users / #{population} pop."
      else
        puts " Failed to save stat: #{stat.errors.full_messages.join(", ")}"
      end
    end

    puts " Import complete!"
  end
end
