require 'rubygems'
require 'hpricot'
require 'open-uri'

RESULT_FILE = File.new( "./results.txt", 'w+' )

def extract_words( element )
  ( element.inner_text || '' ).gsub( /[^(a-zA-Z )]/, ' ' ).split( " " )
end

def print_tally( count )
  sorted = count.sort{ |a, b| b[1] <=> a[1] }[0..20]
  sum = count.inject( 0 ){ |n, m| n + m[1] }
  RESULT_FILE.puts sorted.collect{ |s| s[0] } * "\t"
  RESULT_FILE.puts sorted.collect{ |s| ( s[1].to_f / sum ) } * "\t"
  RESULT_FILE.puts "total: #{ sum }"
  RESULT_FILE.puts ""
end

def print_words( words_of_interest )
  RESULT_FILE.puts "words\t" + ( words_of_interest * "\t" ) + "\t" + words_of_interest.length.to_s
end

def print_tally_for( whom, count, words_of_interest )
  sorted = words_of_interest.collect{ |word| [ word, ( count[word] || 0 ) ] }
  sum = count.inject( 0 ){ |n, m| n + m[1] }
  RESULT_FILE.puts whom + "\t" + ( sorted.collect{ |s| ( s[1].to_f / sum ) } * "\t" ) + "\t" + sum.to_s
end

count = {}
# Retrieve a sample of Gile Bowkett
doc = Hpricot( open( "http://gilesbowkett.blogspot.com/" ) )
(doc/"ul.posts/li/a").each do |anchor|
  blog_post = Hpricot( open( anchor.attributes['href'] ) )
  words = extract_words(blog_post/"div.post-body")
  words.each{ |w| count[w] = 1 + ( count.has_key?( w ) ?  count[w] : 0 ) if ( w.length > 0 ) }
end

# This gives us the following baseline words:
# words_of_interest = %w( the and to of a in I s it is that you with for on as t are people have all )
words_of_interest = count.sort{ |a, b| b[1] <=> a[1] }[0..20].collect{ |w| w[0] }
print_words( words_of_interest )

print_tally_for( "Giles Bowkett '08", count, words_of_interest )


count = {}
# Retrieve a Gile Bowkett '07
(1..12).each do |i|
  doc = Hpricot( open( "http://gilesbowkett.blogspot.com/2007_#{ sprintf( '%02d', i ) }_01_archive.html" ) )
  (doc/"div.post-body").each do |blog_post|
    words = extract_words blog_post
    words.each{ |w| count[w] = 1 + ( count.has_key?( w ) ?  count[w] : 0 ) if ( w.length > 0 ) }
  end
end
print_tally_for( "Giles Bowkett '07", count, words_of_interest )

count = {}
# Retrieve a Gile Bowkett '06
(11..12).each do |i|
  doc = Hpricot( open( "http://gilesbowkett.blogspot.com/2006_#{ sprintf( '%02d', i ) }_01_archive.html" ) )
  (doc/"div.post-body").each do |blog_post|
    words = extract_words blog_post
    words.each{ |w| count[w] = 1 + ( count.has_key?( w ) ?  count[w] : 0 ) if ( w.length > 0 ) }
  end
end
print_tally_for( "Giles Bowkett '06", count, words_of_interest )

count = {}
# Retrieve a Zed Shaw
doc = Hpricot( open( "http://www.zedshaw.com/blog/" ) )
(doc/"div#contentcolumnRight/p").each do |p|
  words = extract_words p
  words.each{ |w| count[w] = 1 + ( count.has_key?( w ) ?  count[w] : 0 ) if ( w.length > 0 ) }
end
(doc/"div#contentcolumnRight/div.webgen-menu-vert/ul/li/a").each do |anchor|
  blog_post = Hpricot( open( "http://www.zedshaw.com/blog/" + anchor.attributes['href'] ) )
  (blog_post/"div#contentcolumnRight/p").each do |p|
    words = extract_words p
    words.each{ |w| count[w] = 1 + ( count.has_key?( w ) ?  count[w] : 0 ) if ( w.length > 0 ) }
  end
end
print_tally_for( "Zed Shaw", count, words_of_interest )

count = {}
# Retrieve a DHH (smaller sample set)
doc = Hpricot( open( "http://www.loudthinking.com/posts/archives" ) )
(doc/"div.entry/p/a").each do |anchor|
  blog_post = Hpricot( open( "http://www.loudthinking.com" + anchor.attributes['href'] ) )
  (blog_post/"div.entry/p").each do |p|
    words = extract_words p
    words.each{ |w| count[w] = 1 + ( count.has_key?( w ) ?  count[w] : 0 ) if ( w.length > 0 ) }
  end
end
print_tally_for( "DHH", count, words_of_interest )

count = {}
# Retrieve an Amy Hoy
doc = Hpricot( open( "http://www.slash7.com/articles" ) )
(doc/"div.article/h3/a").each do |anchor|
  blog_post = Hpricot( open( "http://www.slash7.com" + anchor.attributes['href'] ) )
  (blog_post/"div.body/p").each do |p|
    words = extract_words p
    words.each{ |w| count[w] = 1 + ( count.has_key?( w ) ?  count[w] : 0 ) if ( w.length > 0 ) }
  end
end
print_tally_for( "Amy Hoy", count, words_of_interest )

count = {}
# Retrieve an Obie Fernandez
doc = Hpricot( open( "http://blog.obiefernandez.com/" ) )
(doc/"div.module-archives/div/ul/li/a").each do |anchor|
  archive_month = Hpricot( open( anchor.attributes['href'] ) )
  (archive_month/"div.entry-body/p").each do |p|
    words = extract_words p
    words.each{ |w| count[w] = 1 + ( count.has_key?( w ) ?  count[w] : 0 ) if ( w.length > 0 ) }
  end
end
print_tally_for( "Obie Fernandez", count, words_of_interest )

