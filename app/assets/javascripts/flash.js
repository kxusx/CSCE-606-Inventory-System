document.addEventListener("turbo:load", function () {
  console.log("Flash script is running after Turbo load!"); // Debugging log

  setTimeout(() => {
    let flashPopup = document.getElementById("flash-popup");

    if (flashPopup) {
      console.log("Flash message found after Turbo load:", flashPopup.innerText); // Debugging log

      let flashModal = document.createElement("div");
      flashModal.classList.add("flash-modal");

      let flashContent = document.createElement("div");
      flashContent.classList.add("flash-content");

      let message = document.createElement("p");
      message.innerText = flashPopup.innerText;

      let closeButton = document.createElement("button");
      closeButton.innerText = "OK";
      closeButton.classList.add("flash-close-btn");
      closeButton.addEventListener("click", function () {
        flashModal.remove();
      });

      flashContent.appendChild(message);
      flashContent.appendChild(closeButton);
      flashModal.appendChild(flashContent);
      document.body.appendChild(flashModal);

      console.log("Pop-up should now be visible after Turbo load."); // Debugging log

      // Remove the original flash message from the page
      flashPopup.remove();
    } else {
      console.log("No flash message found after Turbo load.");
    }
  }, 300); // Small delay to allow Turbo to update the DOM
});
