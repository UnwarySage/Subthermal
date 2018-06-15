extends Node

var present_score = 0

func adjust_score(adjustment):
	present_score += adjustment
	print(present_score)