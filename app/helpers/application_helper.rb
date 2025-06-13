module ApplicationHelper

	def format_table_results(docs)
	    fields = blacklight_config.index.fields
		docs.collect do |doc|
			content_tag(:tr, class: 'row') do
			    fields do |field|
				    content_tag(:td) do
					    doc.field
				    end
				end
			end
		end.join.html_safe
	end

end
