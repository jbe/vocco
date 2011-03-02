

class Vocco::Generator

  require 'vocco/generator/css'

  attr_reader :globs, :notes, :out, :name, :site

  def initialize(opts)
    @globs  = opts[:files]
    @out    = opts[:out]
    @notes  = opts[:notes]
    @name   = opts[:name].capitalize
    @site   = opts[:site]
    @vim    = opts[:vim]
    validate_out
  end

  def run
    run_vim; postprocess
  end
  alias :run! :run

  def glob_regex
    @glob_regex ||= begin
      str = @globs.map do |g|
        Regexp::escape(
          File.dirname(
            g.split('*').first
          )) + '\/'
      end.join('|')
      /^(\.\/)?(#{str})/
    end
  end

  def doc_regex
    @doc_regex ||= begin
      str = Regexp::escape(@out) + '/'
      /^#{str}/
    end
  end

  def files
    @files ||= @globs.map do |glob|
      Dir[glob].map {|path| SourceFile.new(path, self) }
    end.flatten
  end

  private

    def validate_out
      unless File.directory?(@out)
        raise "#{@out} is not a valid directory."
      end
    end

    def run_vim
      script = Tempfile.new('vimdocco')
      script.write(vimscript)
      script.close
      system "#{vim_command} -f -S #{script.path}"
      script.delete
    end

    def vim_command
      @vim_command ||= @vim.detect do |c|
        `which #{c}`.chomp.strip != ''
      end || abort("You must install one of #{@vim.inspect}.")
    end

    def vimscript
      @vimscript ||= begin
        s = "let html_no_pre = 1\n"
        files.each do |file|
          s << "view! #{file.file}\n"
          s << "TOhtml\n"
          s << "w! #{file.doc_path}\n"
        end
        s << ":qall!\n"
      end
    end

    def postprocess
      hpricotify_docs do |doc, file|
        doc.at('style').after('<style type="text/css">' + CSS + '</style>')
        doc.at('title').inner_html = name + ' : ' + file.basename
        inner = doc.at('body').inner_html
        doc.at('body').swap "<body><div class='code'>#{inner}</div></body>"
        doc.at('.code').after file.render_template
      end
    end

    def hpricotify_docs
      files.each do |file|
        doc = File.open(file.doc_path) {|f| Hpricot(f) }
        yield(doc, file)
        File.open(file.doc_path, 'w')  {|f| f.write(doc.to_html) }
      end
    end
end

class Vocco::Generator::SourceFile
  require 'vocco/generator/source_file/html_template'

  def initialize(file, generator)
    @file       = file
    @gen        = generator
  end

  attr_reader :file

  def short_path
    @short_path ||= @file.sub(@gen.glob_regex, '')
  end

  def short_dirname
    File.dirname(short_path)
  end

  def dirname
    File.dirname(@file)
  end

  def basename
    File.basename(@file)
  end

  def doc_path
    File.join(@gen.out, short_dirname.gsub('/', '_') +
              '_' + basename + '.html')
  end

  def doc_link
    './' + doc_path.sub(@gen.doc_regex, '')
  end

  def notes
    rendered = render_notes
    rendered.any? ?
      rendered.join("\n") : nil
  end

  def render_notes
    Dir[note_glob].map do |path|
      Tilt.new(path).render
    end
  end

  def note_glob
    dirs = [dirname]
    @gen.notes.each do |dir|
      dirs << File.join(dir, short_dirname)
    end
    ext       = '.{textile,md,mkd,markdowb,rdoc}'
    dir_glob  = '{' + dirs.join(',') + '}/'
    dir_glob + basename + ext
  end

  class_eval <<-EOF, '(template)'
    def render_template
      #{HTML_TEMPLATE}
    end
  EOF
end
