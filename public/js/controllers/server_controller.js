// server_controller.js
document.addEventListener("DOMContentLoaded", function () {
//   class ServerController extends Stimulus.Controller {
//     save(event) { 
//       const sortedData = event.detail.items;
//         fetch("/api/garden/reflections/reorder", {
//           method: "PATCH",
//           headers: { "Content-Type": "application/json" },
//           body: JSON.stringify({ reflections: sortedData })
//         })
//     }
//   }
  StimulusApp.register('server', ServerController);
  /* ========== Extended Server Controller with Update ========== */
  class ServerController extends Stimulus.Controller {
    connect() {
      // Listen for update events from both editable text and list controllers.
      this.element.addEventListener("updateField", this.updateField.bind(this));
      this.element.addEventListener("updateListItem", this.updateField.bind(this));
    }

    // Existing 'save' method for sortable data remains here.
    save(event) {
      const sortedData = event.detail.items;
      fetch("/api/garden/reflections/reorder", {
        method: "PATCH",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ reflections: sortedData })
      });
    }

    updateField(event) {
      const { id, field, value } = event.detail;
      if (!id) {
        console.error("Missing id for update. Ensure the element has a data-id attribute.");
        return;
      }
      // Send an update request to the backend for the given id.
      fetch(`/api/garden/reflections/update/${id}`, {
        method: "PATCH",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ field: field, value: value })
      })
        .then(response => {
          if (!response.ok) {
            throw new Error("Update failed");
          }
          return response.json();
        })
        .then(data => console.log("Update successful:", data))
        .catch(error => console.error("Error updating field:", error));
    }
  }
  StimulusApp.register('server', ServerController);
});