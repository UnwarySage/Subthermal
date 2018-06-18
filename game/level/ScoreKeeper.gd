extends Node

var present_score = 0
var high_score = 0
var prev_scores = []

func adjust_score(adjustment):
	present_score += adjustment
	print(present_score)

func add_score_to_table():
	if(present_score > high_score):
		high_score = present_score
	prev_scores.append(present_score)