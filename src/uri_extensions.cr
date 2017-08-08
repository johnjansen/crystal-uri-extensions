require "uri"
require "./uri_extensions/*"

class URI
  def absolutize!(base : URI)
    @scheme = base.scheme if @scheme.nil?
    @host = base.host if @host.nil?
    @port = base.port if @port.nil?
    if path.nil?
      @path = base.path
    else
      @path = join(base.path.to_s, @path.not_nil!)
    end
  end

  def same_domain?(other : URI)
    @host == other.host
  end

  # Returns a new clean path
  # ```
  # a = URI.parse("http://www.mysite.com/l1/l2/index.html")
  # a.join("same.html") # => "http://www.mysite.com/l1/l2/same.html"
  # a.join("./same.html") # => "http://www.mysite.com/l1/l2/same.html"
  # a.join("../higher.html") # => "http://www.mysite.com/l1/higher.html"
  # a.join("../../higher.html") # => "http://www.mysite.com/higher.html"
  # a.join("../../../higher.html") # => "http://www.mysite.com/higher.html"
  # a = URI.parse("http://www.mysite.com/l1/l2/
  # a.join("child.html") # => "http://www.mysite.com/l1/l2/child.html"
  # a.join("l3/") # => "http://www.mysite.com/l1/l2/l3/"
  # a.join("new_l2/") # => "http://www.mysite.com/l1/new_l2/"
  # ```
  def join(this : String, that : String) : String
    parent = (this.not_nil! + '\0').split("/")
    parent.shift
    child = (that.not_nil! + '\0').split("/")
    r = [] of String

    (parent + child + [""]).each_cons(2) do |f|
      f1, f2 = f
      fragment = f1.rchop('\0')
      unless fragment.empty?
        if fragment == ".."
          r.pop if !r.empty? && r[-1][-1] == '\0'
          r.pop unless r.empty?
        elsif fragment == "."
          r.pop if !r.empty? && r[-1][-1] == '\0'
        else
          r << f1 unless fragment.empty?
        end
      end
    end

    r = [""] + r

    r.join("/").rchop('\0')
  end

  def ljoin!(other : String)
    @path = join(@path.not_nil!, other)
    self
  end

  def rjoin!(other : String)
    @path = join(other, @path.not_nil!)
    self
  end
end
