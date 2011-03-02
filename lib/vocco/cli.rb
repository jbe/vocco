

module Vocco::CLI

  class << self
    def start
      require 'trollop'
      opts = Trollop::options do

        banner "Usage: vocco [options]\n\nOptions:"
        
        ::Vocco::OPTIONS.each do |name, desc, default|
          opt name, desc, :default => default
        end
      end

      ::Vocco::Generator.new(opts).run
    end
  end
end


