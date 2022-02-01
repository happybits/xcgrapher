#!/usr/bin/env bundle exec ruby
# frozen_string_literal: true

require 'xcodeproj'

project_file = '/Users/jrgoodle/projects/joya/marcopolo-app/ios/Marco Polo.xcodeproj'
target_name = 'Marco Polo Dev'

xcode_project = Xcodeproj::Project.open(project_file)

target = xcode_project.targets.filter { |t| t.name == target_name }.first

# source_files = target.source_build_phase.files.to_a.reject { |f| f.file_ref.nil? }
# source_files.each do |f|
#   puts f.file_ref.real_path.to_s
# end

# header_files = target.headers_build_phase.files.to_a.reject { |f| f.file_ref.nil? }
# header_files.each do |f|
#   puts f.file_ref.real_path.to_s
# end

dependencies = target.dependencies

# # target_dependencies = dependencies.to_a.reject { |d| d.target.nil? }
# # target_dependencies.each do |d|
# #   puts d.target.name.to_s
# # end

# # name_dependencies = dependencies.to_a.reject { |d| d.name.nil? }
# # name_dependencies.each do |d|
# #   puts d.name.to_s
# # end

# # display_name_dependencies = dependencies.to_a.reject { |d| d.display_name.nil? }
# # display_name_dependencies.each do |d|
# #   puts d.display_name.to_s
# # end

# # proxy_dependencies = dependencies.to_a.reject { |d| d.target_proxy.nil? }
# # proxy_dependencies.each do |d|
# #   puts d.target_proxy.remote_info.to_s
# # end

def print_deps(dependency)
  target_proxy = dependency.target_proxy
  if target_proxy.nil?
    puts '<nil>'
    return
  end
  proxied_object = target_proxy.proxied_object
  puts proxied_object
  proxied_object.dependencies.to_a.each do |d|
    print_deps(d)
  end
end

dependencies.each do |d|
  print_deps(d)
end

# framework_files = target.frameworks_build_phase.files.to_a.reject { |f| f.file_ref.nil? }
# framework_files.each do |f|
#   # puts f.file_ref.real_path.to_s
#   # puts "#{f.display_name} #{f.class}"
#   puts f.display_name
# end
