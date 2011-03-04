Vocco::Generator::SourceFile::HTML_TEMPLATE = <<-'__YOU_ARE_SPECIAL__'
_buf = [] ; _temple_pre_tags = /<pre|<textarea/ ; _buf << ("<div class=\"nav\"><div class=\"wrapper\"><div class=\"area\"><h3><strong>") ; 
 ; 
 ; 
 ; 
 ; 
 ; if @gen.site ; 
 ; _buf << ("<a href=\"#{@gen.site}\">#{@gen.name}"\
"</a>") ; else ; 
 ; _buf << (@gen.name) ; 
 ; end ; _buf << ("</strong><span>#{' : '}"\
"</span><span>#{basename}"\
""\
"</span></h3>") ; if @gen.files.size > 1 ; 
 ; _buf << ("<p class=\"autohide\">") ; 
 ; @gen.files.each do |file| ; 
 ; _buf << ("#{file.short_dirname == '.' ? '' : file.short_dirname + '/'}"\
"<a href=\"#{file.doc_link}\">#{file.basename}"\
"</a><br>"\
""\
"") ; end ; _buf << ("</p>") ; end ; _buf << ("</div>") ; if notes.any? ; 
 ; _buf << ("<div class=\"notes area\">") ; 
 ; notes.each do |note| ; 
 ; _buf << (note) ; 
 ; 
 ; end ; _buf << ("</div>") ; end ; _buf << ("<div class=\"area\"><table><tr><th>Generated:</th><td>"\
""\
""\
""\
"#{Time.now.to_s}"\
"</td></tr></table></div></div></div>") ; _buf = _buf.join
__YOU_ARE_SPECIAL__
