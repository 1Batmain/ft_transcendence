import Fastify from "fastify";

const app = Fastify({ logger: true });

app.get("/health", async () => {
  return { service: "blockchain", status: "ok" };
});

app.listen({ host: "0.0.0.0", port: 3000 }).then((addr) => {
  console.log("Blockchain service listening on", addr);
});
