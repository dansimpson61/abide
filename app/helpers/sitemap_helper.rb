# app/helpers/sitemap_helper.rb
module SitemapHelper
  def all_routes
    routes = []

    # Collect routes from the main Sinatra app
    routes += collect_routes(Sinatra::Application)

    # Ensure mounted apps (like GardenAPI) are included
    routes += collect_routes(GardenAPI, "/api")

    routes.uniq.sort_by { |r| [r[:method], r[:path]] }
  end

  private

  def collect_routes(app_class, mount_point = "")
    return [] unless app_class.respond_to?(:routes)

    app_class.routes.each_with_object([]) do |(method, routes), collected|
      next if method == "HEAD"

      routes.each do |pattern, _, _|
        path = mount_point + convert_pattern(pattern)
        collected << {
          method: method.upcase,
          path: path,
          params: pattern.named_captures.keys
        }
      end
    end
  end

  def convert_pattern(pattern)
    pattern.to_s
      .gsub(/\A\^/, '')        # Remove regex start anchor
      .gsub(/\$\z/, '')        # Remove regex end anchor
      .gsub(/\\/, '')          # Remove escape characters
      .gsub(/\(\?:([^)]+)\)/, '\1') # Remove non-capturing groups
      .gsub(/:(\w+)/, '{\1}')  # Convert :params to {param} style
  end

  def extract_mount_point(middleware)
    return "" unless middleware[1..].any? { |arg| arg.is_a?(Hash) }
    
    opts = middleware[1..].find { |arg| arg.is_a?(Hash) }
    opts[:at] || ""
  end
end
