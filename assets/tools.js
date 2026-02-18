let agenda = null;
let minutes = null;

function setButtonState(buttonName, enable) {
  const button = document.getElementById(buttonName);
  if (enable) {
    button.classList.remove("disabled");
    button.removeAttribute("aria-disabled");
  } else {
    button.classList.add("disabled");
    button.setAttribute("aria-disabled", "true");
  }
}

document.addEventListener("DOMContentLoaded", event => {
    setButtonState("generate", false);
    setButtonState("download", false);
});

function checkAgendaUpload(e) {
  const reader = new FileReader();
  reader.onload = () => {
    agenda = reader.result;
    setButtonState("generate", true);
  }
  reader.readAsText(e.files[0]);
}

// From https://stackoverflow.com/a/41133213
function loadFile(filePath) {
  var result = null;
  var xmlhttp = new XMLHttpRequest();
  xmlhttp.open("GET", filePath, false);
  xmlhttp.send();
  if (xmlhttp.status==200) {
    result = xmlhttp.responseText;
  }
  return result;
}

function createMinutesTemplate() {
  if (agenda === null) {
    setButtonState("generate", false);
    return;
  }

  const template1 = loadFile("assets/minutestemplate1.typ");
  if (template1 === null) {
    return;
  }

  const template2 = loadFile("assets/minutestemplate2.typ");
  if (template2 === null) {
    return;
  }

  console.log(agenda);
  console.log(template1);
  console.log(template2);

  minutes = template1;
  minutes += "\n";

  let foundStart = false;

  agenda.split("\n").some(line => {
    foundStart |= line === "= Matters for Discussion";

    if (!foundStart) {
      return false;
    }

    if (line === "= Matters for Noting") {
      return true;
    }

    if (line.startsWith("== ")) {
      minutes += line;
      minutes += "\n// TODO: Replace with discussion and motions made during meeting\n\n";
    }
  });

  minutes += template2;

  setButtonState("download", true);

  // From https://www.tutorialspoint.com/how-to-create-and-save-text-file-in-javascript
  const downloadLink = document.getElementById("download");
  const file = new Blob([minutes], { type: 'text/plain' });
  downloadLink.href = URL.createObjectURL(file);
  downloadLink.download = "minutes.typ";
}
