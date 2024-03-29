defmodule Task3Web.TaskController do
  use Task3Web, :controller

  alias Task3.Tasks
  alias Task3.Tasks.Task
  alias Task3.Users

  action_fallback Task3Web.FallbackController

  plug Task3.Plugs.RequireAuth

  def index(conn, _params) do
    task = Tasks.list_task()
    render(conn, "index.json", task: task)
  end

  def create(conn, %{"task" => task_params}) do

    with {:ok, %Task{} = task} <- Tasks.create_task(task_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.task_path(conn, :show, task))
      |> render("show.json", task: task)
    end
  end

  def show(conn, %{"id" => id}) do
    task = Tasks.get_task(id)
    render(conn, "show.json", task: task)
  end

  def update(conn, %{"id" => id, "task" => task_params}) do
    task = Tasks.get_task!(id)

    with {:ok, %Task{} = task} <- Tasks.update_task(task, task_params) do
      render(conn, "show.json", task: task)
    end
  end

  def delete(conn, %{"id" => id}) do
    task = Tasks.get_task!(id)

    with {:ok, %Task{}} <- Tasks.delete_task(task) do
      send_resp(conn, :no_content, "")
    end
  end
end
