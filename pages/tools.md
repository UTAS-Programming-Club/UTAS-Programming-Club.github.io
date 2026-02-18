---
title: Some useful tools
pagetitle: Tools
no-nav-entry: True
script: assets/tools.js
---

### Typst Minutes Template Creator
This is mostly of use to the committee since it relies on our agenda and template structure.

::: {class="mb-3"}
  <label for="agenda" class="form-label">Upload a typst agenda</label>
  <input type="file" id="agenda" class="form-control" name="agenda" accept=".typ" oninput="checkAgendaUpload(this)" autocomplete="off">
::: 

<a id="generate" class="btn btn-primary disabled" target="_blank" role="button" aria-disabled="true" onclick="createMinutesTemplate()">Create minutes template</a>
<a id="download" class="btn btn-primary disabled" target="_blank" role="button" aria-disabled="true">Download minutes template</a>
