// ---------- src/http.ts --------------
import express from "express";

import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
// 👇 keep using the local shim!
import { StreamableHTTPServerTransport } from "./lib/mcp/streamableHttp.js";

import { loadEnv, getPackageVersion } from "./utils";
import { tools } from "./tools";

loadEnv();

async function main() {
  try {
    /** 1️⃣  Build the MCP server */
    const server = new McpServer({
      name: "google-tag-manager",
      version: getPackageVersion(),
      protocolVersion: "1.0",
      vendor: "stape-io",
    });

    // Register tools
    tools.forEach(t => t(server));
    console.log(`🔧 Registered ${tools.length} tool(s)`);

    /** 2️⃣  Transport */
    const transport = new StreamableHTTPServerTransport({
      enableJsonResponse: true,
    });

    /** 3️⃣  Express wiring */
    const app = express();
    app.use(express.json());

    console.log("📡 Attaching MCP transport to /mcp");
    transport.attach(app, "/mcp");
    console.log("✅ Transport attached");

    /** 4️⃣  Start HTTP server */
    const PORT = process.env.PORT || 8080;
    app.listen(PORT, () => {
      console.log(`🚀 MCP HTTP Server UP on :${PORT}`);
    });
  } catch (err) {
    // Crash hard so Cloud Run logs the stack trace and the revision fails fast
    console.error("❌ Fatal startup error", err);
    process.exit(1);
  }
}

main();
