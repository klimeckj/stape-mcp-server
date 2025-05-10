// src/http.ts
import express from "express";
import { Server } from "@modelcontextprotocol/sdk/server";           // newer API
import { StreamableHTTPServerTransport } from "@modelcontextprotocol/sdk/server";
import { loadEnv, getPackageVersion } from "./utils";
import { tools } from "./tools";

loadEnv();

const server = new Server({
  name: "google-tag-manager",
  version: getPackageVersion(),
  protocolVersion: "1.0",
  vendor: "stape-io",
});

tools.forEach(r => r(server));

const transport = new StreamableHTTPServerTransport({
  enableJsonResponse: true               // plain‑JSON replies
});

transport.attach(server, app, "/mcp");   // ← correct order!

const app = express();
app.use(express.json());

const PORT = process.env.PORT || 8080;
app.listen(PORT, () => console.log(`✅ MCP HTTP server listening on ${PORT}`));

