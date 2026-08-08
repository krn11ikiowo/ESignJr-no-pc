// backend/server.js
const express = require("express");
const multer = require("multer");
const { spawn } = require("child_process");
const path = require("path");

const app = express();
const upload = multer({ dest: "backend/storage/" });

app.use(express.json());

app.post("/sign", upload.single("ipa"), (req, res) => {
  const ipaPath = req.file.path;
  const { appleId, password, deviceUdid } = req.body;

  const py = spawn("python3", ["backend/sign_backend.py"]);

  py.stdin.write(
    JSON.stringify({
      ipa_path: ipaPath,
      apple_id: appleId,
      password,
      device_udid: deviceUdid
    })
  );
  py.stdin.end();

  let output = "";
  py.stdout.on("data", (data) => (output += data.toString()));
  py.on("close", () => {
    const result = JSON.parse(output);
    res.json({ signedPath: result.signed_path });
  });
});

app.listen(3000, () => console.log("ESignJr backend running on :3000"));
