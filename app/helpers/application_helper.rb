module ApplicationHelper
    
    def title   
        base_title = "DaQwest" 
        if @title.nil?
            base_title
        else
            "#{base_title} | #{@title}" 
        end
    end
    
    def invite(user_name,user_id,quest_id,quest_title,invited_user_email)
      user = User.where("email=?",invited_user_email)[0]
      if user
       user.notifications.create(:content => (user_name+" invited you to join "+quest_title),:sender_id => user_id, :has_read=>false, :url=>"/quests/"+quest_id.to_s())
      else
      end
       UserMailer.invite_mail(quest_id,user_name,invited_user_email).deliver   
    end
    
    def is_member_of(user_id,quest_id)
      i = Involvement.where("user_id =? AND quest_id =?",user_id,quest_id)
      if i[0].nil?
        return false
      else
       return i[0].id
      end
    end
    
    def recommended_quests(user_id)
      all_q = [26,42]
      q = []       
      all_q.each do |quest_id|
        if Quest.where("id = ?",quest_id)[0]
          i = Involvement.where("user_id =? AND quest_id =?",user_id,quest_id)
          if i[0].nil? 
            q<<quest_id
          end      
        end            
      end
    return q
    end

# def markdown(text)
#  options = [:hard_wrap, :filter_html, :autolink, :no_intraemphasis, :fenced_code, :gh_blockcode]
#   markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new( :hard_wrap => true),
#        :autolink => true, :fenced_code => true, :no_intraemphasis => true,:gh_blockcode=> true,:strikethrough=>true)
#  markdown.render(text).html_safe;
# raw syntax_highlighter(markdown.render(text))
#end

def syntax_highlighter(html)
  doc = Nokogiri::HTML(html)
  doc.search("//pre[@lang]").each do |pre|
    pre.replace Albino.colorize(pre.text.rstrip, pre[:lang])
  end
  doc.to_s
end
def wiki_content(a)
    
 if a
    
    require 'rubygems'
  require 'wikicloth'
    require 'media_wiki'
    require 'nokogiri'
    require 'open-uri'
    
    mw = MediaWiki::Gateway.new('http://en.wikipedia.org/w/api.php/')
    @catch = false
    begin
    wiki = mw.render(a.to_s.titleize)
  
    rescue MediaWiki::APIError => e
    begin
  wiki =  mw.render(a)
    rescue MediaWiki::APIError => e
    @catch = true
    end
    end
    
    @doc = Nokogiri::HTML(wiki)

    disam = @doc.css('p').text.split(' ').include? 'refer'
# testing if there is a case of REDIRECT    
#    redirect = @doc.css('li').children.text.split(' ')
#    redirect = redirect[0]
#    if redirect == 'REDIRECT'
# print "This is redirect case"
#    @name = a
#    a = a.to_s.gsub ' ', '_'
#    @docR = Nokogiri::HTML(open("http://en.wikipedia.org/wiki/"+a))
#    x = @docR.css("table.metadata.mbox-small.plainlinks")
#    x.remove
#    y = @docR.css("table#disambigbox")
#    y.remove
#    @content = @docR.css('div.mw-content-ltr')

# testing if there is a case of REDIRECT   
    
    if disam
  print "This is disambiguation case"
    @name = a
    a = a.to_s.gsub ' ', '_'
    @docdis = Nokogiri::HTML(open("http://en.wikipedia.org/wiki/"+a))
    y = @docdis.css("table#disambigbox")
    y.remove
    @content = @docdis.css('div.mw-content-ltr')

    else
    
    redirect = @doc.css('li').children.text.split(' ')
    redirect = redirect[0]
    if redirect == 'REDIRECT'
  print "This is redirect case"
    a = a.to_s.gsub ' ', '_'
    @doc = Nokogiri::HTML(open("http://en.wikipedia.org/wiki/"+a))
  end
  
    x = @doc.css("span.editsection")
    x.remove
    x = @doc.css("span.mw-editsection")
  x.remove
    @txtful = [] 
    j = 0
   
    while @doc.xpath("//h2/span")[j+1]!=nil
    @txt = [] 
    @node = @doc.xpath("//h2/span")[j].parent
    @stop = @doc.xpath("//h2/span")[j+1].parent
    while @node!=@stop
      @txt << @node
      @node = @node.next 
    end
    @txtful << @txt
    j = j + 1
    end
    print @txtful.length
    
    note = @doc.search("sup")
    note.remove

begin #handling no image exceptions 
    introimage = @doc.css('table.infobox a.image')[0]['href']
    @introimage = introimage 
rescue
  @introimage = "nothing_here"
end  
    note = @doc.css("table.infobox a.image")
    note.remove
    
    name = a
begin    #handling no table exceptions
    note = @doc.at_css("table.infobox tr")
    note.remove
rescue 
end   
    image = @doc.css('table.infobox')[0]

    if image == nil
      image = @doc.css('a.image')[0]  
    end
begin
    info = @doc.xpath('//p')[0]
rescue
info = "sorry no data found"
end
    return @content if defined?(@content)
    @image = image
    @info = info
    @name = name
    if @introimage !="nothing_here"
    @stringurl = "http://en.wikipedia.org" + @introimage
    else 
      @stringurl = "nothing_here"
    end 
    if @stringurl !="nothing_here"
    @doc1 = Nokogiri::HTML(open(@stringurl))
    introimage = @doc1.css('div.fullImageLink > a')[0]['href']
    @introimage = introimage
    end
    if @introimage !="nothing_here"
    @introimage = "http:" + @introimage
    end 
end
    end
  end
def so_content(a)
   
   require 'pilha'
   StackExchange::StackOverflow::Client.config do |options|
      options.api_key = 'Sd9owvzqRd)VnsNfrCAJwA(('
   end   
   a = a.to_s
   a = a.split("stackoverflow.com/questions/")
   a = a[1].to_i
    
   @doc = StackExchange::StackOverflow::Question.find a, :query => {:body => true , :answers => true} 
# something like below can be done if we can get a nokogiri instance of this @doc
#    @doc.xpath('//a[@href]').each do |l|
#  l.attributes["target"].value = "_blank"
#  end
   @ques = @doc.title
   @desc = @doc.body 
   j=0
   @answers = []
   while j < @doc.answers.length
      @ans = @doc.answers[j]["body"]
      @answers << @ans
      j = j + 1   
   end
end

def scilab_help(a)
   require "nokogiri"
   require "open-uri"
   
   @doc = Nokogiri::HTML(open("http://help.scilab.org/docs/5.4.0/en_US/"+ a + ".html"))

   @title = @doc.css("div.refnamediv")
   @callseq = @doc.css("div.refsynopsisdiv")
   @refsec = @doc.css("div.refsection")
  @refsec.xpath('//a[@href]').each do |l|
  l.attributes["href"].value = "/scilab/"+l.attributes["href"].value
  end
end
 def bugzilla_help(a)
   require "nokogiri"
   require "open-uri"
   
   @doc = Nokogiri::HTML(open(a))
   
   @ques = @doc.css("td.field_label")[1].parent.child.next.next.text
   @desc = @doc.css("pre")[0]
   j = 0
   @answers = @doc.css("pre.bz_comment_text")
   
end
def link_to_add_fields(name, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", f: builder)
    end
    link_to(name, '#', class: "add_fields", data: {id: id, fields: fields.gsub("\n", "")})
  end 
end
def scilab_extract_it(url)
  require 'rubygems'
    require 'nokogiri'
    require 'open-uri'
@name = ["Niels Peter Fenger", "Stanislav", "owsigplc", "arctica1963", "Debola Abduljeleel", "grivet", "Samuel GOUGEON", "Pascal Buehler", "Serge Steer", "barbaraflowers", "Rafael Guerra", "oscar.espejo", "Michael J. McCann", "Antoine Monmayrant", "Michael J. McCann-2", "matacosta", "Sylvestre Ledru-4", "shorne", "omorr", "ezequiel soule", "Mathieu Dubois", "Adrien Vogt-Schilb", "cactus_jack", "Denis", "Amsdenyt", "Marria", "lukeaarond", "pepe", "F. Vogel", "F. Vogel-2", "jhdtyp", "Eze-Okoli Ifeoma Sandra", "jasper van baten", "Nima Sahraneshin-Samani", "A Khorshidi", "Janusz Magrian", "rajesh kannan", "Stefan Du Rietz", "stef296", "papriwalprateek", "Jacqueline Howe", "jacquih", "Paul Carrico", "martin.highUp", "simi99", "oiwmw", "Chuox", "Larissa", "Mike Page", "windkraft", "babigeon","Dang_Christophe", "Carrico_Paul"]

  user_id_offset = 648
    @doc = Nokogiri::HTML(open(url))
    @qtitle = @doc.css('h1#post-title').text
    
    # feed qtitle in the database here
    qu = Quest.find(207)
  q = qu.qs.create(:title =>@qtitle)
    @qcontent = @doc.css('div.message-text')
    i = 0
    while i < @qcontent.length
    x = @doc.css('table.classic-author-name')[i].text
    x = x.gsub("\t","")
    x = x.gsub("\n","")
    
    if x.include?("Denis")
      x = "Denis"
    end
    if x.include?("Dang,")
      x = "Dang_Christophe"
    end
    if x.include?("Carrico,")
      x =  "Carrico_Paul"
    end
    if x.include?("Vogel-2")
      x = "F. Vogel-2"
    elsif x.include?("Vogel")
      x = "F. Vogel"
    end
    
    u_id = user_id_offset+@name.index(x)
    qmail = q.qmails.create(:content=>@qcontent[i].inner_html, :user_id =>u_id )
    # feed the above u_id as userid ... u need to manipulate accordingly
    # feed @qcontent[i].inner_html as qmail content
    
    i = i + 1
  end  
   
end