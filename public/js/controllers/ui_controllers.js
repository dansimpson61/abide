//ui_controllers.js
document.addEventListener("DOMContentLoaded", function () {
  window.StimulusApp = Stimulus.Application.start();
  console.log("🎛️ StimulusApp initialized:", window.StimulusApp);

  /* ========== Sidebar Toggle Controller ========== */
  class TogglePanelController extends Stimulus.Controller {
    static targets = ["panel"];

    connect() {
      document.addEventListener("click", this.handleOutsideClick.bind(this));
    }

    show() {
      if (!this.panelTarget.classList.contains("pinned")) {
        this.panelTarget.classList.add("visible");
      }
    }

    persist(event) {
      event.stopPropagation(); // Prevent bubbling to document click listener
      this.panelTarget.classList.add("pinned");
      this.panelTarget.classList.add("visible"); // Ensure it stays visible
    }

    hide() {
      if (!this.panelTarget.classList.contains("pinned")) {
        this.panelTarget.classList.remove("visible");
      }
    }

    dismiss() {
      this.panelTarget.classList.remove("visible", "pinned");
    }

    handleOutsideClick(event) {
      if (!this.panelTarget.contains(event.target) && this.panelTarget.classList.contains("visible")) {
        this.dismiss();
      }
    }
  }

  StimulusApp.register("toggle-panel", TogglePanelController);

  /* ========== Sortable Controller (Reordering UI) ========== */
  class SortableController extends Stimulus.Controller {
    static targets = ["list"];

    connect() {
      this.sortable = Sortable.create(this.listTarget, {
        onEnd: (event) => {
          const sortedItems = Array.from(event.to.children).map((item, index) => ({
            id: parseInt(item.dataset.id, 10),
            order: index + 1
          }));
          const sortedEvent = new CustomEvent("sorted", { detail: { items: sortedItems } });
          this.listTarget.dispatchEvent(sortedEvent);
        }
      });
    }

    disconnect() {
      this.sortable.destroy();
    }
  }
  StimulusApp.register("sortable", SortableController);

  /* ========== Editable Text Controller ========== */
  class EditableTextController extends Stimulus.Controller {
    connect() {
      // When the element is clicked, start inline editing.
      this.element.addEventListener("click", this.startEditing.bind(this));
    }
    
    startEditing() {
      // Prevent starting editing if already in edit mode.
      if (this.editing) return;
      this.editing = true;

      // Save the original text in case editing is cancelled.
      this.originalText = this.element.textContent.trim();
      
      // Create an input element pre-filled with the current text.
      const input = document.createElement("input");
      input.type = "text";
      input.value = this.originalText;
      input.classList.add("editable-text-input");
      
      // Listen for blur (losing focus) and key events (Enter/Escape).
      input.addEventListener("blur", this.finishEditing.bind(this));
      input.addEventListener("keydown", this.handleKeydown.bind(this));
      
      // Replace the element’s content with the input.
      this.element.innerHTML = "";
      this.element.appendChild(input);
      input.focus();
    }
    
    handleKeydown(event) {
      if (event.key === "Enter") {
        event.preventDefault();
        event.target.blur();
      }
      if (event.key === "Escape") {
        event.preventDefault();
        this.cancelEditing();
      }
    }
    
    finishEditing(event) {
      const newValue = event.target.value;
      this.editing = false;
      // Restore the element’s content.
      this.element.textContent = newValue;
      
      // Dispatch a custom event to notify the server of the update.
      // Assumes that the element has data attributes for 'id' and 'field'.
      const updateEvent = new CustomEvent("updateField", {
        detail: {
          id: this.element.dataset.id,
          field: this.data.get("field") || "text",
          value: newValue
        },
        bubbles: true
      });
      this.element.dispatchEvent(updateEvent);
    }
    
    cancelEditing() {
      this.editing = false;
      // Restore the original text if editing is cancelled.
      this.element.textContent = this.originalText;
    }
  }
  StimulusApp.register("editable-text", EditableTextController);

  /* ========== Editable List Controller ========== */
  class EditableListController extends Stimulus.Controller {
    connect() {
      // Delegate click events: when an existing list item is clicked, allow inline editing.
      this.element.addEventListener("click", (event) => {
        const listItem = event.target.closest(".editable-list-item");
        if (listItem && !listItem.querySelector("input")) {
          this.startEditing(listItem);
        }
      });
      
      // Append an "Add Item" button to the list.
      this.addButton = document.createElement("button");
      this.addButton.textContent = "Add Item";
      this.addButton.classList.add("editable-list-add-button");
      this.addButton.addEventListener("click", this.addItem.bind(this));
      this.element.appendChild(this.addButton);
    }
    
    startEditing(listItem) {
      // Skip if the list item is already being edited.
      if (listItem.dataset.editing === "true") return;
      listItem.dataset.editing = "true";
      
      const currentText = listItem.textContent.trim();
      listItem.dataset.original = currentText;
      
      // Create an input element for editing.
      const input = document.createElement("input");
      input.type = "text";
      input.value = currentText;
      input.classList.add("editable-list-input");
      
      input.addEventListener("blur", () => this.finishEditing(listItem, input));
      input.addEventListener("keydown", (e) => {
        if (e.key === "Enter") {
          e.preventDefault();
          input.blur();
        }
        if (e.key === "Escape") {
          e.preventDefault();
          this.cancelEditing(listItem);
        }
      });
      
      listItem.innerHTML = "";
      listItem.appendChild(input);
      input.focus();
    }
    
    finishEditing(listItem, input) {
      const newValue = input.value;
      listItem.dataset.editing = "false";
      listItem.textContent = newValue;
      
      // Dispatch an event to update the edited list item.
      const updateEvent = new CustomEvent("updateListItem", {
        detail: {
          id: listItem.dataset.id, // May be empty for new items.
          field: this.data.get("field") || "list",
          value: newValue
        },
        bubbles: true
      });
      listItem.dispatchEvent(updateEvent);
    }
    
    cancelEditing(listItem) {
      listItem.dataset.editing = "false";
      listItem.textContent = listItem.dataset.original || "";
    }
    
    addItem(event) {
      event.preventDefault();
      
      // Create a new list item element.
      const newItem = document.createElement("div"); // Use <li> if preferred.
      newItem.classList.add("editable-list-item");
      newItem.textContent = "New item";
      newItem.dataset.id = ""; // New items may not have an id yet.
      
      // Insert the new item just before the "Add Item" button.
      this.element.insertBefore(newItem, this.addButton);
      
      // Begin editing immediately.
      this.startEditing(newItem);
      
      // Optionally, dispatch an event indicating a new item has been created.
      const newItemEvent = new CustomEvent("newListItem", {
        detail: {
          field: this.data.get("field") || "list",
          value: "New item"
        },
        bubbles: true
      });
      newItem.dispatchEvent(newItemEvent);
    }
  }
  StimulusApp.register("editable-list", EditableListController);

});
