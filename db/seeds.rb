require 'csv'

# Clear existing data to prevent duplicates
Statistic.destroy_all
ServiceArea.destroy_all
Library.destroy_all

csv_path = Rails.root.join('db', 'library_data.csv')
puts "Seeding from #{csv_path}..."

current_library = nil

CSV.foreach(csv_path, headers: true) do |row|
  # Debug: Let's see what we're actually getting
  puts "Raw row data: #{row.to_h.inspect}" if rand < 0.1 # Show 10% of rows for debugging
  
  # Try different ways to access the Location column
  library_name = row['Location'] || row[0] # Try by header name or by index
  municipality = row['Municipality / Local Government'] || row[1] # Try by header name or by index
  
  # Clean up the data
  library_name = library_name&.strip
  municipality = municipality&.strip
  
  puts "Processing: '#{library_name}' - '#{municipality}'"
  
  # Skip if we don't have a library name
  if library_name.blank?
    puts "  Skipping row - no library name"
    next
  end
  
  # Check if this row represents library info (municipality is a number) or service area info
  if municipality =~ /^\d+$/ # If municipality is just a number, this is library-level data
    puts " Processing LIBRARY row"
    
    # Get the other library attributes
    bilingual = (row['Bilingual?'] || row[2])&.strip == '1'
    northern = (row['Northern?'] || row[3])&.strip == '1'
    population_str = (row['Population'] || row[4])&.to_s&.gsub(/[,\s]/, '')
    population = population_str.to_i
    
    # Create or find the library
    current_library = Library.find_or_create_by(name: library_name) do |lib|
      lib.bilingual = bilingual
      lib.northern = northern
      lib.population = population
    end
    
    puts "✓ Created/found library: #{current_library.name} (bilingual: #{bilingual}, northern: #{northern}, population: #{population})"
    
  else
    puts " Processing SERVICE AREA row"
    
    # This is service area data under the current library
    if current_library.nil?
      puts "  No current library for service area: #{municipality}"
      next
    end
    
    if municipality.blank?
      puts "  Blank municipality, skipping"
      next
    end
    
    # Get service area attributes
    population_str = (row['Population'] || row[4])&.to_s&.gsub(/[,\s]/, '')
    population = population_str.to_i
    
    service_area = ServiceArea.find_or_create_by(
      name: municipality, 
      library: current_library
    ) do |sa|
      sa.population = population
      sa.municipality = municipality  # Set the municipality field
    end
    
    # Create statistic for this service area
    active_users_str = (row['Active users'] || row[5])&.to_s&.gsub(/[,\s]/, '')
    active_users = active_users_str.to_i
    
    percent_str = (row['Active users as percent of population'] || row[6])&.to_s&.gsub('%', '')
    percent = percent_str.present? ? percent_str.to_f : 0.0
    
    begin
      statistic = Statistic.create!(
        service_area: service_area,
        month: 'unknown',
        active_users: active_users,
        percentage: percent,
        population: population,
        active_users_percent: percent > 0 ? "#{percent}%" : "0%",
        municipality: municipality,
        bilingual: current_library.bilingual,  # Use library's bilingual status
        northern: current_library.northern     # Use library's northern status
      )
      
      puts "   Created service area: #{service_area.name} (#{active_users} users, #{percent}%)"
    rescue => e
      puts "  Error creating statistic: #{e.message}"
    end
  end
end

puts "\n" + "="*50
puts "Seeding completed!"
puts "Libraries: #{Library.count}"
puts "Service Areas: #{ServiceArea.count}"  
puts "Statistics: #{Statistic.count}"

# Show some sample data
if Library.count > 0
  puts "\nSample Libraries:"
  Library.limit(3).each do |lib|
    puts "- #{lib.name} (#{lib.service_areas.count} service areas)"
  end
end

puts "="*50