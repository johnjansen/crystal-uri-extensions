require "./spec_helper"

describe URI do
  describe "absolutize" do
    it "should set scheme and domain" do
      base = URI.parse("http://mysite.com/index.html")
      new_uri = URI.parse("./some_file.html")
      new_uri.absolutize!(base)

      new_uri.scheme.should eq "http"
      new_uri.host.should eq "mysite.com"
      new_uri.port.should eq nil
      new_uri.path.should eq "/some_file.html"
    end

    it "should set port" do
      base = URI.parse("http://mysite.com:80/")
      new_uri = URI.parse("some_file.html")
      new_uri.absolutize!(base)

      new_uri.port.should eq 80
    end

    describe "join" do
      # a = URI.parse("http://www.mysite.com/l1/l2/index.html")
      # a.join("same.html") # => "http://www.mysite.com/l1/l2/same.html"
      # a.join("./same.html") # => "http://www.mysite.com/l1/l2/same.html"
      # a.join("../higher.html") # => "http://www.mysite.com/l1/higher.html"
      # a.join("../../higher.html") # => "http://www.mysite.com/higher.html"
      # a.join("../../../higher.html") # => "http://www.mysite.com/higher.html"
      # a = URI.parse("http://www.mysite.com/l1/l2/")
      # a.join("child.html") # => "http://www.mysite.com/l1/l2/child.html"
      # a.join("l3/") # => "http://www.mysite.com/l1/l2/l3/"
      # a.join("new_l2/") # => "http://www.mysite.com/l1/new_l2/"
      # WEIRD CASES
      # a = URI.parse("http://www.mysite.com/l1/l2/l3/l4/l5")
      # a.join("../../a/../x/../../higher.html") # => "http://www.mysite.com/l1/l2/higher.html"
      it "should join a file at the same level with single dot" do
        URI.parse("http://www.mysite.com/l1/l2/index.html").ljoin!("./same.html").to_s.should eq "http://www.mysite.com/l1/l2/same.html"
      end

      it "should join a file at the same level with double dot" do
        URI.parse("http://www.mysite.com/l1/l2/index.html").ljoin!("../same.html").to_s.should eq "http://www.mysite.com/l1/same.html"
      end

      it "should join a file at the same level with double double dot" do
        URI.parse("http://www.mysite.com/l1/l2/index.html").ljoin!("../../higher.html").to_s.should eq "http://www.mysite.com/higher.html"
      end

      it "should join a file at the same level with tripple double dot" do
        URI.parse("http://www.mysite.com/l1/l2/index.html").ljoin!("../../../higher.html").to_s.should eq "http://www.mysite.com/higher.html"
      end

      it "should join a file at the same level with no dot" do
        URI.parse("http://www.mysite.com/l1/l2/").ljoin!("child.html").to_s.should eq "http://www.mysite.com/l1/l2/child.html"
      end

      it "should join a directory at the same level with no dot" do
        URI.parse("http://www.mysite.com/l1/l2/").ljoin!("l3").to_s.should eq "http://www.mysite.com/l1/l2/l3"
      end

      it "should join a directory at the same level with double dot" do
        URI.parse("http://www.mysite.com/l1/l2").ljoin!("./new_l2").to_s.should eq "http://www.mysite.com/l1/new_l2"
      end

      it "should join a directory at the same level with empty fragments" do
        URI.parse("http://www.mysite.com/l1/l2").ljoin!(".///new_l2").to_s.should eq "http://www.mysite.com/l1/new_l2"
      end

      it "should join a file at a crazy level" do
        URI.parse("http://www.mysite.com/l1/l2/l3/l4/l5/").ljoin!("../../a/../x/../../higher.html").to_s.should eq "http://www.mysite.com/l1/l2/higher.html"
      end
    end
  end
end
