var customToolTipLeft = {
	width: 200,
	padding: 5,
	background: '#A2D959',
	color: 'black',
	textAlign: 'center',
	border: {
		width: 7,
		radius: 5,
		color: '#A2D959'
	},		
	tip: 'topLeft',
	name: 'dark'
};

var customToolTipRight = {
	width: 200,
	padding: 5,
	background: '#A2D959',
	color: 'black',
	textAlign: 'center',
	border: {
		width: 7,
		radius: 5,
		color: '#A2D959'
	},		
	tip: 'topRight',
	name: 'dark'
};

function displayLoadingGif() {
	document.getElementById("loadingDiv").style.display = "inline";
}

function hideLoadingGif() {
	document.getElementById("loadingDiv").style.display = "none";
}

function updateButtonText(id) {
	var inputbutton = document.getElementById(id);
	inputbutton.innerHTML = "<p style='padding:5px 5px 5px 5px;'>Please wait...</p>";
}

function resetButtonText(id, text) {
	var inputbutton = document.getElementById(id);
	inputbutton.innerHTML = text;
}

function disableButton(id) {
	var inputbutton = document.getElementById(id);
	inputbutton.innerHTML = "<p style='padding:5px 5px 5px 5px;'>Please wait...</p>";
	inputbutton.disabled = true;
}

function enableButton(id, text) {
	var inputbutton = document.getElementById(id);
	inputbutton.disabled = false;
	inputbutton.innerHTML = text;
}