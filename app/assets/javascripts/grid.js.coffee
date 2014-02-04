$ -> #DOM Ready

  tileWidth = 138
  tileHeight = 138
  tileMarginX = 5
  tileMarginY = 5
  currentLightbox = null #id of the currently expanded lightbox
  uploadedImage = null
  dragged = false
  gridster = null

#####   Functions   #####
  ##
  # showCropPopup
  #
  showCropPopup = (image) ->
    buildCropPopup()
    $(".crop_image_popup").show()
    currentLightbox = "crop"


  ##
  # buildCropPopup
  #
  buildCropPopup = ->
    imageDimensions = getImageDimensions(uploadedImage)
    imageDimensions = scaleDownImage(imageDimensions, {width: 225, height: 190})
    $(".image_preview").attr
      src: uploadedImage,
      width: imageDimensions.width,
      height: imageDimensions.height


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
  scaleDownImage = ( original, maxDimensions ) ->
    #if original is smaller than max size
    if original.width <= maxDimensions.width && original.height <= maxDimensions.height
      return original


    if original.width <= original.height
      factor = original.height / maxDimensions.height
    else
      factor = original.width / maxDimensions.width

    if factor >= 1
      original.width = original.width / factor
      original.height = original.height / factor
    else
      original.width = original.width * factor
      original.height = original.height * factor

    return original


  ##
  # showLightbox
  #
  showLightbox = (lightbox) ->
    $(".overlay").show()
    lightbox.show()


  ##
  # closeLightbox
  #
  closeLightbox = (lightbox) ->
    $(".overlay").hide()

    if lightbox == "crop"
      lightbox = "crop_image_lightbox"
      $(".crop_image_popup").hide()
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
    console.log "Saving grid positions"
    tiles = getPositions()
    console.log "tile positions = "
    console.log tiles
    $("#serialized_array").val JSON.stringify(tiles)
    $(".edit_grid_position").submit()


  ##
  # getPositions
  #
  getPositions = ->
    tilePositions = []
    console.log "searching gridster elements..."
    $(".gridster ul li").each (i, element) ->
      console.log "current element = "
      console.log element
      if $(element).attr('data-row') && $(element).attr('data-col') && $(element).attr('data-sizex') && $(element).attr('data-sizey')
        console.log "saving position of #{element.id}: row = #{$(element).attr('data-row')}, col = #{$(element).attr('data-col')}, sizex = #{$(element).attr('data-sizex')}, sizey = #{$(element).attr('data-sizey')}, databaseID = #{$(element).attr('data-databaseID')}"
        current = 
          row:          $(element).attr('data-row')
          column:       $(element).attr('data-col')
          sizex:        $(element).attr('data-sizex')
          sizey:        $(element).attr('data-sizey')
          databaseid:   $(element).attr('data-databaseid')

        tilePositions.push current

    return tilePositions


#####   The main functions   #####

  #Turn on gridster
  $(".gridster ul").gridster
    widget_margins: [tileMarginX, tileMarginY]
    widget_base_dimensions: [tileWidth, tileHeight]
    draggable: {
      start: (e, ui, $widget) ->
        console.log "dragging!"
        dragged = true

      stop: (e, ui, $widget) ->
        console.log "drag stopped. saving positions..."
        setTimeout(savePositions, 200)
        dragged = false
    }
  gridster = $(".gridster ul").gridster().data('gridster');


  #if #drag_disabled exists, then don't let the user drag tiles
  if $("#drag_disabled").length > 0
    gridster.disable();


  $(".close, .overlay").click ->
    closeLightbox(currentLightbox)


  $(".expand_tile").mouseup ->
    console.log "finished clicking on a tile! dragged = #{dragged}"
    if !dragged
      numberRegex = /[0-9]+/
      currentLightbox = @id.match(numberRegex)
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
      showSaveReminder()
    reader.readAsDataURL file


  #Upload different image when "Change image" is clicked in the crop image
  #popup
  $(".crop_image_popup .crop_change_image").click ->
    $("#grid_tile_image").trigger('click');


