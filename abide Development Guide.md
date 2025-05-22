## Abide Development Guide: Front-End and Database Interaction

This guide outlines the structure and conventions for front-end development and its interaction with the database in the Abide project. We prioritize DRY (Don't Repeat Yourself), encapsulation, and a clear separation of concerns. We also strive for minimalist, clean JavaScript – the best JavaScript is the least JavaScript.

**Core Technologies:**

*   **Front-End:** Stimulus (for JavaScript behavior), SortableJS (for drag-and-drop), Slim (for templating).
*   **Back-End:** Sinatra (for API endpoints), Sequel (for database interaction), SQLite (for the database).

**File Structure and Conventions:**

*   **`app/views/layout.slim`:**
    *   **Purpose:** The main application layout. Defines the HTML structure, includes necessary JavaScript and CSS files, and provides the `yield` point for other views.
    *   **Conventions:**
        *   All global JavaScript and CSS inclusions should be here.
        *   Keep the layout as minimal as possible, focusing on structure, not content.
        *   Use Slim's syntax for concise and readable templates.

*   **`app/views/index.slim`:**
    *   **Purpose:** The main application view, rendered at the root (`/`). Displays the "Market," "Main Content," and "Garden" sections.
    *   **Conventions:**
        *   Uses partials (`_partials/*.slim`) to build the UI components.
        *   Fetches data from the back-end via the `@page_data` instance variable, passed from the Sinatra route handler.
        *   Avoids complex logic; primarily focuses on rendering data.

*   **`app/views/_partials/*.slim`:**
    *   **Purpose:** Reusable UI components (e.g., `_collection.slim`, `_item.slim`).
    *   **Conventions:**
        *   Each partial should represent a single, well-defined UI element.
        *   Use descriptive names (e.g., `_collection`, `_item`).
        *   Accept data via `locals` to keep them decoupled from the global scope.
        *   Avoid complex logic within partials; keep them focused on presentation.

*   **`public/js/application.js`:**
    * **Purpose:** Initializes Stimulus and provides utility functions.
    * **Conventions:**
        * Avoid putting controller logic here.
        * Use this file to initialize the Stimulus.

*   **`public/js/controllers/ui_controllers.js`:**
    *   **Purpose:** Contains Stimulus controllers that manage *user interface interactions*.  This file exemplifies our minimalist approach to JavaScript.
    *   **Conventions:**
        *   **`toggle-panel` controller:** Manages the visibility of the side panels.
            *   **Strengths:** Single responsibility, uses targets and actions, handles outside clicks, persistence (pinning), clean separation of concerns.
        *   **`sortable` controller:** Handles the drag-and-drop reordering within a list. *Dispatches* the `sorted` event with the updated order data.
            *   **Strengths:** Clear initialization, event handling, data extraction, custom event dispatch, clean disconnect.
        *   Follow Stimulus naming conventions (e.g., `data-controller`, `data-action`, `data-target`).
        *   Keep controllers focused on specific UI tasks.  Controllers are concise, readable, and follow Stimulus best practices.
        * **Future:** Consider separate files per controller for larger applications.

*   **`public/js/controllers/server_controller.js`:**
    *   **Purpose:** Contains Stimulus controllers that handle *communication with the server*.
    *   **Conventions:**
        *   **`server` controller:** *Listens* for the `sorted` event and sends the updated order data to the server via a `PATCH` request.
        *   This is the *bridge* between front-end actions and back-end data persistence.
        *   Handles API requests and responses.
        *   Should *not* directly manipulate the DOM (that's the responsibility of `ui_controllers.js`).

*   **`app/controllers/garden_api.rb`:**
    *   **Purpose:** Defines the API endpoints for interacting with the `Reflection` model.
    *   **Conventions:**
        *   Follows RESTful principles (GET, POST, PATCH, DELETE).
        *   Handles JSON requests and responses.
        *   Includes robust error handling (invalid JSON, missing data, database errors).
        *   Uses Sequel to interact with the database.
        *   Keeps API logic separate from presentation logic.

*   **`app/models/reflection.rb`:**
    *   **Purpose:** Represents the `Reflection` data model.
    *   **Conventions:**
        *   Uses Sequel for database interaction.
        *   Defines validation rules (e.g., required fields, allowed values).
        *   Handles database-related logic (e.g., auto-assigning order).
        *   Provides methods for data transformation (e.g., `all_to_h`).

**Data Flow (for Reordering):**

1.  User drags an item in the UI (handled by `SortableJS` and `ui_controllers.js`).
2.  `sortable` controller dispatches a `sorted` event.
3.  `server` controller catches the event and sends a `PATCH` request to `/api/garden/reflections/reorder`.
4.  `GardenAPI` handles the request, updating the database via the `Reflection` model.
5.  Database is updated. The next page load will show the persisted data in the new order.

**Key Principles:**

*   **Separation of Concerns:** Each file has a specific purpose (UI, API, data model).
*   **Encapsulation:** Stimulus controllers encapsulate UI behavior. Partials encapsulate UI components.
*   **DRY:** Partials and helpers are used to avoid code duplication.
*   **Convention over Configuration:** Follow Stimulus and Sinatra conventions to reduce boilerplate and improve readability.
*   **Test Driven Development:** Changes to code require supporting tests.
*  **Minimalist JavaScript:** We strive for clean, concise, and minimal JavaScript.

This guide provides a framework for ongoing development, ensuring consistency and maintainability as the Abide project grows.
