# frozen_string_literal: true

  class DictionaryDocumentComponent < Blacklight::DocumentComponent

    def document_header
      # header
      @index_fields = helpers.blacklight_config.index_fields
      content_tag(:thead) do
        content_tag(:tr) do
          @index_fields.collect do |field|
            content_tag(:th, field[0])
          end.join.html_safe
        end.html_safe
      end.html_safe
    end

    def document_metadata
      # rest of data
      @index_fields = helpers.blacklight_config.index_fields
      #logger.debug { "config: #{@blacklight_config.index_fields.inspect}" }
      #logger.debug { "document: #{@document.inspect}" }
      #logger.debug { "config: #{@index_fields.inspect}" }

      content_tag(:tr) do
        @index_fields.collect do |field|
          content_tag(:td, @document[field[0]])
        end.join.html_safe
      end.html_safe
    end
  end
