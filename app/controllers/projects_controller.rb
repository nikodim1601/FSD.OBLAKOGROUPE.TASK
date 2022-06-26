class ProjectsController < ApplicationController
  skip_before_action :verify_authenticity_token
  # Отключил проверку CSRF токена для удобства

  def index
    result = []
    all_todos = Todo.all
    Project.find_each do |project|
      todos = all_todos.where(project_id: project.id).order(:text)
      result.append(
        forming_json_project(project.id, project.title, todos)
      )
    end
    render json: result, status: 200
  end

  def update
    begin
      todo = Todo.find(params[:t_id])
    rescue
      render json: create_message("Entity with id #{params[:t_id]} doesn't exist.", nil)
      return
    end

    if todo.update_attribute("isCompleted", params[:isCompleted])
      render json: todo, status: 200
    else
      render json: todo.errors, status: 400
    end
  end

  def create
    if params[:project_id]
      add_task_to_exist_project
    else
      create_new_project
    end
  end

  private def create_message(message, error)
    { "error" => message,
      "error_detail" => error
    }
  end

  private def forming_json_project(id, title, todos)
    {
      "id" => id,
      "title" => title,
      "todos" => todos.as_json
    }
  end

  private def create_new_project
    new_project = Project.new(title: params[:title])
    if new_project.valid?
      new_project.save
    else
      render json: create_message("Project #{params[:title]} wasn't created.", new_project.errors.as_json), status: 400
      return
    end
    create_todo(new_project, true)
  end

  private def add_task_to_exist_project
    begin
      project = Project.find(params[:project_id])
    rescue
      render json: create_message("Project with id #{params[:project_id]} doesn't exist.", nil), status: 400
      return
    end

    create_todo(project)
  end

  private def create_todo(project, is_new_project=false)
    new_todo = Todo.new(text: params[:text], isCompleted: params[:isCompleted], project: project)
    if new_todo.valid?
      new_todo.save
      if is_new_project
        render json: forming_json_project(project.id, project.title, new_todo), status: 201
      else
        todos = Todo.where(project_id: project.id).order(:text)
        render json: forming_json_project(project.id, project.title, todos), status: 201
      end
    else
      render json: create_message("Task #{params[:text]} wasn't created.", new_todo.errors.as_json), status: 400
    end
  end
end
