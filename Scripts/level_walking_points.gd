class_name WalkingPoints
extends Node3D

@onready var walking_point: VisibleOnScreenNotifier3D = $WalkingPoint

@onready var walking_point_2: VisibleOnScreenNotifier3D = $WalkingPoint2
@onready var walking_point_3: VisibleOnScreenNotifier3D = $WalkingPoint3
@onready var walking_point_4: VisibleOnScreenNotifier3D = $WalkingPoint4
@onready var walking_point_5: VisibleOnScreenNotifier3D = $WalkingPoint5
@onready var walking_point_6: VisibleOnScreenNotifier3D = $WalkingPoint6
@onready var walking_point_7: VisibleOnScreenNotifier3D = $WalkingPoint7
@onready var walking_point_8: VisibleOnScreenNotifier3D = $WalkingPoint8
@onready var walking_point_9: VisibleOnScreenNotifier3D = $WalkingPoint9
@onready var walking_point_10: VisibleOnScreenNotifier3D = $WalkingPoint10

@onready var walking_point_11: VisibleOnScreenNotifier3D = $WalkingPoint11
@onready var walking_point_12: VisibleOnScreenNotifier3D = $WalkingPoint12
@onready var walking_point_13: VisibleOnScreenNotifier3D = $WalkingPoint13
@onready var walking_point_14: VisibleOnScreenNotifier3D = $WalkingPoint14
@onready var walking_point_15: VisibleOnScreenNotifier3D = $WalkingPoint15
@onready var walking_point_16: VisibleOnScreenNotifier3D = $WalkingPoint16
@onready var walking_point_17: VisibleOnScreenNotifier3D = $WalkingPoint17
@onready var walking_point_18: VisibleOnScreenNotifier3D = $WalkingPoint18
@onready var walking_point_19: VisibleOnScreenNotifier3D = $WalkingPoint19
@onready var walking_point_20: VisibleOnScreenNotifier3D = $WalkingPoint20

@onready var walking_point_21: VisibleOnScreenNotifier3D = $WalkingPoint21
@onready var walking_point_22: VisibleOnScreenNotifier3D = $WalkingPoint22
@onready var walking_point_23: VisibleOnScreenNotifier3D = $WalkingPoint23
@onready var walking_point_24: VisibleOnScreenNotifier3D = $WalkingPoint24
@onready var walking_point_25: VisibleOnScreenNotifier3D = $WalkingPoint25
@onready var walking_point_26: VisibleOnScreenNotifier3D = $WalkingPoint26
@onready var walking_point_27: VisibleOnScreenNotifier3D = $WalkingPoint27
@onready var walking_point_28: VisibleOnScreenNotifier3D = $WalkingPoint28
@onready var walking_point_29: VisibleOnScreenNotifier3D = $WalkingPoint29
@onready var walking_point_30: VisibleOnScreenNotifier3D = $WalkingPoint30

@onready var walking_point_31: VisibleOnScreenNotifier3D = $WalkingPoint31
@onready var walking_point_32: VisibleOnScreenNotifier3D = $WalkingPoint32
@onready var walking_point_33: VisibleOnScreenNotifier3D = $WalkingPoint33
@onready var walking_point_34: VisibleOnScreenNotifier3D = $WalkingPoint34
@onready var walking_point_35: VisibleOnScreenNotifier3D = $WalkingPoint35
@onready var walking_point_36: VisibleOnScreenNotifier3D = $WalkingPoint36
@onready var walking_point_37: VisibleOnScreenNotifier3D = $WalkingPoint37
@onready var walking_point_38: VisibleOnScreenNotifier3D = $WalkingPoint38
@onready var walking_point_39: VisibleOnScreenNotifier3D = $WalkingPoint39
@onready var walking_point_40: VisibleOnScreenNotifier3D = $WalkingPoint40

@onready var walking_point_41: VisibleOnScreenNotifier3D = $WalkingPoint41
@onready var walking_point_42: VisibleOnScreenNotifier3D = $WalkingPoint42
@onready var walking_point_43: VisibleOnScreenNotifier3D = $WalkingPoint43
@onready var walking_point_44: VisibleOnScreenNotifier3D = $WalkingPoint44
@onready var walking_point_45: VisibleOnScreenNotifier3D = $WalkingPoint45
@onready var walking_point_46: VisibleOnScreenNotifier3D = $WalkingPoint46
@onready var walking_point_47: VisibleOnScreenNotifier3D = $WalkingPoint47
@onready var walking_point_48: VisibleOnScreenNotifier3D = $WalkingPoint48
@onready var walking_point_49: VisibleOnScreenNotifier3D = $WalkingPoint49
@onready var walking_point_50: VisibleOnScreenNotifier3D = $WalkingPoint50

@onready var walking_point_51: VisibleOnScreenNotifier3D = $WalkingPoint51
@onready var walking_point_52: VisibleOnScreenNotifier3D = $WalkingPoint52
@onready var walking_point_53: VisibleOnScreenNotifier3D = $WalkingPoint53
@onready var walking_point_54: VisibleOnScreenNotifier3D = $WalkingPoint54
@onready var walking_point_55: VisibleOnScreenNotifier3D = $WalkingPoint55
@onready var walking_point_56: VisibleOnScreenNotifier3D = $WalkingPoint56
@onready var walking_point_57: VisibleOnScreenNotifier3D = $WalkingPoint57
@onready var walking_point_58: VisibleOnScreenNotifier3D = $WalkingPoint58
@onready var walking_point_59: VisibleOnScreenNotifier3D = $WalkingPoint59
@onready var walking_point_60: VisibleOnScreenNotifier3D = $WalkingPoint60

@onready var walking_point_61: VisibleOnScreenNotifier3D = $WalkingPoint61
@onready var walking_point_62: VisibleOnScreenNotifier3D = $WalkingPoint62
@onready var walking_point_63: VisibleOnScreenNotifier3D = $WalkingPoint63
@onready var walking_point_64: VisibleOnScreenNotifier3D = $WalkingPoint64
@onready var walking_point_65: VisibleOnScreenNotifier3D = $WalkingPoint65
@onready var walking_point_66: VisibleOnScreenNotifier3D = $WalkingPoint66
@onready var walking_point_67: VisibleOnScreenNotifier3D = $WalkingPoint67
@onready var walking_point_68: VisibleOnScreenNotifier3D = $WalkingPoint68
@onready var walking_point_69: VisibleOnScreenNotifier3D = $WalkingPoint69

@onready var starting_point : VisibleOnScreenNotifier3D = walking_point

func _ready() -> void:
	GameManager.walking_points = self
	GameManager.player.current_walk_point = starting_point

func check_points_next_to_current_point(current_point : VisibleOnScreenNotifier3D) -> Array:
	var points_next_to_current_point : Array[VisibleOnScreenNotifier3D]
	
	# points next to current point, in order of left, middle, right if 3. otherwise , left and right
	match current_point:
		walking_point:
			points_next_to_current_point.push_back(walking_point_56)
			points_next_to_current_point.push_back(walking_point_2)
			points_next_to_current_point.push_back(walking_point_55)
		walking_point_2:
			points_next_to_current_point.push_back(walking_point_3)
			points_next_to_current_point.push_back(walking_point)
		walking_point_3:
			points_next_to_current_point.push_back(walking_point_4)
			points_next_to_current_point.push_back(walking_point_2)
		walking_point_4:
			points_next_to_current_point.push_back(walking_point_5)
			points_next_to_current_point.push_back(walking_point_3)
		walking_point_5:
			points_next_to_current_point.push_back(walking_point_6)
			points_next_to_current_point.push_back(walking_point_4)
		walking_point_6:
			points_next_to_current_point.push_back(walking_point_7)
			points_next_to_current_point.push_back(walking_point_5)
		walking_point_7:
			points_next_to_current_point.push_back(walking_point_8)
			points_next_to_current_point.push_back(walking_point_6)
		walking_point_8:
			points_next_to_current_point.push_back(walking_point_9)
			points_next_to_current_point.push_back(walking_point_7)
		walking_point_9:
			points_next_to_current_point.push_back(walking_point_10)
			points_next_to_current_point.push_back(walking_point_8)
		walking_point_10:
			points_next_to_current_point.push_back(walking_point_11)
			points_next_to_current_point.push_back(walking_point_9)
		walking_point_11:
			points_next_to_current_point.push_back(walking_point_12)
			points_next_to_current_point.push_back(walking_point_10)
		walking_point_12:
			points_next_to_current_point.push_back(walking_point_13)
			points_next_to_current_point.push_back(walking_point_11)
		walking_point_13:
			points_next_to_current_point.push_back(walking_point_14)
			points_next_to_current_point.push_back(walking_point_17)
			points_next_to_current_point.push_back(walking_point_12)
		walking_point_14:
			points_next_to_current_point.push_back(walking_point_15)
			points_next_to_current_point.push_back(walking_point_13)
		walking_point_15:
			points_next_to_current_point.push_back(walking_point_16)
			points_next_to_current_point.push_back(walking_point_14)
		walking_point_16:
			points_next_to_current_point.push_back(walking_point_15)
		walking_point_17:
			points_next_to_current_point.push_back(walking_point_18)
			points_next_to_current_point.push_back(walking_point_13)
		walking_point_18:
			points_next_to_current_point.push_back(walking_point_19)
			points_next_to_current_point.push_back(walking_point_17)
		walking_point_19:
			points_next_to_current_point.push_back(walking_point_20)
			points_next_to_current_point.push_back(walking_point_24)
			points_next_to_current_point.push_back(walking_point_18)
		walking_point_20:
			points_next_to_current_point.push_back(walking_point_21)
			points_next_to_current_point.push_back(walking_point_19)
		walking_point_21:
			points_next_to_current_point.push_back(walking_point_22)
			points_next_to_current_point.push_back(walking_point_20)
		walking_point_22:
			points_next_to_current_point.push_back(walking_point_23)
			points_next_to_current_point.push_back(walking_point_21)
		walking_point_23:
			points_next_to_current_point.push_back(walking_point_22)
		walking_point_24:
			points_next_to_current_point.push_back(walking_point_25)
			points_next_to_current_point.push_back(walking_point_19)
		walking_point_25:
			points_next_to_current_point.push_back(walking_point_26)
			points_next_to_current_point.push_back(walking_point_69)
			points_next_to_current_point.push_back(walking_point_24)
		walking_point_26:
			points_next_to_current_point.push_back(walking_point_27)
			points_next_to_current_point.push_back(walking_point_25)
		walking_point_27:
			points_next_to_current_point.push_back(walking_point_28)
			points_next_to_current_point.push_back(walking_point_26)
		walking_point_28:
			points_next_to_current_point.push_back(walking_point_29)
			points_next_to_current_point.push_back(walking_point_33)
			points_next_to_current_point.push_back(walking_point_27)
		walking_point_29:
			points_next_to_current_point.push_back(walking_point_30)
			points_next_to_current_point.push_back(walking_point_28)
		walking_point_30:
			points_next_to_current_point.push_back(walking_point_31)
			points_next_to_current_point.push_back(walking_point_29)
		walking_point_31:
			points_next_to_current_point.push_back(walking_point_32)
			points_next_to_current_point.push_back(walking_point_30)
		walking_point_32:
			points_next_to_current_point.push_back(walking_point_31)
		walking_point_33:
			points_next_to_current_point.push_back(walking_point_34)
			points_next_to_current_point.push_back(walking_point_28)
		walking_point_34:
			points_next_to_current_point.push_back(walking_point_35)
			points_next_to_current_point.push_back(walking_point_33)
		walking_point_35:
			points_next_to_current_point.push_back(walking_point_36)
			points_next_to_current_point.push_back(walking_point_34)
		walking_point_36:
			points_next_to_current_point.push_back(walking_point_37)
			points_next_to_current_point.push_back(walking_point_35)
		walking_point_37:
			points_next_to_current_point.push_back(walking_point_38)
			points_next_to_current_point.push_back(walking_point_36)
		walking_point_38:
			points_next_to_current_point.push_back(walking_point_39)
			points_next_to_current_point.push_back(walking_point_37)
		walking_point_39:
			points_next_to_current_point.push_back(walking_point_40)
			points_next_to_current_point.push_back(walking_point_38)
		walking_point_40:
			points_next_to_current_point.push_back(walking_point_41)
			points_next_to_current_point.push_back(walking_point_39)
		walking_point_41:
			points_next_to_current_point.push_back(walking_point_42)
			points_next_to_current_point.push_back(walking_point_46)
			points_next_to_current_point.push_back(walking_point_40)
		walking_point_42:
			points_next_to_current_point.push_back(walking_point_43)
			points_next_to_current_point.push_back(walking_point_41)
		walking_point_43:
			points_next_to_current_point.push_back(walking_point_44)
			points_next_to_current_point.push_back(walking_point_42)
		walking_point_44:
			points_next_to_current_point.push_back(walking_point_45)
			points_next_to_current_point.push_back(walking_point_43)
		walking_point_45:
			points_next_to_current_point.push_back(walking_point_44)
		walking_point_46:
			points_next_to_current_point.push_back(walking_point_47)
			points_next_to_current_point.push_back(walking_point_41)
		walking_point_47:
			points_next_to_current_point.push_back(walking_point_48)
			points_next_to_current_point.push_back(walking_point_46)
		walking_point_48:
			points_next_to_current_point.push_back(walking_point_49)
			points_next_to_current_point.push_back(walking_point_52)
			points_next_to_current_point.push_back(walking_point_47)
		walking_point_49:
			points_next_to_current_point.push_back(walking_point_50)
			points_next_to_current_point.push_back(walking_point_48)
		walking_point_50:
			points_next_to_current_point.push_back(walking_point_51)
			points_next_to_current_point.push_back(walking_point_49)
		walking_point_51:
			points_next_to_current_point.push_back(walking_point_50)
		walking_point_52:
			points_next_to_current_point.push_back(walking_point_53)
			points_next_to_current_point.push_back(walking_point_48)
		walking_point_53:
			points_next_to_current_point.push_back(walking_point_54)
			points_next_to_current_point.push_back(walking_point_62)
			points_next_to_current_point.push_back(walking_point_52)
		walking_point_54:
			points_next_to_current_point.push_back(walking_point_55)
			points_next_to_current_point.push_back(walking_point_53)
		walking_point_55:
			points_next_to_current_point.push_back(walking_point)
			points_next_to_current_point.push_back(walking_point_54)
		walking_point_56:
			points_next_to_current_point.push_back(walking_point_57)
			points_next_to_current_point.push_back(walking_point)
		walking_point_57:
			points_next_to_current_point.push_back(walking_point_58)
			points_next_to_current_point.push_back(walking_point_56)
		walking_point_58:
			points_next_to_current_point.push_back(walking_point_59)
			points_next_to_current_point.push_back(walking_point_57)
		walking_point_59:
			points_next_to_current_point.push_back(walking_point_60)
			points_next_to_current_point.push_back(walking_point_58)
		walking_point_60:
			points_next_to_current_point.push_back(walking_point_61)
			points_next_to_current_point.push_back(walking_point_59)
		walking_point_61:
			points_next_to_current_point.push_back(walking_point_60)
		walking_point_62:
			points_next_to_current_point.push_back(walking_point_63)
			points_next_to_current_point.push_back(walking_point_53)
		walking_point_63:
			points_next_to_current_point.push_back(walking_point_64)
			points_next_to_current_point.push_back(walking_point_62)
		walking_point_64:
			points_next_to_current_point.push_back(walking_point_65)
			points_next_to_current_point.push_back(walking_point_63)
		walking_point_65:
			points_next_to_current_point.push_back(walking_point_66)
			points_next_to_current_point.push_back(walking_point_64)
		walking_point_66:
			points_next_to_current_point.push_back(walking_point_67)
			points_next_to_current_point.push_back(walking_point_65)
		walking_point_67:
			points_next_to_current_point.push_back(walking_point_68)
			points_next_to_current_point.push_back(walking_point_66)
		walking_point_68:
			points_next_to_current_point.push_back(walking_point_69)
			points_next_to_current_point.push_back(walking_point_67)
		walking_point_69:
			points_next_to_current_point.push_back(walking_point_25)
			points_next_to_current_point.push_back(walking_point_68)
	
	return points_next_to_current_point
