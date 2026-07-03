const projects = [
  { name: "Aurora Bakery", desc: "E-commerce site for an artisan bakery chain." },
  { name: "Nimbus Legal", desc: "Corporate site for a boutique law firm." },
  { name: "Groove Studio", desc: "Portfolio for an independent music producer." },
  { name: "Terra Realty", desc: "Property listing site with search filters." },
];

const testimonials = [
  { quote: "Our new site was live within days of the redesign.", author: "A. Rao, Aurora Bakery" },
  { quote: "Every update we make goes live automatically. No more waiting.", author: "S. Menon, Nimbus Legal" },
  { quote: "Rock solid uptime even during our launch traffic spike.", author: "K. Iyer, Groove Studio" },
];

function renderCards(containerId, items, mapFn) {
  const container = document.getElementById(containerId);
  container.innerHTML = items.map(mapFn).join("");
}

renderCards("project-grid", projects, (p) => `
  <div class="card"><h3>${p.name}</h3><p>${p.desc}</p></div>
`);

renderCards("testimonial-grid", testimonials, (t) => `
  <div class="card"><p>"${t.quote}"</p><span class="author">${t.author}</span></div>
`);

// Simple client-side build/version marker so screenshots can show
// which deployment/build is currently live (useful for CI/CD verification).
document.getElementById("build-id").textContent =
  window.BUILD_ID || "local-dev";
