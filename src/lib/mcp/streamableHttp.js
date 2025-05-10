import { Readable } from "node:stream";

export class StreamableHTTPServerTransport {
  /**
   * @param {import("@modelcontextprotocol/sdk").Server} server
   * @param {object} [opts]
   * @param {boolean} [opts.enableJsonResponse=true]
   */
  constructor(server, { enableJsonResponse = true } = {}) {
    this.server = server;
    this.enableJsonResponse = enableJsonResponse;
  }

  /**
   * Attach to an existing Express app.
   * @param {import("express").Express} app
   * @param {string} path  e.g. "/mcp"
   */
  attach(app, path = "/mcp") {
    app.post(path, async (req, res) => {
      try {
        const result = await this._handle(req.body);
        if (this.enableJsonResponse) {
          res.json(result);
        } else {
          res.send(result);
        }
      } catch (err) {
        res.status(400).json({ error: (err && err.message) || String(err) });
      }
    });
  }

  async _handle(message) {
    // tiny wrapper around the public `processMessage` API
    if (typeof this.server.processMessage !== "function") {
      throw new Error("SDK Server.processMessage() not found");
    }
    const stream = Readable.from([JSON.stringify(message)]);
    const chunks = [];
    for await (const chunk of this.server.processMessage(stream))
      chunks.push(chunk);
    return JSON.parse(Buffer.concat(chunks).toString("utf8"));
  }
}
