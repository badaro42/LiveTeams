# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

#source = new EventSource('/geo_entities/stream')

#se no controlador temos assim:
#sse.write({name: 'Test'}, event: "event_name")
#deve ser usado este pedaço de codigo
#source.addEventListener("event_name", (event) ->
#  console.log event.data
#)

#se por outro lado a instrução no controlador for esta:
#sse.write(data)
#deve ser usado o seguindo pedaço
#source.onmessage = (event) ->
#  $('#geo_entities').prepend($.parseHTML(event.data))
#  geo_entity_template = _.template($('#geo_entity_temp').html())
#  geo_entity = $.parseJSON(event.data)
#  if geo_entity
#    $('#geo_entities').prepend(geo_entity_template( {
#      body: geo_entity['body']
#      user_name: geo_entity['user_name']
#      user_avatar: geo_entity['user_avatar']
#      user_profile: geo_entity['user_profile']
#      timestamp: geo_entity['timestamp']
#    } ))

#jQuery ->
#  $('#new_comment').submit ->
#    $(this).find("input[type='submit']").val('Sending...').prop('disabled', true)