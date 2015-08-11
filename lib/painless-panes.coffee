{CompositeDisposable} = require 'atom'
$ = require 'jquery'

module.exports = PainlessPanes =
  subscriptions: null

  activate: (state) ->
    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'painless-panes:toggle': => @toggle()
    # @toggle()

  deactivate: ->
    @subscriptions.dispose()

  toggle: ->
    if @observer
      console.log 'Disabling Painless Panes'
      $('atom-workspace').removeClass('painless-panes__enabled')
      @observer.dispose()
      @observer = null
      return

    console.log 'Enabling Painless Panes'
    $('atom-workspace').addClass('painless-panes__enabled')
    @observer = atom.workspace.observeActivePane (item) ->
      view = atom.views.getView(item)
      $('.painless-panes__active').removeClass('painless-panes__active')
      $(view)
        .addClass('painless-panes__active')
        .parents('atom-pane-axis')
        .addClass('painless-panes__active')
