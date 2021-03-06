Code.require_file("spec/phoenix_helper.exs")
Code.require_file("spec/support/controller_setup.ex")
Code.require_file "../../info_sys/test/backends/http_client.exs", __DIR__

ESpec.configure fn(config) ->
  config.before fn(tags) ->
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Rumbl.Repo)
    if controller = tags[:controller] do
      ControllerSetup.setup(controller, tags)
    else
      :ok
    end
  end

  config.finally fn(shared) ->
    if controller = shared[:controller] do
      ControllerSetup.on_exit(controller, shared)
    end
    Ecto.Adapters.SQL.Sandbox.checkin(Rumbl.Repo, [])
  end
end
