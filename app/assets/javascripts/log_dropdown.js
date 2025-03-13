document.addEventListener('turbo:load', function() {
    const logTrigger = document.getElementById('log-trigger');
    const dropdownContent = document.getElementById('log-dropdown-content');
   
    if (logTrigger && dropdownContent) {
      // Toggle dropdown when clicking log link
      logTrigger.addEventListener('click', function(e) {
        e.preventDefault();
        dropdownContent.classList.toggle('active');
      });
  
      // Close dropdown when clicking outside
      document.addEventListener('click', function(e) {
        if (!logTrigger.contains(e.target) && !dropdownContent.contains(e.target)) {
          dropdownContent.classList.remove('active');
        }
      });
  
      // Prevent dropdown from closing when clicking inside it
      dropdownContent.addEventListener('click', function(e) {
        e.stopPropagation();
      });
    }
  });