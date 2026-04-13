function GetDarkState() {
  const toggleState = document.getElementById('dark-mode-toggle').checked;
  const preferDark = matchMedia('(prefers-color-scheme: dark)').matches;
  return toggleState !== preferDark;
}

function ModifyUrl(url, darkState) {
  const urlObj = new URL(url);
  urlObj.searchParams.set('mode', darkState ? 'dark' : 'light');
  return urlObj;
}

function FindUrl(link) {
  const url = new URL(link);
  return url.origin === location.origin && url.pathname.endsWith('.html') &&
         url.pathname !== location.pathname;
}

function UpdateNavItems(newDarkState) {
  const links = [...document.getElementsByTagName('a')];
  const siteLinks = links.filter(FindUrl);
  for (let link of siteLinks) {
    link.href = ModifyUrl(link.href, newDarkState);
  }
}

function UpdateDarkModeVisual(newDarkState) {
  const preferDark = matchMedia('(prefers-color-scheme: dark)').matches;
  document.getElementById('dark-mode-toggle').checked = preferDark !== newDarkState;
}

function UpdateDarkModeState(newDarkState) {
  UpdateNavItems(newDarkState);
  history.pushState({}, null, ModifyUrl(location, newDarkState));
}

addEventListener('DOMContentLoaded', (event) => {
  const urlMode = new URLSearchParams(location.search).get('mode');
  const newDarkState = urlMode === 'dark' || GetDarkState();
  UpdateDarkModeVisual(newDarkState);
  UpdateDarkModeState(newDarkState);

  const jsOnlyElements = [...document.getElementsByClassName('js-only')];
  for (let element of jsOnlyElements) {
    element.hidden = false;
  }

  for (let menu of document.getElementsByClassName('nav-tabs')) {
    const labels = Array.from(menu.getElementsByTagName('label')).reverse();
    for (let label of labels) {
      const input = document.getElementById(label.getAttribute('for'));
      const div = input.ariaControlsElements[0];
      const title = label.textContent;
      const classActive = input.checked ? 'active' : '';

      label.remove();
      input.outerHTML = `<button class="nav-link ${classActive}" id="${label.id}" type="button" role="tab" data-bs-toggle="tab" data-bs-target="#${div.id}" aria-controls="${div.id}">${title}</button>`;
      if (input.checked) {
        div.classList.add(classActive);
      }
    }
  }
});

// TODO: Should this only happen if toggle is not checked?
// Currently if toggle is on(user request dark) and then scheme changes to dark it will switch the page to light
matchMedia('(prefers-color-scheme: dark)').addEventListener('change', event => {
  const newDarkState = GetDarkState();
  UpdateDarkModeVisual(newDarkState);
  UpdateDarkModeState(newDarkState);
});

addEventListener('popstate', (event) => {
  const newDarkState = new URLSearchParams(location.search).get('mode') === 'dark';
  UpdateDarkModeVisual(newDarkState);
  UpdateDarkModeState(newDarkState);
});


function ToggleDarkModeClick() {
  const newDarkState = GetDarkState() !== true;
  UpdateDarkModeState(newDarkState);
}

function ToggleDarkModeKeyDown(event) {
  const newDarkState = GetDarkState() !== true;
  if (event.keyCode === 13 /* Enter */) {
    UpdateDarkModeVisual(newDarkState);
    UpdateDarkModeState(newDarkState);
  }
}
