function getBinUrl() {
    const urlElement = document.getElementById('bin-url');
    if (!urlElement) return null;

    let binPath = urlElement.textContent.trim(); // Get the bin path

    // Ensure binPath only contains the relative path (if needed)
    if (binPath.startsWith("http")) {
        const url = new URL(binPath);
        binPath = url.pathname; // Extracts only the `/bins/16` part
    }
  
    /// Get the full base URL dynamically
    const baseUrl = window.location.origin; // Includes protocol (http/https) and host

    return baseUrl + binPath; // Construct the correct full URL
}
  
  function copyToClipboard() {
    const textToCopy = getBinUrl();
    if (!textToCopy) return;
  
    // Use the Clipboard API (modern approach)
    navigator.clipboard.writeText(textToCopy).then(() => {
      alert('Bin URL copied to clipboard!');
    }).catch(err => {
      console.error('Failed to copy text: ', err);
    });
  }
  
  // Make function globally available
  window.copyToClipboard = copyToClipboard;
  