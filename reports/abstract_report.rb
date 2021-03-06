class AbstractReport
  include ReportHelper

  attr_reader :repository

  def initialize(repository:)
    @repository = repository
  end

  def create_file!(name, selector = nil)
    Dir.mkdir(output_location) unless Dir.exist?(output_location)

    filename = output_location + hyperlink(selector)
    output = render_output(name, selector)
    bytes = File.write filename, output

    LOG.debug "Created #{filename} (#{bytes} bytes)" if LOG.debug?
  end

  def generate!
    create_file! root_path
  end

  def render_output(name, selector = nil)
    render_template(root_template, template_arguments(selector)) do
      render_template(template_for(name, selector), template_arguments(selector))
    end
  end

  def render_shared(template, arguments = {})
    render_template(shared_template(template), arguments)
  end

  def root_path
    title.downcase
  end

  def name
    self.class.name
  end

  def navigation
    AllReports::REPORTS.map { |r| r.new(repository: repository) }.select(&:public?).map do |report|
      [report.root_path + ".html", report.title]
    end
  end

  def public?
    false
  end

  def hyperlink(selector = nil)
    file_for(root_path, selector)
  end

  def file_for(filename, selector = nil)
    if selector
      "#{filename}_#{file_for_selector(selector)}.html"
    else
      "#{filename}.html"
    end
  end

  private

  def output_location
    "output/"
  end

  def template_extension
    ".html.haml"
  end

  def template_for(filename, selector = nil)
    if selector
      File.dirname(__FILE__) + "/../templates/#{simple_class_name}/#{filename}_subreport#{template_extension}"
    else
      File.dirname(__FILE__) + "/../templates/#{simple_class_name}/#{filename}#{template_extension}"
    end
  end

  def root_template
    File.dirname(__FILE__) + "/../templates/layouts/default#{template_extension}"
  end

  def simple_class_name
    self.class.name.underscore
  end

  def template_arguments(selector = nil)
    {
      repository: repository,
      selector: selector,
    }
  end
end
