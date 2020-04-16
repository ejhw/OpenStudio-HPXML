# frozen_string_literal: true

require 'oga'

class XMLHelper
  # Adds the child element with 'element_name' and sets its value. Returns the
  # child element.
  def self.add_element(parent, element_name, value = nil)
    added = Oga::XML::Element.new(name: element_name)
    parent.children << added
    if not value.nil?
      added.inner_text = value.to_s
    end
    return added
  end

  # Creates a hierarchy of elements under the parent element based on the supplied
  # list of element names. If a given child element already exists, it is reused.
  # Returns the final element.
  def self.create_elements_as_needed(parent, element_names)
    this_parent = parent
    element_names.each do |element_name|
      if XMLHelper.get_element(this_parent, element_name).nil?
        XMLHelper.add_element(this_parent, element_name)
      end
      this_parent = XMLHelper.get_element(this_parent, element_name)
    end
    return this_parent
  end

  # Deletes the child element with element_name. Returns the deleted element.
  def self.delete_element(parent, element_name)
    element = nil
    begin
      last_element = element
      element = parent.at_xpath(element_name).remove
    end while !parent.at_xpath(element_name).nil?
    return last_element
  end

  # Returns the value of 'element_name' in the parent element or nil.
  def self.get_value(parent, element_name)
    val = parent.at_xpath(element_name)
    if val.nil?
      return val
    end

    return val.text
  end

  # Returns the value(s) of 'element_name' in the parent element or [].
  def self.get_values(parent, element_name)
    vals = []
    parent.xpath(element_name).each do |val|
      vals << val.text
    end

    return vals
  end

  # Returns the element in the parent element.
  def self.get_element(parent, element_name)
    return parent.at_xpath(element_name)
  end

  # Returns the element in the parent element.
  def self.get_elements(parent, element_name)
    return parent.xpath(element_name)
  end

  # Returns the name of the first child element of the 'element_name'
  # element on the parent element.
  def self.get_child_name(parent, element_name)
    begin
      # Workaround for bug in oga; see https://gitlab.com/yorickpeterse/oga/-/issues/202
      if parent.at_xpath(element_name).children[0].is_a? Oga::XML::Element
        return parent.at_xpath(element_name).children[0].name
      else
        return parent.at_xpath(element_name).children[1].name
      end
    rescue
    end
    return
  end

  # Returns true if the element exists.
  def self.has_element(parent, element_name)
    element = parent.at_xpath(element_name)
    return !element.nil?
  end

  # Returns the attribute added
  def self.add_attribute(element, attr_name, attr_val)
    attr_val = valid_attr(attr_val).to_s
    added = element.set(attr_name, attr_val)
    return added
  end

  def self.valid_attr(attr)
    attr = attr.to_s
    attr = attr.gsub(' ', '_')
    attr = attr.gsub('|', '_')
    return attr
  end

  # Copies the element if it exists
  def self.copy_element(dest, src, element_name, backup_val = nil)
    return if src.nil?

    element = src.at_xpath(element_name)
    if not element.nil?
      dest << element.dup
    elsif not backup_val.nil?
      # Element didn't exist in src, assign backup value instead
      add_element(dest, element_name.split('/')[-1], backup_val)
    end
  end

  # Copies the multiple elements
  def self.copy_elements(dest, src, element_name)
    return if src.nil?

    if not src.xpath(element_name).nil?
      src.xpath(element_name).each do |el|
        dest << el.dup
      end
    end
  end

  def self.validate(doc, xsd_path, runner = nil)
    if Gem::Specification::find_all_by_name('nokogiri').any?
      require 'nokogiri'
      xsd = Nokogiri::XML::Schema(File.open(xsd_path))
      doc = Nokogiri::XML(doc)
      return xsd.validate(doc)
    else
      if not runner.nil?
        runner.registerWarning('Could not load nokogiri, no HPXML validation performed.')
      end
      return []
    end
  end

  def self.create_doc(version = nil, encoding = nil, standalone = nil)
    doc = Oga::XML::Document.new(xml_declaration: Oga::XML::XmlDeclaration.new(version: version, encoding: encoding, standalone: standalone)) # Oga.parse_xml
    return doc
  end

  def self.parse_file(hpxml_path)
    file_read = File.read(hpxml_path)
    hpxml_doc = Oga.parse_xml(file_read)
    return hpxml_doc
  end

  def self.write_file(doc, out_path)
    # Write XML file
    File.open(out_path, 'w', newline: :crlf) do |f|
      f << doc.to_xml
    end
  end
end

def Boolean(val)
  if val.is_a? TrueClass
    return true
  elsif val.is_a? FalseClass
    return false
  elsif (val.downcase.to_s == 'true') || (val == '1')
    return true
  elsif (val.downcase.to_s == 'false') || (val == '0')
    return false
  end

  raise TypeError.new("can't convert '#{val}' to Boolean")
end
