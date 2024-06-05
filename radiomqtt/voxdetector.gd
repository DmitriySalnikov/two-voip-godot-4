extends HBoxContainer

const outlinewidth = 4
var samplesrunon = 17
var samplescountdown = 0
var voxthreshold = 1.0
var visthreshold = 1.0

func _on_h_slider_vox_value_changed(value):
	voxthreshold = value/$HSliderVox.max_value
	
func _ready():
	await get_tree().process_frame 
	$HSliderVox/ColorRectBackground.size = $HSliderVox.size
	$HSliderVox/ColorRectLoudness.size = $HSliderVox.size
	$HSliderVox/ColorRectLoudness2.size = Vector2($HSliderVox.size.x, $HSliderVox.size.y/3)
	$HSliderVox/ColorRectThreshold.position.y = 0
	$HSliderVox/ColorRectThreshold.size.y = $HSliderVox.size.y
	$HSliderVox/ColorRectThreshold.size.x = outlinewidth
	_on_h_slider_vox_value_changed($HSliderVox.value)
	
func loudnessvalues(chunkv1, chunkv2):
	$HSliderVox/ColorRectLoudness.size.x = $HSliderVox.size.x*chunkv1
	$HSliderVox/ColorRectLoudness2.size.x = $HSliderVox.size.x*chunkv2
	if chunkv1 >= voxthreshold:
		if not $HSliderVox/ColorRectThreshold.visible:
			visthreshold = chunkv1
			$HSliderVox/ColorRectThreshold.visible = true
			if $Vox.pressed:
				$PTT.set_pressed(true)
		else:
			visthreshold = max(visthreshold, chunkv1)
		$HSliderVox/ColorRectThreshold.position.x = $HSliderVox.size.x*visthreshold - outlinewidth/2.0
		samplescountdown = samplesrunon
	elif samplescountdown > 0:
		samplescountdown -= 1
		if samplescountdown == 0:
			$HSliderVox/ColorRectThreshold.visible = false
			if $Vox.pressed:
				$PTT.set_pressed(false)
		
func _on_vox_toggled(toggled_on):
	$PTT.toggle_mode = toggled_on
	$PTT.set_pressed($HSliderVox/ColorRectThreshold.visible and toggled_on)
