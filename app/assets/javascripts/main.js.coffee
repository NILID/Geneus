$ ->
  $('.select2-token').select2
    multiple: true
    tags: true
    maximumSelectionLength: 5
    minimumInputLength: 2
    theme: "bootstrap"
    dropdownAutoWidth: true
    allowClear: true
    ajax:
      url: $(".select2-token").data("url")
      dataType: "json"
    createTag: (params) ->
      term = $.trim(params.term)
      if term == ''
        return null
      {
        id: "<<<" + term + ">>>"
        text: term
        newTag: true
      }

