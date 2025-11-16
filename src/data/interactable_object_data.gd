class_name InteractableObjectData
extends Resource

@export var name: String
@export_file("*.txt") var clues_file: String:
	set(f):
		clues_file= f
		description= FileAccess.get_file_as_string(f)
		
var description: String



func preparse_description():
	print("Pre-parsing ", clues_file)
	var result: String
	result= description.replace("<clue>", "[url]")
	result= result.replace("</clue>", "[/url]")

	var splits:= result.split("[url]")
	if splits.size() > 1:
		for i in range(1, splits.size()):
			var split: String= splits[i]
			var word: String= split.left(split.find("[/"))
			split= split.insert(0, "[url=%s]" % word.to_lower())
			splits[i]= split

		result= "".join(splits) 
	
	print(result)
	print()
	description= result


func parse()-> String:
	prints("Parse", clues_file)
	
	var result:= description

	var splits:= result.split("[url")
	if splits.size() > 1:
		for i in range(1, splits.size()):
			var split: String= splits[i]

			var key_idx:= split.find("=")
			var close_tag_idx:= split.find("]")
			var key:= split.substr(key_idx + 1, close_tag_idx - key_idx - 1)
			prints(" found key", key)
			assert(GameData.clues.has(key))
			var clue: ClueData= GameData.clues[key]
			if clue.discovered:
				split= split.replace(split.left(close_tag_idx), "[color=blue")
				split= split.replace("[/url]", "[/color]")
			else:
				split= split.insert(split.find("]") + 1, "[color=red]")
				split= split.insert(0, "[url")
				split= split.insert(split.find("[/url]"), "[/color]")
				
			splits[i]= split
			
		result= "".join(splits) 
	
	print(result)
	return result
