# Rakefile.rb - for Harvard CSCI E-168, Fall 2008
# Assignment 3, Milestone III
# MetricsMine
#
# To see a list of tasks, type
#
#   rake -T
#
# For a solid beginners' tutorial on Rake, see
#
#   http://www.railsenvy.com/2007/6/11/ruby-on-rails-rake-tutorial
#

require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'

# Rake comes with a number of ready-made tasks: require a few
require 'rake/clean'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rake/packagetask'
require 'tasks/rails'

# Define some variables for our major directories
app_dir          = 'app/'
doc_dir          = 'doc/'
instructions_dir = 'instructions/'
lib_dir          = 'lib/'
log_dir          = 'log/'
pkg_dir          = 'pkg/'
stubs_dir        = 'stubs/'
test_dir         = 'test/'
tmp_dir          = 'tmp/'

# And a few constants we will use for the name of the ZIP
PROJECT_HUMAN    = 'Assigment 3 (MetricsMine, Milestone 3), Harvard CSCI E-168, Fall 2008'
PROJECT          = 'e168-assignment3-milestone-3'
PROJECT_VERSION  = '3.0.000'
USER             = (ENV['USER'] || ENV['USERNAME'] || 'Unknown').gsub(/\W+/,'')

# Which directories should be removed for rake clobber
CLOBBER.include(pkg_dir, doc_dir)

# Something we need for brain-dead Windows
def quote_if_windows(p)
  if RUBY_PLATFORM =~ /mswin32/
    '"' + p + '"'
  else
    p
  end
end

# Hash of possible ZIP commands. Key is human-readable, value is the command
ZIP_COMMANDS     = {
  '0. Native ZIP' => 'zip',
  '1. rubyzip'    => 'ruby ' + quote_if_windows(File.join(File.dirname(__FILE__), 'bin', 'zip_in_ruby.rb')),
#  '2. PKZIPC'     => (quote_if_windows(File.join(File.dirname(__FILE__), 'bin', 'PKZIPC.exe')) + ' -add -dir')
}

# Determine which, if any, ZIP commands work on this system
def find_zip
  zip_command = nil
  ZIP_COMMANDS.keys.sort.each do |z|
    zip_command_name, zip_cmd = z, ZIP_COMMANDS[z]
    begin
      # A ZIP command we hope will work
      %x{#{zip_cmd} -r FIND_ZIP.zip README}
      # It worked, so save it, and break out
      zip_command = zip_cmd
      break
    rescue
      # Didn't work . . .
    ensure
      rm_f 'FIND_ZIP.zip'
    end
  end
  if (zip_command == nil)
    print "No ZIP commands worked: ZIP manually. Make sure the assignment name and your name are in the ZIP archive name.\n"
    exit
  else
#    print "Using ZIP command: #{zip_command}\n"
    zip_command
  end
end
ZIP_COMMAND = find_zip

# Task that should run if none specified
task :default => :test

desc "E168: Create ZIP for submission"
task :'e168:submit' => [:package, :'e168:summarize'] do |t|
end

# Removed: This was used when the schema comparison was done as an actual test
# desc "E168: test migrations"
# Rake::TestTask.new('e168:test:migrations') do |t|
#   t.libs = [lib_dir, test_dir]
#   t.pattern = test_dir + 'migration/tc_*tables.rb'
#   t.warning = false
# end

desc "generate the documentation"
Rake::RDocTask.new do |rd|
	rd.rdoc_files.include('README')
	rd.rdoc_files.include(app_dir + '**/*.rb')
  rd.rdoc_files.exclude(pkg_dir)
  rd.rdoc_files.exclude(test_dir)
	rd.rdoc_dir = doc_dir + 'rdoc'
	rd.main = 'README'
	rd.title = PROJECT_HUMAN
end

Rake::PackageTask.new("#{PROJECT}-#{USER}", PROJECT_VERSION) do |p|
  p.need_zip = true
  p.zip_command = ZIP_COMMAND
  p.package_files.include('**/*.*')
  p.package_files.include('**/*')
  p.package_files.include('*')
  p.package_files.exclude('**/*.svn')
  p.package_files.exclude(log_dir + '**/*')
  p.package_files.exclude(tmp_dir + '**/*')
  p.package_files.exclude(pkg_dir)
end

task :'e168:summarize' do |t|
  zip_archive = "#{PROJECT}-#{USER}-#{PROJECT_VERSION}.zip"
  print "\n----------\n\n"
  print "Your ZIP is in #{File.join(File.dirname(__FILE__), pkg_dir, zip_archive)}\n\n"
  print "----------\n\n"
end

# Tasks below are for taking the original project, and
# shaping into the student assignment. If you're a student,
# you won't need to use these. The basic idea is that to
# distribute the assignment, we run all the tests (spot and
# test), clobber (i.e., clean) the project, generate the
# documentation from the sample solution, move those docs
# into the instructions/ directory, remove the solution
# source, put "stubs" in place for the student solution,
# zip everything up . . . and, finally, get back the orignal
# solution source from subversion.
task :'e168:rearrange' do |t|
  remove_dir instructions_dir, true
#  rm_f './README'
#  copy_file stubs_dir + 'README', 'readme.txt'

  # Remove solutions, etc.
  rm_f './generate_fixtures.sh'
#  rm_rf Dir.glob('db/migrate/2008*')
#  rm_rf Dir.glob('db/development.sqlite3')
  rm_rf Dir.glob('db/test.sqlite3')
  rm_rf Dir.glob('db/schema.rb')
#  rm_rf Dir.glob(log_dir + '**/*')
  rm_rf Dir.glob('log/*')
  rm_rf Dir.glob(tmp_dir + '**/*')
  mv doc_dir, instructions_dir
  rm_rf Dir.glob('vendor/plugins/ar_fixtures*')
  # Copy stubs to proper locations
  # Must copy models, migrations
  cp Dir.glob('stubs/app/controllers/*'),             'app/controllers/'
  cp Dir.glob('stubs/app/views/observation_kinds/*'), 'app/views/observation_kinds/'
  cp Dir.glob('stubs/app/views/measurements/*'),      'app/views/measurements/'
  cp Dir.glob('stubs/app/views/units/*'),             'app/views/units/'
  cp Dir.glob('stubs/app/views/observation_sets/*'),  'app/views/observation_sets/'
  cp Dir.glob('stubs/app/models/*'), 'app/models/'
  cp Dir.glob('stubs/db/migrate/*'), 'db/migrate/'
  cp Dir.glob('stubs/lib/*'), 'lib/'
    
  # rdoc generates documentation that includes a copy of the source;
  # remove it.
  rm_rf Dir.glob(instructions_dir + 'app/classes/Finders.html')
  remove_dir stubs_dir, true
end

task :'e168:zip_me' do |t|
  rm_rf "../#{PROJECT}-#{PROJECT_VERSION}.zip"
#  sh %{ruby ./bin/zip_in_ruby.rb -r ../#{PROJECT}-#{PROJECT_VERSION}.zip .}
# Next version uses native ZIP
  sh %{zip -r ../#{PROJECT}-#{PROJECT_VERSION}.zip . -x \*\.svn/* }
end

task :'e168:restore_after_rearrange' do |t|
  rm_rf Dir.glob(instructions_dir)
  rm_rf 'app/models'
  rm_rf 'app/controllers'
  rm_rf 'app/views'
  rm_rf 'db/migrate'
  rm_rf 'lib'
  sh %{svn update}
end

task :'e168:create_assignment_zip' => [ :test, :'doc:app', :'e168:rearrange', 'e168:zip_me', :'e168:restore_after_rearrange' ] do |t|
end
