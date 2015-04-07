#!/usr/bin/ruby

# @author Wil Wade <wil@wilwade.com>
# With some help from: 
# http://causes.github.io/blog/2013/06/06/showing-color-chips-from-sass-variables/

# @todo Parse entire tree
# @todo Parse out versions of the colors as well

require 'optparse'
require 'Sass'

options = {:file => nil}

parser = OptionParser.new do|opts|
	opts.banner = "Usage: colors.rb [options]"
	opts.on('-f', '--file file path', 'File') do |file|
		options[:file] = file;
	end
	opts.on('-h', '--help', 'Displays Help') do
		puts opts
		exit
	end
end

parser.parse!

if options[:file] == nil
	print 'Must have a file ( -f)'
    exit(1)
end

class SassVariableEvaluator < Sass::Tree::Visitors::Base
  def visit_comment(node)
    # prevents empty arrays from being in the returned array
  end

  def visit_variable(node)
    @environment ||= Sass::Environment.new
    @environment.set_local_var(node.name, node.expr)
    if (node.is_a? Sass::Tree::VariableNode) && (node.expr.perform(@environment).is_a? Sass::Script::Value::Color)
      [node.name, node.expr.perform(@environment).representation]
    end
  end
end

engine = Sass::Engine.for_file(options[:file], syntax: :scss)
colors = SassVariableEvaluator.visit(engine.to_tree).compact

print '<!DOCTYPE html>
<html><head><title>Sass-Swatch-Colors</title></head><body><style type="text/css">
.pantone {
  border: 1px solid #eee;
  float: left;
  margin: 0 1em 1em 0;
  width: 145px;
}

.chip {
  background: #f00;
  height: 145px;
}
</style>'
print '<div class="clearfix">'
colors.each do |name, value|
    if value.is_a? String
      print '<div class="pantone"><div class="chip" style="background-color: ' + value + ';"></div>'
      print name
      print '<br />'
      print value
      print '</div>'
    end
end
print '</div></body></html>'