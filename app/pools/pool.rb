# frozen_string_literal: true

# Class of pools which manage tagged objects
class Pool
  # Initializes instance
  def initialize
    @objs_index = {}
    @tags_index = {}
  end

  private

  # Empty associative array
  NONE = {}.freeze

  # Associative array of pool elements index
  # @return [Hash{Object => Hash}]
  #   associative array of pool elements index
  attr_reader :objs_index

  # Associative array of tags index
  # @return [Hash{Object => Hash{Object => Array}}]
  #   associative array of tags index
  attr_reader :tags_index

  # Adds object and tags to pool elements index
  # @param [Object] obj
  #   object
  # @param [Hash] tags
  #   associative array of tags
  def add_obj(obj, tags)
    tags.each { |name, value| add_tag(name, value, obj) }
    current = objs_index[obj] || NONE
    objs_index[obj] = current.merge(tags).freeze
  end

  # Removes object and tags from pool elements index
  # @param [Object] obj
  #   object
  def remove_obj(obj)
    tags = objs_index.delete(obj) || return
    tags.each { |name, value| remove_tag(name, value, obj) }
  end

  # Adds tag and object to tags index
  # @param [Object] name
  #   tag name
  # @param [Object] value
  #   tag value
  # @param [Object] obj
  #   object
  def add_tag(name, value, obj)
    values = tags_index[name] ||= {}
    objs = values[value] ||= []
    objs << obj unless objs.include?(obj)
  end

  # Removes tag and object from tags index
  # @param [Object] name
  #   tag name
  # @param [Object] value
  #   tag value
  # @param [Object] obj
  #   object
  def remove_tag(name, value, obj)
    values = tags_index[name] || return
    objs = values[value] || return
    objs.delete(obj)
    values.delete(value) if objs.empty?
    tags_index.delete(name) if values.empty?
  end
end
