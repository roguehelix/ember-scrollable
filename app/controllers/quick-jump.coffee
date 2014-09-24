`import Ember from 'ember';`
`import PromiseController from './promise'`

QuickJumpController = Ember.Controller.extend
  query: null
  results: null
  requestPromise: null

  resultsSections: (->
    _(@get('results')).chain().groupBy('_type').map((results, type) ->
      title: type.capitalize().pluralize()

      results: results.map (result) ->
        _(result._source).extend(type: type)
    ).value()
  ).property('results')

  queryDidChange: (->
    Ember.run.debounce(this, 'search', 250)
  ).observes('query')

  search: ->
    query = @get('query')

    if query && query.length > 2
      @set('requestPromise', PromiseController.create(
        promise:
          $.getJSON('/swordfish/quick_jumps.json', q: query).then (response) =>
            @set('results', response.hits.hits)
      ))
    else
      @set('results', null)

  actions:
    clear: ->
      @set('query', null)

`export default QuickJumpController;`
