import { Controller } from "@hotwired/stimulus";
import Sortable from "sortablejs";

export default class extends Controller {
  connect() {
    this.sortable = new Sortable(this.element, {
      animation: 150,
      ghostClass: "sortable-ghost",
      onEnd: this.updateOrder.bind(this)
    });
  }

  async updateOrder(event) {
    const updatedOrder = Array.from(this.element.children).map((item, index) => ({
      id: item.dataset.id,
      order: index + 1
    }));

    try {
      await fetch("/api/update_order", {
        method: "PATCH",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ items: updatedOrder })
      });
      console.log("Order updated successfully!");
    } catch (error) {
      console.error("Failed to update order:", error);
    }
  }
}
