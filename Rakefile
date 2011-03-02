require 'rubygems'

#require 'bundler'
#begin
#  Bundler.setup(:default, :development)
#rescue Bundler::BundlerError => e
#  $stderr.puts e.message
#  $stderr.puts "Run `bundle install` to install missing gems"
#  exit e.status_code
#end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "vocco"
  gem.homepage = "http://github.com/jbe/vocco"
  gem.license = "MIT"
  gem.summary = %Q{vocco is an extra super quick-and-dirty documentation generator based on Vim, written in Ruby.}
  gem.description = %Q{vocco is an extra super quick-and-dirty documentation generator based on Vim, written in Ruby.}
  gem.email = "post@jostein.be"
  gem.authors = ["jbe"]

  gem.add_runtime_dependency 'trollop'
  gem.add_runtime_dependency 'why-hpricot'
  gem.add_runtime_dependency 'tilt'
  gem.add_runtime_dependency 'rdiscount'

  gem.add_development_dependency 'shoulda'
  gem.add_development_dependency 'jeweler'
  gem.add_development_dependency 'tilt'
  gem.add_development_dependency 'slim'
  gem.add_development_dependency 'haml'
  #gem.add_development_dependency 'i18n'
  gem.add_development_dependency 'activesupport'
  gem.add_development_dependency 'vocco'
end
Jeweler::RubygemsDotOrgTasks.new


def precompile(const_name, template)

  require 'active_support/inflector'
  String.send :include, ActiveSupport::Inflector

  path = File.join('lib', const_name.underscore + '.rb')

  generated = case template
    when Tilt::SassTemplate then template.render
    when Slim::Template then template.send(:precompiled_template, {})
    else raise 'unsupported template'
  end

  heredoc_str = '__YOU_ARE_SPECIAL__'
  opener      = "#{const_name} = <<-'#{heredoc_str}'\n"
  closer      = "\n#{heredoc_str}\n"

  File.open(path, 'w') do |file|
    file.write opener + generated + closer
  end
end



task :docs do
  require 'vocco'
  Vocco.run(
    :out    => 'website', 
    :files  => %w{README LICENSE lib/**/*.rb}
    )
end


namespace :build do
  task :templates do
    require 'tilt'
    require 'slim'
    precompile(
      'Vocco::Generator::CSS',
      Tilt.new('template/css.sass')
      )
    precompile(
      'Vocco::Generator::SourceFile::HTML_TEMPLATE',
      Tilt.new('template/html.slim', :auto_escape => false)
      )
  end
end

