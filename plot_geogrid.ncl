;----------------------------------------------------------------------
; wrf_gsn_9.ncl
;----------------------------------------------------------------------
; Concepts illustrated:
;   - Using gsn_csm scripts to plot WRF-ARW data
;   - Comparing shapefile data with NCL's map databases
;----------------------------------------------------------------------
; This script creates filled contours of a WRF variable over the map
; projection defined on the WRF output file.
;
; Three versions of the same plot are created, so you can compare:
;    - NCL's "MediumRes" map outlines
;    - RANGS database high-res coastal outlines
;    - shapefile outlines
;
; Instructions for getting the RANGS database can be found at:
;    http://www.ncl.ucar.edu/Document/Graphics/rangs.shtml
;
; The shapefile outlines for France and Spain were downloaded from :
;    http://www.gadm.org/country
;----------------------------------------------------------------------
; These files are loaded by default in NCL V6.2.0 and newer
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
; load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"

begin
;---Open WRF output file
  fname = "/root/Buildwrf_pan/plots/geo_em.d02.nc"
  a    = addfile(fname,"r")

  wks = gsn_open_wks("x11","Plot_geo")
  
  ter = a->HGT_M(0,:,:)

;---Set common resources for all plots
  res                      = True
  res@gsnMaximize          = True
  res@gsnDraw              = False
  res@gsnFrame             = False

  res@cnFillOn             = True
  res@cnLinesOn            = False
  res@cnLineLabelsOn       = False
  res@cnInfoLabelOn        = False

;  res@cnLevelSelectionMode = "ExplicitLevels"
;  res@cnLevels             =  (/ 0.,2.,4,5,6,7,8,9,10,11,12,13,14,15,20/)

  res@lbLabelBarOn         = False     ; turn labelbar off and draw in panel

;  res@gsnLeftString        = "Temperature (" + tc2@units + ")"
;  res@gsnRightString       = ""

;---Plot data using WRF map projection
  res                       = wrf_map_resources(a,res)
  res@tfDoNDCOverlay        = True          ; This must be set to True
                                            ; if using WRF map projection
; res@tfDoNDCOverlay        = "NDCViewport" ; Can use this in NCL V6.5.0 or later


  res@gsnAddCyclic         = False    ; Must set this when doing native and regional data

  res@mpGeophysicalLineColor        = "black"    ; So we can see the map
  res@mpGeophysicalLineThicknessF   = 2.0        ; outlines better.


;---Plot using shapefile outlines, downloaded from gadm.org/country.
  res@tiMainString = "Laos Climate Data Downscaling Task 1 - Domain 2"
  res@mpOutlineOn  = False                             ; turn off NCL outlines so we can add shapefile outlines
  plot_shp = gsn_csm_contour_map(wks,ter,res)

  lnres                    = True
  lnres@gsLineThicknessF   = 2.0        ; So we can see outlines better in PNG image.
  id_lao   = gsn_add_shapefile_polylines(wks,plot_shp,"gadm36_LAO_shp/gadm36_LAO_1.shp",lnres)    ; Lao

;----------------------------------------------------------------------
; Panel all three plots so we can compare them.
;----------------------------------------------------------------------
  pres                  = True
  pres@gsnPanelLabelBar = True
  pres@pmLabelBarWidthF = 0.8
  pres@gsnPanelRowSpec  = True
  gsn_panel(wks,(/plot_shp/),(/1/),pres)
end

