var rows = 12
var columns = 12
var divLeft = 211.5
var divTop = 174.5
var keyLeft = 211.5
var keyTop = 125.0
var multipliedDivLeft = 211.5
var multipliedDivTop = 187.5
var showingColumns = 9
var updater = 300
var numbers = []
var lastColumns = []
var totalColumns = []
var generatedKeys = []
var currentRow = 0
var currentBank = ''

$(document).ready(function() {
	window.addEventListener('message', (event) => {
		if(event.data.action == "show") {
			document.getElementById("container-overlay").style.display = "block"

			currentBank = event.data.bank
		} else if(event.data.action == "keyinput") {
			if(event.data.key == "ENTER") {
				tryToHack()
			}
		} else if(event.data.action == "hide") {
			document.getElementById("container-overlay").style.display = "none"
		}
	});

	for(var row = 0; row < rows; row++) {
		var multiplier = false
		var keyColumn = getRandom(0, columns - 1)

		for(var column = 0; column < columns; column++) {
			var gottenNumbers = []
			var number = getRandom(0, 99)

			while(true) {
				if(gottenNumbers[number] != null) {
					number = getRandom(0, 99)
				} else {
					gottenNumbers[number] = true

					break
				}
			}

			if(number < 10) {
				number = "0" + number
			}

			if(keyColumn == column) {
				generatedKeys[row] = number
			}

			var div = document.createElement("div")
			var paragraph = document.createElement("P")
			var text = document.createTextNode(number)

			div.id = row + ":" + column
			div.style.position = "absolute"
			div.style.color = "#6b75c4"
			div.style.width = "42px"
			div.style.height = "42px"
			div.style.background = "#333333"

			if(column == ~~(showingColumns / 2)) {
				div.style.top = (divTop + (column * 47)) + "px"
				div.style.left = (divLeft + (row * 45)) + "px"

				multiplier = true
			} else if(multiplier) {
				div.style.top = (multipliedDivTop + (column * 45)) + "px"
				div.style.left = (multipliedDivLeft + (row * 45)) + "px"
			} else {
				div.style.top = (divTop + (column * 45)) + "px"
				div.style.left = (divLeft + (row * 45)) + "px"
			}

			if(column == ~~(showingColumns / 2)) {
				if(row == currentRow) {
					div.setAttribute("class", "container-current-selected-number")
				} else {
					div.setAttribute("class", "container-selected-number")
				}
			} else {
				div.setAttribute("class", "container-number")
			}

			paragraph.style.marginLeft = "7px"
			paragraph.style.marginTop = "6px"
			paragraph.appendChild(text)

			div.appendChild(paragraph)
			div.style.display = "none"

			document.getElementById("container").appendChild(div)

			totalColumns[row + ":" + column] = column
			numbers[row + ":" + column] = number
		}
	}

	for(var row = 0; row < rows; row++) {
		for(var column = 0; column < showingColumns; column++) {
			var div = document.getElementById(row + ":" + column)
			var paragraph = div.getElementsByTagName("p")[0]

			div.style.display = "block"

			lastColumns[row + ":" + column] = column
		}	
	}

	for(var row = 0; row < rows; row++) {
		var div = document.createElement("DIV")
		var paragraph = document.createElement("P")
		var text = document.createTextNode(generatedKeys[row])

		div.id = "key:" + row
		div.style.top = keyTop + "px"
		div.style.left = (keyLeft + (row * 45)) + "px"

		paragraph.appendChild(text)
		div.appendChild(paragraph)

		if(row >= currentRow) {
			div.setAttribute("class", "container-generated-key")
		} else {
			div.setAttribute("class", "container-successful-generated-key")
		}

		document.getElementById("container").appendChild(div)
	}

	setTimeout(updateColumns, updater)
})

function updateColumns() {
	var newColumns = []
 
	for(var row = 0; row < rows; row++) {
		for(var column = 0; column < (showingColumns - 1); column++) {
			newColumns[row + ":" + (column + 1)] = lastColumns[row + ":" + column]
		}

		var div = document.getElementById(row + ":" + lastColumns[row + ":8"])
 
		div.style.display = "none"
	}

	for(var row = 0; row < rows; row++) {
		var column = lastColumns[row + ":8"] + 1

		if(column >= columns) {
			column = 0
		}

		var columnIndex = totalColumns[row + ":" + column]
		var div = document.getElementById(row + ":" + columnIndex)

		div.style.display = "block"

		newColumns[row + ":0"] = columnIndex
	}

	for(var row = 0; row < rows; row++) {
		var multiplier = false

		for(var column = 0; column < showingColumns; column++) {
			var div = document.getElementById(row + ":" + newColumns[row + ":" + column])

			if(column == ~~(showingColumns / 2)) {
				div.style.top = (divTop + (column * 47)) + "px"
				div.style.left = (divLeft + (row * 45)) + "px"

				multiplier = true
			} else if(multiplier) {
				div.style.top = (multipliedDivTop + (column * 45)) + "px"
				div.style.left = (multipliedDivLeft + (row * 45)) + "px"
			} else {
				div.style.top = (divTop + (column * 45)) + "px"
				div.style.left = (divLeft + (row * 45)) + "px"
			}

			if(column == ~~(showingColumns / 2)) {
				if(row == currentRow) {
					div.setAttribute("class", "container-current-selected-number")
				} else {
					div.setAttribute("class", "container-selected-number")
				}
			} else {
				div.setAttribute("class", "container-number")
			}
		}
	}

	lastColumns = newColumns

	createTimeout()
}

function tryToHack() {
	var div = document.getElementById(currentRow + ":" + lastColumns[currentRow + ":" + ~~(showingColumns / 2)])
	var text = div.getElementsByTagName("P")[0]

	if(text.textContent == generatedKeys[currentRow]) {
		document.getElementById("key:" + currentRow).setAttribute("class", "container-successful-generated-key")

		currentRow++

		if(currentRow == rows) {
			successfulHack()
		}
	} else {
		if(currentRow >= 2) { 
			document.getElementById("key:" + (currentRow - 2)).setAttribute("class", "container-generated-key")
			document.getElementById("key:" + (currentRow - 1)).setAttribute("class", "container-generated-key")
			
			currentRow = currentRow - 2
		} else if(currentRow >= 1) {
			document.getElementById("key:" + (currentRow - 1)).setAttribute("class", "container-generated-key")
			
			currentRow = currentRow - 1
		}
	}
}

function successfulHack() {
	document.getElementById("container").style.filter = "blur(8px)"

 	swal({
		title: "Success",
		text: "You successfully hacked the vault",
		icon: "success",
		buttons: false,
		closeOnClickOutside: false,
	})

	setTimeout(clearEffects, 3000)
}

function clearEffects() {
	document.getElementById("container-overlay").style.display = "none"
	document.getElementById("container").style.filter = "none"

	swal.close()
	
	SendMessage('never-quests', 'hackingSuccess', {
		bank: currentBank
	})
}

function createTimeout() {
	setTimeout(updateColumns, updater)
}
 
function getRandom(min, max) {
    return Math.floor(Math.random() * (max - min + 1)) + min
}