module ApplicationHelper
  def band_set_photos_element_view_for(element, options = {})
    view_helper = Alchemy::ElementsBlockHelper::ElementViewHelper.new(
      self, element: element
    ) if block_given?

    width = view_helper.render(:width)

    classes = [element.name]
    classes.push("--#{width}")
    classes.push("--gallery") if element.nested_elements.count > 1

    options = {
      tag: :div,
      id: element_dom_id(element),
      class: classes.join(' '),
      tags_formatter: ->(tags) { tags.join(" ") }
    }.merge(options)

    # capture inner template block
    output = capture do
      yield view_helper if block_given?
    end

    # wrap output in a useful DOM element
    if tag = options.delete(:tag)    # add preview attributes

      options.merge!(element_preview_code_attributes(element))

      # add tags
      if tags_formatter = options.delete(:tags_formatter)
        options.merge!(element_tags_attributes(element, formatter: tags_formatter))
      end

      output = content_tag(tag, output, options)
    end

    # that's it!
    output
  end
end
