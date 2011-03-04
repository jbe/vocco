


class Vocco::Generator::SourceFile
  require 'vocco/generator/source_file/html_template'

  NOTE_FORMATS = '.{textile,md,mkd,markdown,rdoc}'

  def initialize(file, generator)
    @file       = file
    @gen        = generator
  end

  attr_reader :file # full file path

  # full dirname
  def dirname
    File.dirname(@file)
  end

  def basename
    File.basename(@file)
  end

  # file path with glob dir scope trimmed off
  def short_path
    @short_path ||= @file.sub(@gen.glob_regex, '')
  end

  # dirname of the above
  def short_dirname
    File.dirname(short_path).sub(/^\.\//, '')
  end

  # corresponding doc file basename
  def doc_basename
    doc_scope + basename + '.html'
  end

  # corresponding doc file path
  def doc_path
    File.join(@gen.out, doc_basename)
  end

  # relative link to doc
  def doc_link
    './' + doc_basename
  end

  def notes
    @notes ||= Dir[note_glob].map do |path|
      Tilt.new(path).render
    end
  end

  # make a method for the html template
  class_eval <<-EOF, '(template)'
    def render_template
      #{HTML_TEMPLATE}
    end
  EOF

  private
    # doc filename prefix based on source file folder
    def doc_scope
      short_dirname == '.' ? '' : short_dirname.gsub('/', '-') + '-'
    end

    # the dirs in which to look for notes concerning this file.
    def note_dirs
      @gen.notes.inject([dirname]) do |dirs, dir|
        dirs << File.join(dir, short_dirname)
      end
    end

    # glob matching notes concerning this file
    def note_glob
      '{' + note_dirs.join(',') + '}/' + basename + NOTE_FORMATS
    end
end

