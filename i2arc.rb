	require 'fileutils'
	
	def extract_resources_from_folder(folder_path, xhdpi_folder, xxhdpi_folder)
		Dir.glob("#{folder_path}/*") do |filename|
			if File.directory?(filename)
				puts "Moving to folder #{filename}"
				extract_resources_from_folder(filename, xhdpi_folder, xxhdpi_folder)
			else
				f = File.basename(filename)
				if f.end_with? "@2x.png"
					Dir.mkdir(xhdpi_folder) unless File.exists?(xhdpi_folder)
					destination = File.join(xhdpi_folder, File.basename(folder_path).gsub("-", "_").gsub(" ", "_") + "_" + f.sub("@2x", "").gsub("-", "_"))
					FileUtils.cp(filename, destination)
					puts "Copying #{f} to #{destination}"
				elsif f.end_with? "@3x.png"
					Dir.mkdir(xxhdpi_folder) unless File.exists?(xxhdpi_folder)
					destination = File.join(xxhdpi_folder, File.basename(folder_path).gsub("-", "_").gsub(" ", "_") + "_" + f.sub("@3x", "").gsub("-", "_"))
					FileUtils.cp(filename, destination)
					puts "Copying #{f} to #{destination}"
				else
					puts "SKIPPING #{f}..."
				end
			end
		end
	end
	if __FILE__ == $0

	if ARGV.length != 1
		root_folder = ""
	else
		root_folder = ARGV[0]
	end

	folder_path = File.join(Dir.pwd, root_folder)

	xhdpi_folder = File.join(folder_path, "/drawable-xhdpi")
	xxhdpi_folder = File.join(folder_path, "/drawable-xxhdpi")

	unless File.directory?(folder_path)
		puts "Error: #{folder_path} is not a valid folder."
		exit
	end

	puts "Starting script on '#{folder_path}'"

	extract_resources_from_folder(folder_path, xhdpi_folder, xxhdpi_folder)

	end