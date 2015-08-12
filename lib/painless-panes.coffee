{CompositeDisposable} = require 'atom'
$ = require 'jquery'

module.exports = PainlessPanes =
  subscriptions: null

  config:
    enabled:
      title: 'Enabled'
      type: 'boolean'
      default: true

  activate: (state) ->
    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'painless-panes:toggle': => @toggle()

    if atom.config.get 'painless-panes.enabled'
      @toggle()

  deactivate: ->
    @subscriptions.dispose()

  toggle: ->
    if @observer
      atom.config.set 'painless-panes.enabled', false
      $('atom-workspace').removeClass('painless-panes__enabled')
      @observer.dispose()
      @observer = null
      return

    atom.config.set 'painless-panes.enabled', true
    $('atom-workspace').addClass('painless-panes__enabled')

    @observer = atom.workspace.observeActivePane (item) ->
      view = atom.views.getView(item)

      $('.painless-panes__active').removeClass('painless-panes__active')
      $(view)
        .addClass('painless-panes__active')
        .parents('atom-pane-axis')
        .addClass('painless-panes__active')
