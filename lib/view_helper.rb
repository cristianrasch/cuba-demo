module ViewHelper
  def _render(partial, locals = {}, flash = {})
    body = render(File.expand_path("#{partial}.erb", "views"), locals)
    res.write render("views/layouts/application.erb", body: body, flash: flash)
  end
end
