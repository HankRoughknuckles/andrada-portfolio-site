$ -> #DOM Ready

  miniTileWidth = 50
  miniTileHeight = 50
  miniTileMarginX = 2
  miniTileMarginY = 2
  tileWidth = 138
  tileHeight = 138
  tileMarginX = 5
  tileMarginY = 5
  currentLightbox = null #has the ID of the lightbox whose details are
                         #currently being viewed
  uploadedImage = null

  $(".close, .overlay").click ->
    closeLightbox(currentLightbox)

  
  #Gridster stuff
  dragged = false

  #Turn on gridster
  $(".gridster ul").gridster
    widget_margins: [tileMarginX, tileMarginY]
    widget_base_dimensions: [tileWidth, tileHeight]
    draggable: {
      start: (e, ui, $widget) ->
        dragged = true;
    }


  gridster = $(".gridster ul").gridster().data('gridster');


  #if #drag_disabled exists, then don't let the user drag tiles
  if $("#drag_disabled").length > 0
    gridster.disable();


  $(".expand_tile").mouseup ->
    if dragged is true
      setTimeout(savePositions, 200)
    else
      numberRegex = /[0-9]+/
      currentLightbox = @id.match(numberRegex)
      console.log "#{@id} - #{currentLightbox}"
      showLightbox $(".content_#{currentLightbox}")


  # Buttons for deleting tiles
  $(".gridster a img.tile_delete").click ->
    lightboxID = @id.match(/tile_delete_([0-9]+)/)[1]

    if confirm("Are you sure you want to delete this? This can't be undone")
      deleteTile lightboxID


  #Toggle edit tools button
  $(".toggle_edit_tools").click ->
    $(".edit_tools").toggle()


  # Open image edit lightbox when upload a new image
  $(".grid_tile_image_upload").change (event) ->
    currentElement = $.trim($(".current_element_id").text())
    input = $(event.currentTarget)
    file = input[0].files[0]
    reader = new FileReader()
    reader.onload = (e) ->
      uploadedImage = e.target.result
      $(".grid_tile_#{currentElement}").css({"background": "url(#{uploadedImage})"})
      currentLightbox = "crop"
      buildCropLightbox()
      showLightbox $(".crop_image_lightbox")
      showSaveReminder()
    reader.readAsDataURL file


  ##
  # buildCropLightbox
  #
  buildCropLightbox = ->
    imageDimensions = getImageDimensions(uploadedImage)
    imageDimensions = scaleDownImage(imageDimensions, 600)
    $(".image_preview").attr
      src: uploadedImage,
      width: imageDimensions.width,
      height: imageDimensions.height
    $(".gridster-mini ul").gridster
      widget_margins: [miniTileMarginX, miniTileMarginY]
      widget_base_dimensions: [miniTileWidth, miniTileHeight]
      draggable: {
        start: (e, ui, $widget) ->
          dragged = true;
      }


  ##
  # getImageDimensions
  #
  getImageDimensions = (passed_image) ->
    i = new Image()
    i.src = passed_image
    return { width: i.width, height: i.height }


  ##
  # scaleDownImage
  #
  scaleDownImage = ( original, maxWidth ) ->
    factor = maxWidth / original.width
    original.width = original.width * factor
    original.height = original.height * factor
    return original


  ##
  # showLightbox
  #
  showLightbox = (lightbox) ->
    $(".overlay").show()
    console.log lightbox
    lightbox.show()


  ##
  # closeLightbox
  #
  closeLightbox = (lightbox) ->
    $(".overlay").hide()

    if lightbox == "crop"
      lightbox = "crop_image_lightbox"
      $(".crop_image_lightbox").hide()
    else
      $(".content_#{lightbox}").hide()
      $(".content_preview .content_#{lightbox}").show()

    currentLightbox = null;


  ##
  # showSaveReminder
  #
  showSaveReminder = ->
    console.log "NOTE: make showSaveReminder"


  ##
  # deleteTile
  #
  deleteTile = (lightboxNumber) ->
    console.log "Delete the thing here"
    $("input#delete_work_#{lightboxNumber}").trigger("click")


  ##
  # savePositions
  #
  savePositions = ->
    tiles = getPositions()
    $("#serialized_array").val JSON.stringify(tiles)
    $(".edit_grid_position").submit()


  ##
  # getPositions
  #
  getPositions = ->
    tilePositions = []
    $(".gridster ul li").each (i, element) ->
      unless !element.id.match(/tile_[0-9]/)
        current = 
          row:          $(element).attr('data-row')
          column:       $(element).attr('data-col')
          sizex:        $(element).attr('data-sizex')
          sizey:        $(element).attr('data-sizey')
          databaseID:   element.id.match(/[0-9]/)[0]

        tilePositions.push current

    return tilePositions

