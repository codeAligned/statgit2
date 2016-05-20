require "action_view"

module ReportHelper
  include ActionView::Helpers::UrlHelper

  def commit_link(commit)
    link_to(commit.commit_hash, "#")
  end

  def date(date)
    iso_date(date)
  end

  def iso_date(date)
    date.strftime("%Y-%m-%d")
  end

  def wrap_array(data)
    if data.is_a?(Array)
      data
    else
      [data]
    end
  end

  def line_chart(repository, method, title, options = {})
    data = repository.send(method).map do |key, value|
      [key, wrap_array(value)]
    end

    data = Hash[data]

    labels = wrap_array(title)

    options = options.merge({
      width: 600,
      height: 400,
    })

    arguments = template_arguments.merge(options).merge({
      data: data,
      labels: labels,
      title: title,
      method: method,
    })

    render_template(shared_template("line_chart"), arguments)
  end

  def render_template(template, template_arguments)
    engine = Haml::Engine.new(File.read(template))
    engine.render self, template_arguments do
      yield
    end
  end

  def shared_template(key)
    File.dirname(__FILE__) + "/../templates/shared/#{key}.html.haml"
  end
end
