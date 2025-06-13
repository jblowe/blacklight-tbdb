# frozen_string_literal: true
class CatalogController < ApplicationController

  include Blacklight::Catalog

  configure_blacklight do |config|

    # disable these three document action until we have resources to configure them to work
    config.show.document_actions.delete(:citation)
    config.show.document_actions.delete(:sms)
    config.show.document_actions.delete(:email)

    # config.add_results_document_tool(:bookmark, partial: 'bookmark_control', if: :render_bookmarks_control?)

    config.add_results_collection_tool(:sort_widget)
    config.add_results_collection_tool(:per_page_widget)
    config.add_results_collection_tool(:view_type_group)

    # config.add_show_tools_partial(:bookmark, partial: 'bookmark_control', if: :render_bookmarks_control?)
    # config.add_nav_action(:bookmark, partial: 'blacklight/nav/bookmark', if: :render_bookmarks_control?)
    config.add_nav_action(:search_history, partial: 'blacklight/nav/search_history')

    # solr path which will be added to solr base url before the other solr params.
    config.solr_path = 'select'
    config.document_solr_path = 'select'

    # items to show per page, each number in the array represent another option to choose from.
    config.per_page = [80,160,240,1000]

    config.default_facet_limit = 20

    ## Class for sending and receiving requests from a search index
    # config.repository_class = Blacklight::Solr::Repository
    #
    ## Class for converting Blacklight's url parameters to into request parameters for the search index
    # config.search_builder_class = ::SearchBuilder
    #
    ## Model that maps search index responses to the blacklight response model
    # config.response_model = Blacklight::Solr::Response

    ## Default parameters to send to solr for all search-like requests. See also SearchBuilder#processed_parameters
    #
    # UCB customizations to support existing Solr cores
    config.default_solr_params = {
        'rows': 12,
        'facet.mincount': 1,
        'q.alt': '*:*',
        'defType': 'dismax',
        'df': 'text',
        'q.op': 'AND',
        'q.fl': '*,score'
    }

    # solr path which will be added to solr base url before the other solr params.
    # config.solr_path = 'select'

    ## Default parameters to send on single-document requests to Solr. These settings are the Blackligt defaults (see SearchHelper#solr_doc_params) or
    ## parameters included in the Blacklight-jetty document requestHandler.
    #
    config.default_document_solr_params = {
        qt: 'document',
        #  ## These are hard-coded in the blacklight 'document' requestHandler
        #  # fl: '*',
        #  # rows: 1,
        # this is needed for our Solr services
        q: '{!term f=id v=$id}'
    }

    # Have BL send all facet field names to Solr, which has been the default
    # previously. Simply remove these lines if you'd rather use Solr request
    # handler defaults, or have no facets.
    config.add_facet_fields_to_solr_request!

    # use existing "catchall" field called text
    # config.add_search_field 'text', label: 'Any field'
    config.spell_max = 5

    # SEARCH FIELDS
    config.add_search_field 'text', label: 'Any field'

    [
      ['gloss_txt', 'Gloss'],
      ['form_txt', 'Form'],
      ['analysis_txt', 'Analysis'],
      ['language_txt', 'Language'],
      ['subgroup_txt', 'Subgroup'],
      ['srcabbr_txt', 'Source Abbreviation'],
      ['citation_txt', 'Citation']
      ].each do |search_field|
      config.add_search_field(search_field[0]) do |field|
        field.label = search_field[1]
        #field.solr_parameters = { :'spellcheck.dictionary' => search_field[0] }
        field.solr_parameters = {
          qf: search_field[0],
          pf: search_field[0],
          op: 'AND'
        }
      end
    end

    # Configuration for autocomplete suggestor
    config.autocomplete_enabled = false
    config.autocomplete_path = 'suggest'

    # FACET FIELDS
    config.add_facet_field 'subgroup_s', label: 'Subgroup', limit: true
    config.add_facet_field 'language_s', label: 'Language', limit: true
    # config.add_facet_field 'form_s', label: 'Form', limit: true
    config.add_facet_field 'gloss_s', label: 'Gloss', limit: true
    config.add_facet_field 'gfn_s', label: 'Grammatical function', limit: true
    config.add_facet_field 'semkey_s', label: 'Semantic key', limit: true
    config.add_facet_field 'analysis_s', label: 'Analysis', limit: true
    config.add_facet_field 'groupnode_s', label: 'Group key', limit: true
    # config.add_facet_field 'srcabbr_s', label: 'Source Abbreviation', limit: true
    config.add_facet_field 'citation_s', label: 'Source Citation', limit: true
    # config.add_facet_field 'srcid_s', label: 'Source ID', limit: true

    # INDEX DISPLAY
    config.index.document_component = DictionaryDocumentComponent

    config.add_index_field 'language_s', label: 'language'
    config.add_index_field 'form_s', label: 'form'
    config.add_index_field 'gloss_s', label: 'gloss'
    config.add_index_field 'gfn_s', label: 'gfn'
    config.add_index_field 'groupnode_s', label: 'groupnode'
    config.add_index_field 'subgroup_s', label: 'subgroup'
    # config.add_index_field 'srcabbr_s', label: 'srcabbr'
    config.add_index_field 'citation_s', label: 'citation'
    config.add_index_field 'srcid_s', label: 'srcid'
    config.add_index_field 'semkey_s', label: 'semkey'
    config.add_index_field 'analysis_s', label: 'analysis'

    # SHOW DISPLAY
    config.add_show_field 'subgroup_s', label: 'Subgroup', limit: true
    config.add_show_field 'language_s', label: 'Language', limit: true
    config.add_show_field 'form_s', label: 'Form', limit: true
    config.add_show_field 'gloss_s', label: 'Gloss', limit: true
    config.add_show_field 'gfn_s', label: 'Grammatical function', limit: true
    config.add_show_field 'semkey_s', label: 'Semantic key', limit: true
    config.add_show_field 'analysis_s', label: 'Analysis', limit: true
    config.add_show_field 'groupnode_s', label: 'Group key', limit: true
    config.add_show_field 'srcabbr_s', label: 'Source Abbreviation', limit: true
    config.add_show_field 'citation_s', label: 'Source Citation', limit: true
    config.add_show_field 'srcid_s', label: 'Source ID', limit: true

    # SORT FIELDS

    config.add_sort_field 'groupnode_s asc', label: 'Group'
    config.add_sort_field 'language_s asc', label: 'Language'
    config.add_sort_field 'gloss_s asc', label: 'Gloss'
    config.add_sort_field 'citation_s asc', label: 'Citation'
    config.add_sort_field 'semkey_s asc', label: 'Semantic Key'

  end
end
