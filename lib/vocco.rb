

# TODO: gemfile

require 'nokogiri'

require 'tempfile'


module Vocco

  class Generator

    DEFAULT_GLOBS   = %w{**/*.rb README LICENSE}
    DEFAULT_OUT     = 'docs'

    attr_reader :out, :globs, :files, :docs

    def initialize(out=DEFAULT_OUT, *globs)
      @out = out
      validate_out
      @globs = globs.empty? ? DEFAULT_GLOBS :
                              globs.flatten.compact
      @files  = glob_files
      @docs   = {}
      map_files_to_docs
    end

    def run!
      run_vim
      #write_css
      postprocess
    end

    private

      def validate_out
        unless File.directory?(@out)
          raise "#{@out} is not a valid directory."
        end
      end

      def glob_files
        @globs.map {|glob| Dir[glob] }.flatten
      end

      def map_files_to_docs
        @files.each do |file|
          @docs[file] = File.join(
            @out, File.basename(file) + '.html'
            )
        end
      end

      def run_vim
        script = Tempfile.new('vimdocco')
        script.write(vimscript)
        script.close
        system "gvim -f -S #{script.path}"
        script.delete
      end

      def write_css
        File.open(css_path, 'w') {|f| f.write(CSS) }
      end

      def css_path
        File.join(@out, 'vimdocco.css')
      end

      def postprocess
        modify_docs_using_nokogiri do |doc, orig_path|

          insert :after, 'style', 'style', doc,
            #:rel  => 'stylesheet',
            :type => 'text/css',
            #:href => css_path
            :content => CSS

          insert :before, 'pre', 'pre', doc,
            :content => doc_header(orig_path)
        end
      end

      def insert(vector, path, tag, doc, props={})
        tag = Nokogiri::XML::Node.new tag.to_s, doc
        tag.content = props.delete(:content)
        props.each {|k,v| tag[k.to_s] = v.to_s }
        doc.css(path.to_s).send(vector, tag)
      end

      def modify_docs_using_nokogiri
        docs.each do |original, html|
          doc = File.open(html) {|f| Nokogiri::HTML(f.read) }
          yield(doc, original)
          File.open(html, 'w') {|f| f.write(doc.to_html) }
        end
      end

      def doc_header(orig_path)
        "FILE:        #{orig_path}\n" +
        "PROJECT:     #{'todo'}\n" +
        "HOMEPAGE:    #{'todo'}\n\n" +
        "INDEX:       #{'list of files..'}\n\n" +
        '-' * 10
      end

      def vimscript
        @vimscript ||= (
          files.map do |path|
            ["sp #{path}", "TOhtml",
              "w! #{docs[path]}"]
          end + [":qall!"]
          ).join("\n")
      end
  end

  def self.run!(*prms)
    Generator.new(*prms).run!
  end
end

Vocco::CSS = <<-EOF
  html {
    font-size: 18px;
  }

EOF


Vocco.run!(*$*)

# system "gvim +TOhtml +'w! #{target_path}' +qa! #{file_path}"




