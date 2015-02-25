require "pathname"

module Liability
  class Checker
    RUBY_VERSION_FILES = [ ".ruby-vesion", "Gemfile" ]
    RUBY_VERSION_NUMBER_PATTERN = /^(\d.\d.\d)$/
    GEMFILE_VERSION_NUMBER_PATTERN = /^(?:ruby)\s['"](\d.\d.\d)['"]$/
    SUPPORTED_RUBY_VERSIONS = %w[
      2.0.0-preview1
      2.0.0-preview2
      2.0.0-rc1
      2.0.0-rc2
      2.0.0-p0
      2.0.0-p195
      2.0.0-p247
      2.0.0-p353
      2.0.0-p451
      2.0.0-p481
      2.0.0-p576
      2.0.0-p594
      2.0.0-p598
      2.1.0-dev
      2.1.0-preview1
      2.1.0-preview2
      2.1.0-rc1
      2.1.0
      2.1.1
      2.1.2
      2.1.3
      2.1.4
      2.1.5
      2.2.0-dev
      2.2.0-preview1
      2.2.0-preview2
      2.2.0-rc1
      2.2.0
      2.3.0-dev
    ]

    def self.invoke
      check(ARGV, $stderr, $stdout)
    end

    def self.check(args, err=$stderr, out=$stdout)
      new.check(args)
    end

    def initialize
    end

    def check(args)
      if args.include?('-r')
        directory_option_index = args.index('-r') + 1
        directory = args[directory_option_index]
        recursive_check(directory)
      else
        simple_check(".")
      end
    end

    def simple_check(pathname)
      puts "Doing a simple Ruby liability check on '#{pathname}' ..."

      files = Pathname.new(pathname).children.select { |c| c.file? }

      if unsupported_ruby_versions?(files).empty?
        puts "All clear! There are no unsupported Ruby versions used in '#{pathname}'."
      else
        puts "Warning: The following Ruby versions are used inside of '#{pathname}':"
        puts unsupported_ruby_versions?(files)
      end
    end

    def recursive_check(directory)
      sub_directories = Pathname.new(directory).children.select { |c| c.directory? }

      puts "Doing a recursive Ruby liability check on '#{directory}' ..."

      if sub_directories.empty?
        simple_check(directory)
      else
        sub_directories.each do |dir|
          simple_check(dir)
        end
      end
    end

    private

    def find_referenced_ruby_versions(files)
      ruby_version_files = find_ruby_version_files(files)
      versions_detected = scan_ruby_version_files(ruby_version_files)
    end

    def find_ruby_version_files(files)
      ruby_version_files = files.map(&:to_s).select do |file|
        RUBY_VERSION_FILES.select { |version_file| file.include?(version_file) }
      end
    end

    def scan_ruby_version_files(files)
      files.map do |file|
        versions = []

        # ASCII-8BIT is forcing the encoding to ASCII-8BIT which seems
        # strange but prevents invalid character exceptions from many
        # Gemfiles and .ruby-version files.
        if file.to_s.include?("Gemfile")
          File.open file, "r:ASCII-8BIT" do |f|
            versions = f.each_line.map do |line|
              match = line.match(GEMFILE_VERSION_NUMBER_PATTERN)
              match ? match.captures.first : nil
            end
          end
        else
          File.open file, "r:ASCII-8BIT" do |f|
            versions = f.each_line.map do |line|
              match = line.match(RUBY_VERSION_NUMBER_PATTERN)
              match ? match.captures.first : nil
            end
          end
        end

        versions.compact.uniq
      end
    end

    def unsupported_ruby_versions?(files)
      find_referenced_ruby_versions(files).select do |version|
        !SUPPORTED_RUBY_VERSIONS.include?(version)
      end
    end
  end
end
