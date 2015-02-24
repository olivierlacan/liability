module Liability
  class Checker
    def self.invoke
      status = check(ARGV, $stderr, $stdout).to_i
      exit(status) if status != 0
    end

    def self.check(args, err=$stderr, out=$stdout)
      new.check
    end

    def initialize
    end

    def check

    end
  end
end
