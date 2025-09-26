import { handler } from "./dist/index.js";
console.log("Testing the handler with a sample event...");
const event = {};
await handler(event);