

require 'hpricot'
require 'tilt'
require 'tempfile'


module Vocco

  require 'vocco/generator'
  require 'vocco/cli'

  class << self
    def name_fallback
      gemspec(:name) || File.basename(Dir.pwd)
    end

    def site_fallback
      gemspec(:homepage)
    end

    def gemspec(prop)
      begin
        require 'rubygems'
        @gemspec ||= Gem::Specification.load(File.basename(Dir.pwd) + '.gemspec')
        @gemspec.send prop
      rescue
        nil
      end
    end

    def run(opts)

      bad_opts = opts.keys - OPTIONS.map {|line| line[0] }

      unless bad_opts.empty?
        raise "Invalid options: #{bad_opts}"
      end

      0.upto(OPTIONS.size - 1) do |n|
        opts[OPTIONS[n][0]] ||= OPTIONS[n][2]
      end

      Generator.new(opts).run
    end
    alias :run! :run
  end

  OPTIONS = [
    [:files,  "File match globs",   %w{**/*.rb README LICENSE}  ],
    [:out,    "Output directory",   './docs'                    ],
    [:notes,  "Note directories",   ['./notes']                 ],
    [:name,   "Project name",       name_fallback               ],
    [:site,   "Project url",        site_fallback               ],
    [:vim,    "Vim command",        %w{macvim gvim vim}         ]
  ]
end


