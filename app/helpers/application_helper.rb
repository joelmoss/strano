module ApplicationHelper

  # Set the page title.
  #
  # page_title                      - The page title as a String.
  # show_title                      - A Boolean of whether to show the title
  #                                   within the page (default: true).
  # ignore_subtitle_in_breadcrumbs  - If true, will not use the subtitle in the
  #                                   breadcrumbs.
  def title(page_title, show_title = true)
    @show_title = show_title
    @title_for_content = page_title.to_s
  end

  def show_title?
    @show_title
  end

  # Set the page sub-title.
  #
  # page_title            - The page title as a String.
  # show_title            - A Boolean of whether to show the title within the
  #                         page (default: true).
  # ignore_in_breadcrumbs - If true, will not use the subtitle in the breadcrumbs.
  def subtitle(page_subtitle, show_subtitle = true, ignore_in_breadcrumbs = false)
    @show_subtitle = show_subtitle
    @ignore_subtitle_in_breadcrumbs = ignore_in_breadcrumbs
    @subtitle_for_content = page_subtitle.to_s
  end

  def show_subtitle?
    @show_subtitle
  end

  def breadcrumb(text, link = nil)
    @breadcrumbs = [] if @breadcrumbs.nil?
    @breadcrumbs << [ text, link ]
  end

  def render_breadcrumbs
    crumbs = (@breadcrumbs || [])
    if !@ignore_subtitle_in_breadcrumbs && show_subtitle?
      crumbs = crumbs << [@subtitle_for_content, nil]
    elsif show_title?
      crumbs = crumbs << [@title_for_content, nil]
    end
    render :partial => "layouts/breadcrumbs", :object => [[ "home", root_path ]] + crumbs
  end

  def deploy_now_button
    if resource.cloned? && resource.repo.exists? && resource.capified? && task = resource.cap.find_task(:deploy)
      link_to 'DEPLOY NOW...', new_project_jobs_path(resource, task.fully_qualified_name), :class => "btn btn-success", :data => { :toggle => "button" }
    end
  rescue Strano::ProjectCapError => e
    @project_cap_error = e.message
    nil
  end
end
