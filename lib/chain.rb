require "benchmark"

class Chain
  class << self
    def create_processes(n)
      last = 0
      n.times do |_|
        t = Thread.fork(last) do |n|
          n + 1
        end
        last = t.value
      end

      last
    end

    def run(n)
      result = 0
      result = self.create_processes(n)
      puts result
    end
  end
end

Chain.run(ARGV[0].to_i)
