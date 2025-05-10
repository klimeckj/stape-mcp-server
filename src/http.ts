// ---------- src/http.ts --------------
import express from "express";
import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";

import { loadEnv, getPackageVersion } from "./utils";
import { tools } from "./tools";

loadEnv();

/* 1️⃣  Build the MCP server ------------------------------------------------ */
const server = new McpServer({
  name: "google-tag-manager",
  version: getPackageVersion(),
  protocolVersion: "1.0",
  vendor: "stape-io",
});

tools.forEach(t => t(server));
console.log(`🔧 Registered ${tools.length} tool(s)`);

/* 2️⃣  Plain‑old Express endpoint ----------------------------------------- */
const app = express();
app.use(express.json());

app.post("/mcp", async (req, res) => {
  try {
    const result = await server.processMessage(req.body);
    res.json(result);
  } catch (err) {
    console.error("❌ MCP handler error:", err);
    res.status(500).json({ error: String(err) });
  }
});

/* 3️⃣  Start HTTP server --------------------------------------------------- */
const PORT = process.env.PORT || 8080;
app.listen(PORT, () => {
  console.log(`🚀 MCP HTTP Server listening on :${PORT}/mcp`);
});
