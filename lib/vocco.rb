

#        Gem          Use
require 'hpricot'   # parse and modify html
require 'tilt'      # generate sidebar html
require 'tempfile'  # temporary vimscript


module Vocco

  #        File               Responsibility
  require 'vocco/generator' # Generate docs
  require 'vocco/cli'       # Command line interface

  class << self

    # Vocco::run is the interface for using Vocco as a gem.
    def run(opts)
      validate(opts)
      Generator.new(
        DEFAULTS.merge(opts)
        ).run
    end

    alias :run! :run
    alias :start :run

    def validate(opts)
      bad_opts = opts.keys - OPTION_NAMES

      if bad_opts.any?
        raise "Invalid options: #{bad_opts}"
      end
    end

    # Tries to read a property from the gemspec with the same name
    # as the working dir, in the working dir.
    def gemspec(prop)
      begin
        require 'rubygems'
        @gemspec ||= Gem::Specification.load(
          Dir['**/*.gemspec'].first
        @gemspec.send prop
      rescue
        nil
      end
    end
  end

  
  # These are the available options. They can be given on
  # the command line, the linux way, or as a hash to
  # Vocco.run(...), the Rubygem way. The format is:
  #
  # [name,    description,
  #           default_value
  #   ]

  OPTIONS = [
    [:files,  "File match globs",
              %w{**/*.rb README LICENSE}
      ],

    [:out,    "Output directory",
              './docs'
      ],

    [:notes,  "Note directories",
              ['./notes']
      ],

    [:name,   "Project name",
              gemspec(:name) || File.basename(Dir.pwd)
      ],

    [:site,   "Project url",
              gemspec(:homepage)
      ],

    [:vim,    "Vim command", %w{macvim gvim vim}
      ]
  ]

  OPTION_NAMES  = OPTIONS.map {|opt| opt.first }

  DEFAULTS      = {}
  
  OPTIONS.each do |opt|
    DEFAULTS[opt[0]] = opt[2]
  end

end


