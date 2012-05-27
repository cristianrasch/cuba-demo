module ViewHelper
  def _render(partial, locals = {}, flash = {})
    body = render(File.expand_path("#{partial}.erb", "views"), locals)
    write render("views/layouts/application.erb", body: body, flash: flash)
  end

private

  def write(html)
    res.write html
  end
end
