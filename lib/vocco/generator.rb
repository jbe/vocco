
require 'fileutils'


class Vocco::Generator

  #        File                           What
  require 'vocco/generator/css'         # CSS additions
  require 'vocco/generator/source_file' # SourceFile class

  attr_reader :globs, :notes, :out, :name, :site

  def initialize(opts)
    @globs  = Array(opts[:files]
              ).compact.map do |glob|
                glob.gsub(/(^\.\/)|(\/$)/, '')
              end
    @out    = opts[:out]
    @notes  = Array(opts[:notes]).compact
    @name   = opts[:name].capitalize
    @site   = opts[:site]
    @vim    = Array(opts[:vim]).compact

    FileUtils.mkdir_p(@out) # ensure out dir exists
  end

  # the paths underneath which the @globs are globbing;
  # the static part of the glob, or "scope" of sorts
  def scopes
    @scopes ||= @globs.map do |glob|
      tokens = glob.split('*')
      tokens.size > 1 ? tokens.first : nil
    end.compact
  end

  # regex to trim the glob dir scopes off a source
  # file path.
  def glob_regex
    @glob_regex ||= begin
      str = scopes.map do |scope|
        Regexp::escape(scope)
      end.join('|')
      /^(\.\/)?(#{str})(\/)?/
    end
  end

  # array of SourceFile's mapped from the glob matches
  def files
    @files ||= @globs.map do |glob|
      Dir[glob]
    end.flatten.uniq.map do |path|
      SourceFile.new(path, self)
    end
  end

  def run
    run_vim; postprocess
  end
  alias :run! :run

  private

    def run_vim
      script = Tempfile.new('vimdocco')
      script.write(vimscript)
      script.close
      puts 'Running ' + vim_command + ':'
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

