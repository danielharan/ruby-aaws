# $Id: setup.rb,v 1.5 2009/06/14 00:28:48 ianmacd Exp $
#

# Attempt to load Ruby/AWS using RubyGems.
#
begin 
  require 'rubygems'
  gem 'ruby-aws'
rescue LoadError
  # Either we don't have RubyGems or we don't have a gem of Ruby/AWS.
end

# Require the essential library, be it via RubyGems or the default way.
#
require 'amazon/aws/search'

include Amazon::AWS
include Amazon::AWS::Search

class AWSTest < Test::Unit::TestCase

  def setup
    @rg = ResponseGroup.new( :Small )
    @req = Request.new
    @req.locale = 'uk'
    @req.cache = false
    @req.encoding = 'utf-8'
  end

  # The default_test method needs to be removed before Ruby 1.9.0.
  #
  undef_method :default_test if method_defined? :default_test
 
end
