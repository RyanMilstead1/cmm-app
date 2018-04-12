document.addEventListener("turbolinks:load", function() {
  var $input = $("[data-behavior='autocomplete']");
  $input.val('');
  var wikiId = $('#collaborator_wiki_id').val()
  var options = {
    getValue: 'username',
    url: function(phrase) {
      return '/collaborators/autocomplete?q=' + phrase + '&wiki_id=' + wikiId;
    }
  }

  $input.easyAutocomplete(options);
});
