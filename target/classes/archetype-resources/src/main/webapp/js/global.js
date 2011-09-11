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
	inputbutton.disabled = true;
}

function enableButton(id, text) {
	var inputbutton = document.getElementById(id);
	inputbutton.disabled = false;
	inputbutton.innerHTML = text;
}

function performSubmit(id) {
	displayLoadingGif();
	updateButtonText(id);
	//disableButton(id); TODO haven't bee able to get button disable to work successfully.
}

/* Trim function */
function trim(sInString) {
  sInString = sInString.replace( /^\s+/g, "" );// strip leading
  return sInString.replace( /\s+$/g, "" );// strip trailing
} 