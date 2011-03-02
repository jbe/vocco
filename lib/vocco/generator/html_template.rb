Vocco::Generator::HTML_TEMPLATE = <<-'__YOU_ARE_SPECIAL__'
_buf = [] ; _temple_pre_tags = /<pre|<textarea/ ; _buf << ("<div class=\"nav\"><div class=\"wrapper\"><div class=\"area\"><p><strong>") ; 
 ; 
 ; 
 ; 
 ; 
 ; if site ; 
 ; _buf << ("<a href=\"#{site}\">#{name}"\
"</a>") ; else ; 
 ; _buf << (name) ; 
 ; end ; _buf << ("</strong><span>#{' : '}"\
"</span><span>#{src_path}"\
""\
"</span></p></div>") ; if index.size > 1 ; 
 ; _buf << ("<div class=\"area\"><p>") ; 
 ; 
 ; index.each do |src, doc| ; 
 ; _buf << ("#{File.dirname(src) == '.' ? '' : File.dirname(src) + '/'}"\
"<a href=\"./#{doc}\">#{File.basename(src)}"\
"</a><br>"\
""\
"") ; end ; _buf << ("</p></div>") ; end ; _buf << ("<div class=\"notes area\"><p>These are the <strong>notes</strong></p><p>These are the <strong>notes</strong></p><p>These are the <strong>notes</strong></p><p>These are the <strong>notes</strong></p><p>These are the <strong>notes</strong></p><p>These are the <strong>notes</strong></p><p>These are the <strong>notes</strong></p><p>These are the <strong>notes</strong></p><p>These are the <strong>notes</strong></p><p>These are the <strong>notes</strong></p><p>These are the <strong>notes</strong></p><p>These are the <strong>notes</strong></p><p>These are the <strong>notes</strong></p><p>These are the <strong>notes</strong></p><p>These are the <strong>notes</strong></p><p>These are the <strong>notes</strong></p><p>These are the <strong>notes</strong></p><p>These are the <strong>notes</strong></p><p>These are the <strong>notes</strong></p><p>These are the <strong>notes</strong></p><p>These are the <strong>notes</strong></p><p>These are the <strong>notes</strong></p><p>These are the <strong>notes</strong></p><p>These are the <strong>notes</strong></p><p>These are the <strong>notes</strong></p><p>These are the <strong>notes</strong></p><p>These are the <strong>notes</strong></p><p>These are the <strong>notes</strong></p><p>These are the <strong>notes</strong></p><p>These are the <strong>notes</strong></p><p>These are the <strong>notes</strong></p><p>These are the <strong>notes</strong></p><p>These are the <strong>notes</strong></p><p>These are the <strong>notes</strong></p><p>These are the <strong>notes</strong></p><p>These are the <strong>notes</strong></p><p>These are the <strong>notes</strong></p><p>These are the <strong>notes</strong></p><p>These are the <strong>notes</strong></p><p>These are the <strong>notes</strong></p><p>These are the <strong>notes</strong></p><p>These are the <strong>notes</strong></p><p>These are the <strong>notes</strong></p><p>These are the <strong>notes</strong></p><p>These are the <strong>notes</strong></p></div><div class=\"area\"><table><tr><th>Generated:</th><td>"\
""\
""\
""\
""\
""\
""\
""\
""\
""\
""\
""\
""\
""\
""\
""\
""\
""\
""\
""\
""\
""\
""\
""\
""\
""\
""\
""\
""\
""\
""\
""\
""\
""\
""\
""\
""\
""\
""\
""\
""\
""\
""\
""\
""\
""\
""\
""\
""\
""\
""\
"#{Time.now.to_s}"\
"</td></tr></table></div></div></div>") ; _buf = _buf.join
__YOU_ARE_SPECIAL__
