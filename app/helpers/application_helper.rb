module ApplicationHelper
  # Returns the full title on a per-page basis.
  def full_title(page_title = '')
    base_title = "ProphetRatings"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end
  
  # Sortable column helper.
  def sort_link(column, title = nil, init_direction = 'asc', season = current_year)
    title ||= column.title
    init_direction == "asc" ? opposite_direction = "desc" : opposite_direction = "asc"
    direction = column == sort_column && sort_direction(init_direction) == init_direction ? opposite_direction : init_direction
    icon = sort_direction(init_direction) == "asc" ? "glyphicon glyphicon-chevron-up" : "glyphicon glyphicon-chevron-down"
    icon = column == sort_column ? icon : ""
    puts init_direction
    link_to "#{title} <span class='#{icon}'></span>".html_safe, {column: column, direction: direction, season: season}
  end
end
