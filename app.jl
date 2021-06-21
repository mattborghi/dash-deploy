using Dash, DashHtmlComponents, DashCoreComponents;
## Clean exit on CRTL+C
Base.exit_on_sigint(false)

PORT = 1234
if !("PORT" in keys(ENV))
    println("PORT not set. Setting to default ", PORT)
    ENV["PORT"] = PORT
end

app = dash();

app.layout = html_div() do
    dcc_dropdown(
        id="dropdown",
        options=[
            Dict("label" => "Los Angeles", "value" => "LA"),
            Dict("label" => "New York City", "value" => "NYC"),
            Dict("label" => "Montreal", "value" => "MTL")                
        ],
        value="LA"),
    html_div(id="display-value"),
    dcc_graph(
            id="example-graph",
            figure=(
                data = [
                    (x = [1, 2, 3], y = [4, 1, 2], type = "bar", name = "SF"),
                    (x = [1, 2, 3], y = [2, 4, 5], type = "bar", name = "Montréal"),
                ],
                layout = (title = "Dash Data Visualization",)
            )
        )
end;

callback!(app,
    Output("display-value", "children"),
    Input("dropdown", "value")) do value 
    "You've entered $(value)"
end;

# the default Dash port is 8050, but for Heroku deployments, it's
# important to ensure the server port matches the PORT environment
# variable; when running the app on your own machine, omit this
# unless PORT is set.
port = parse(Int64, ENV["PORT"]);

run_server(app, "0.0.0.0", port)