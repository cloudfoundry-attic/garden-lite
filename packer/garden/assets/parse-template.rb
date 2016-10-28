#!/usr/bin/env ruby

require 'erb'
require 'yaml'

manifest = ARGV[0]
template = ARGV[1]

def p(property, default = nil)
  return @manifest[property] || default
end

def if_p(property)
  return false unless @manifest.has_key? property
  yield @manifest[property]
end

@manifest = YAML.load(File.open(manifest))
@template = File.read(template)

renderer = ERB.new(@template)
puts renderer.result()
