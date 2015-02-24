require "pathname"

module Liability
  class Checker
    def self.invoke
      status = check(ARGV, $stderr, $stdout).to_i
      exit(status) if status != 0
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

    def simple_check(directory)
      puts "Doing a simple Ruby liability check on #{directory}..."
    end

    def recursive_check(directory)
      sub_directories = Pathname.new(directory).children.select { |c| c.directory? }

      puts "Doing a recursive Ruby liability check on #{directory}..."

      if sub_directories.empty?
        simple_check(directory)
      else
        sub_directories.each do |dir|
          simple_check(dir)
        end
      end
    end
  end
end
