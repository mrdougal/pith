require "ostruct"
require "pathname"
require "pith/reference_error"
require "set"
require "tilt"

module Pith
  
  class RenderContext
    
    include Tilt::CompileSite
    
    def initialize(project)
      @project = project
      @input_stack = []
      @dependencies = project.config_files.dup
      self.extend(project.helper_module)
    end

    attr_reader :project
    
    def page
      @input_stack.first
    end

    def current_input
      @input_stack.last
    end
    
    def render(input, locals = {}, &block)
      with_input(input) do
        result = input.render(self, locals, &block)
        layout_ref = current_input.meta["layout"]
        result = render_ref(layout_ref) { result } if layout_ref
        result
      end
    end

    attr_reader :dependencies
    
    def include(template_ref, locals = {}, &block)
      content_block = if block_given?
        content = capture_haml(&block)
        proc { content }
      end
      render_ref(template_ref, locals, &content_block)
    end
    
    alias :inside :include
    
    def content_for
      @content_for_hash ||= Hash.new { "" }
    end
    
    def relative_url_to(target_path)
      url = target_path.relative_path_from(page.path.parent)
      url = url.sub(/index\.html$/, "") if project.assume_directory_index
      url = url.sub(/\.html$/, "") if project.assume_content_negotiation
      url
    end
    
    def href(target_ref)
      relative_url_to(resolve_reference(target_ref))
    end

    def link(target_ref, label = nil)
      target_path = resolve_reference(target_ref)
      label ||= begin 
        input(target_path).title
      rescue ReferenceError
        "???" 
      end
      url = relative_url_to(target_path)
      %{<a href="#{url}">#{label}</a>}
    end
    
    private

    def resolve_reference(ref)
      if ref.respond_to?(:output_path)
        ref.output_path
      else
        current_input.resolve_path(ref)
      end
    end
    
    def input(path)
      input = project.input(path)
      raise(ReferenceError, %{Can't find "#{path}"}) if input.nil?
      @dependencies << input.file
      input
    end
    
    def with_input(input)
      @dependencies << input.file
      @input_stack.push(input)
      begin
        yield
      ensure
        @input_stack.pop
      end
    end
    
    def render_ref(template_ref, locals = {}, &block)
      template_input = input(resolve_reference(template_ref))
      render(template_input, locals, &block)
    end

  end
  
end
