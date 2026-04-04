function UpdateMode(dark) {
  const preferDark = matchMedia('(prefers-color-scheme: dark)').matches;
  document.getElementById("dark-mode-toggle").checked = dark ^ preferDark;
}

function UpdateUrl(url, dark) {
  const urlObj = new URL(url);
  urlObj.searchParams.set("mode", dark ? "dark" : "light");
  return urlObj;
}

function FindUrl(link) {
  const url = new URL(link);
  return url.href.startsWith(location.origin) && url.pathname.endsWith(".html") &&
         link.ariaCurrent != "page";
}

function UpdateNavItems(dark) {
  const links = [...document.getElementsByTagName("a")];
  const siteLinks = links.filter(FindUrl);
  for (let link of siteLinks) {
    link.href = UpdateUrl(link.href, dark);
  }
}

addEventListener("DOMContentLoaded", (event) => {
  const urlMode = new URLSearchParams(location.search).get("mode");
  let dark = urlMode == "dark";
  if (!urlMode) {
    dark = matchMedia('(prefers-color-scheme: dark)').matches;
  }
  UpdateMode(dark);
  history.pushState({}, null, UpdateUrl(location, dark));
  UpdateNavItems(dark);

  const jsOnlyElements = [...document.getElementsByClassName("js-only")];
  for (let element of jsOnlyElements) {
    element.hidden = false;
  }

  for (let menu of document.getElementsByClassName("nav-tabs")) {
    const labels = Array.from(menu.getElementsByTagName("label")).reverse();
    for (let label of labels) {
      const input = document.getElementById(label.getAttribute("for"));
      const div = input.ariaControlsElements[0];
      const title = label.textContent;
      const classActive = input.checked ? "active" : "";

      label.remove();
      input.outerHTML = `<button class="nav-link ${classActive}" id="${label.id}" type="button" role="tab" data-bs-toggle="tab" data-bs-target="#${div.id}" aria-controls="${div.id}">${title}</button>`;
      if (input.checked) {
        div.classList.add(classActive);
      }
    }
  }
});

matchMedia('(prefers-color-scheme: dark)').addEventListener('change', event => {
  UpdateMode(event.matches);
  history.pushState({}, null, UpdateUrl(location, event.matches));
  UpdateNavItems(event.matches);
});

addEventListener("popstate", (event) => {
  const dark = new URLSearchParams(location.search).get("mode") == "dark";
  UpdateMode(dark);
  UpdateNavItems(dark);
});

function ToggleDarkMode() {
  const dark = new URLSearchParams(location.search).get("mode") == "dark";
  // TODO: Fix this being flipped
  UpdateMode(dark);
  history.pushState({}, null, UpdateUrl(location, !dark));
  UpdateNavItems(!dark);
}
