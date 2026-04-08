const express = require("express");
const cors = require("cors");

const app = express();
app.use(cors());
app.use(express.json());

app.get("/", (req, res) => {
  res.send("Backend is working 🚀");
});

// Example API
app.get("/api/message", (req, res) => {
  res.json({ message: "Hello from Node.js backend!" });
});

const PORT = 3000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
