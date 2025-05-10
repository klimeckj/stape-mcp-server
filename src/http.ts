import express from "express";
import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { StreamableHTTPServerTransport } from "./lib/mcp/streamableHttp.js";
import { loadEnv, getPackageVersion } from "./utils";
import { tools } from "./tools";


loadEnv();

const server = new McpServer({
  name: "google-tag-manager",
  version: getPackageVersion(),
  protocolVersion: "1.0",
  vendor: "stape-io",
});

tools.forEach(r => r(server));

const transport = new StreamableHTTPServerTransport({
  enableJsonResponse: true          // so POST /mcp returns plain JSON
});

const app = express();
app.use(express.json());
transport.attach(app, "/mcp");      // POST /mcp  (Claude/Gemini default)

const PORT = process.env.PORT || 8080;
app.listen(PORT, () =>
  console.log(`✅ MCP HTTP server listening on ${PORT}`));
