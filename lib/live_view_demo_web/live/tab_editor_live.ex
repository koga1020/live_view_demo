defmodule LiveViewDemoWeb.TabEditorLive do
  use Phoenix.LiveView
  import Calendar.Strftime
  alias LiveViewDemoWeb.EditorView

  def render(assigns) do
    EditorView.render("editor.html", assigns)
  end

  def mount(_session, socket) do
    {:ok, socket}
  end
end
