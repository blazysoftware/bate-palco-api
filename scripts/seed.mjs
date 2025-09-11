import { createDirectus, rest, authentication } from "@directus/sdk";

const URL = process.env.PUBLIC_URL || "http://localhost:8055";
const ADMIN_EMAIL = process.env.ADMIN_EMAIL || "admin@gmail.com";
const ADMIN_PASSWORD = process.env.ADMIN_PASSWORD || "admin123!";

const client = createDirectus(URL).with(authentication()).with(rest());

async function ensureCollection() {
  try {
    await client.request({ method: "GET", path: "/schema/collections/articles" });
    console.log("Collection 'articles' already exists");
  } catch {
    await client.request({
      method: "POST",
      path: "/schema/collections",
      body: {
        collection: "articles",
        meta: { icon: "article", note: "Demo collection" },
        schema: { name: "articles" }
      }
    });

    await client.request({
      method: "POST",
      path: "/schema/fields",
      body: {
        collection: "articles",
        field: "title",
        type: "string",
        schema: { is_nullable: false },
        meta: { interface: "input", required: true }
      }
    });

    await client.request({
      method: "POST",
      path: "/schema/fields",
      body: {
        collection: "articles",
        field: "published_at",
        type: "timestamp",
        schema: { is_nullable: true },
        meta: { interface: "datetime" }
      }
    });

    console.log("Collection 'articles' created");
  }
}

async function seedItem() {
  const item = await client.request({
    method: "POST",
    path: "/items/articles",
    body: { title: "Hello Directus (Postgres)", published_at: new Date().toISOString() }
  });
  console.log("Inserted item:", item?.id);
}

async function main() {
  await client.login(ADMIN_EMAIL, ADMIN_PASSWORD);
  console.log("Logged in");

  await ensureCollection();
  await seedItem();

  await client.logout();
  console.log("Done");
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
