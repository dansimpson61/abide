// Load Stimulus Application
window.Stimulus = window.Stimulus || (() => {
  const application = Stimulus.Application.start();
  return application;
})();

// Load SortableJS globally
document.addEventListener("DOMContentLoaded", () => {
  document.querySelectorAll("[data-controller='sortable']").forEach((element) => {
    new Sortable(element, {
      animation: 150,
      ghostClass: "sortable-ghost",
      onEnd: async (event) => {
        const updatedOrder = Array.from(event.to.children).map((item, index) => ({
          id: item.dataset.id,
          order: index + 1
        }));

        try {
          const response = await fetch("/api/update_order", {
            method: "PATCH",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ items: updatedOrder })
          });
          if (!response.ok) throw new Error("Update failed");
          console.log("Order updated successfully!");
        } catch (error) {
          console.error("Failed to update order:", error);
        }
      }
    });
  });
});
