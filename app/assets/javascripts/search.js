document.addEventListener("turbo:load", function () {
  const searchInventoryInput = document.getElementById("search-inventory");
  const searchItemsInput = document.getElementById("search-items");
  if (!searchInventoryInput || !searchItemsInput) return; // Stop if search boxes are missing

  let searchData = { bins: [], locations: [], items: [] };

  // Fetch search data from the Rails API
  fetch("/search")
    .then((response) => response.json())
    .then((data) => {
      searchData = data; // Store API data for filtering
    })
    .catch((error) => console.error("Error fetching search data:", error));

  // Function to filter results based on query
  function filterResults(query, type) {
    if (!query) return [];
    return searchData[type].filter(
      (entry) =>
        entry.name.toLowerCase().includes(query.toLowerCase()) ||
        (entry.category_name &&
          entry.category_name.toLowerCase().includes(query.toLowerCase()))
    );
  }

  // Function to show search suggestions
  function showSuggestions(results, inputElement) {
    let dropdown = document.getElementById(`${inputElement.id}-dropdown`);
    if (!dropdown) {
      dropdown = document.createElement("div");
      dropdown.id = `${inputElement.id}-dropdown`;
      dropdown.classList.add("search-dropdown");
      inputElement.parentNode.appendChild(dropdown);
    }

    dropdown.innerHTML = ""; // Clear previous suggestions

    if (results.length === 0) {
      dropdown.style.display = "none";
      return;
    }

    results.forEach((result) => {
      const option = document.createElement("div");
      option.classList.add("search-option");
      option.textContent =
        result.name +
        (result.category_name ? ` (${result.category_name})` : "");

      option.addEventListener("click", function () {
        inputElement.value = result.name;
        dropdown.style.display = "none"; // Hide dropdown after selection
      });

      dropdown.appendChild(option);
    });

    dropdown.style.display = "block";
  }

  // Listen for input changes in both search bars
  searchInventoryInput.addEventListener("input", function () {
    const query = searchInventoryInput.value.trim();
    const results = filterResults(query, "bins");
    showSuggestions(results, searchInventoryInput);
  });

  searchItemsInput.addEventListener("input", function () {
    const query = searchItemsInput.value.trim();
    const results = filterResults(query, "items");
    showSuggestions(results, searchItemsInput);
  });

  // Close dropdowns if clicked outside
  document.addEventListener("click", function (e) {
    if (
      !searchInventoryInput.contains(e.target) &&
      !document.getElementById("search-inventory-dropdown")?.contains(e.target)
    ) {
      document.getElementById("search-inventory-dropdown")?.remove();
    }
    if (
      !searchItemsInput.contains(e.target) &&
      !document.getElementById("search-items-dropdown")?.contains(e.target)
    ) {
      document.getElementById("search-items-dropdown")?.remove();
    }
  });
});
