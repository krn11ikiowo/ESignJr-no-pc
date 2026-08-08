function showTab(id) {
  document.querySelectorAll(".tab").forEach(tab => tab.classList.remove("active"));
  document.querySelectorAll(".tab-button").forEach(btn => btn.classList.remove("active"));

  document.getElementById(id).classList.add("active");
  const btnIndex = { installer: 0, library: 1, signer: 2 }[id];
  document.querySelectorAll(".tab-button")[btnIndex].classList.add("active");
}

async function signIPA() {
  const status = document.getElementById("status");
  const signerStatus = document.getElementById("signerStatus");
  const ipaFile = document.getElementById("ipa").files[0];
  const appleId = document.getElementById("appleId").value;
  const password = document.getElementById("password").value;
  const deviceUdid = document.getElementById("deviceUdid").value;

  if (!ipaFile || !appleId || !password || !deviceUdid) {
    status.textContent = "Please fill all fields and select an IPA.";
    signerStatus.textContent = "Signing failed: missing fields.";
    return;
  }

  status.textContent = "Uploading and signing…";
  signerStatus.textContent = "Signing in progress…";

  const form = new FormData();
  form.append("ipa", ipaFile);
  form.append("appleId", appleId);
  form.append("password", password);
  form.append("deviceUdid", deviceUdid);

  try {
    const res = await fetch("/sign", { method: "POST", body: form });

    if (!res.ok) {
      status.textContent = "Signing failed: " + res.statusText;
      signerStatus.textContent = "Signing failed: " + res.statusText;
      return;
    }

    const data = await res.json();
    status.textContent = "Signed IPA ready. Downloading…";
    signerStatus.textContent = "Signed IPA created: " + data.signedPath;

    const dl = document.createElement("a");
    dl.href = "/download?path=" + encodeURIComponent(data.signedPath);
    dl.download = "signed_" + ipaFile.name;
    dl.click();

  } catch (e) {
    status.textContent = "Error: " + e.message;
    signerStatus.textContent = "Error: " + e.message;
  }
}

async function loadLibrary() {
  const list = document.getElementById("libraryList");
  list.innerHTML = "Loading…";

  try {
    const res = await fetch("/library");
    if (!res.ok) {
      list.innerHTML = "Failed to load library.";
      return;
    }
    const data = await res.json();
    list.innerHTML = "";
    if (!data.files || data.files.length === 0) {
      list.innerHTML = "<li>No signed IPAs yet.</li>";
      return;
    }
    data.files.forEach(file => {
      const li = document.createElement("li");
      const link = document.createElement("a");
      link.href = "/download?path=" + encodeURIComponent(file.path);
      link.textContent = file.name;
      link.download = file.name;
      li.appendChild(link);
      list.appendChild(li);
    });
  } catch (e) {
    list.innerHTML = "Error: " + e.message;
  }
}
