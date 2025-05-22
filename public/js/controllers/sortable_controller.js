document.addEventListener("DOMContentLoaded", function () {
  class SortableController extends Stimulus.Controller {
    static targets = ["list"];
  
    connect() {
      this.sortable = Sortable.create(this.listTarget, {
        onEnd: async (event) => {
          const sortedItems = Array.from(event.to.children).map((item, index) => ({
            id: parseInt(item.dataset.id, 10),  // Get id from data-id attribute
            order: index + 1 // Calculate new order based on position
          }));
          const sortedEvent = new CustomEvent('sorted', { detail: { items: sortedItems }});
          this.listTarget.dispatchEvent(sortedEvent);
        }
      });
    }
    disconnect() {
      this.sortable.destroy();
    }
  }
  StimulusApp.register('sortable', SortableController);
});
