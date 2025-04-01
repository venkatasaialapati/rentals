document.addEventListener("DOMContentLoaded", function () {
  let map, marker, selectedAddress = "";
  
  // Open Modal and Initialize Map
  document.getElementById("openMap").addEventListener("click", function () {
    document.getElementById("mapModal").style.display = "block";
    setTimeout(initMap, 200); // Ensure modal loads before initializing map
  });

  // Close Modal
  document.getElementById("closeModal").addEventListener("click", function () {
    document.getElementById("mapModal").style.display = "none";
  });

  // Initialize Map Function
  function initMap() {
    if (!map) {
      map = L.map("map").setView([20, 78], 5); // Set default view to India (or change to global)
      L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
        attribution: "&copy; OpenStreetMap contributors",
      }).addTo(map);

      map.on("click", function (e) {
        console.log("Map clicked at:", e.latlng);
        placeMarker(e.latlng.lat, e.latlng.lng);
      });
    }
  }

  // Place Marker and Fetch Address
  function placeMarker(lat, lng) {
    if (marker) {
      marker.setLatLng([lat, lng]);
    } else {
      marker = L.marker([lat, lng]).addTo(map);
    }
    map.setView([lat, lng], 12);

    fetchAddress(lat, lng);
  }

  // Fetch Address from OpenStreetMap API
  function fetchAddress(lat, lng) {
    fetch(`https://nominatim.openstreetmap.org/reverse?format=json&lat=${lat}&lon=${lng}`)
      .then(response => response.json())
      .then(data => {
        if (data && data.display_name) {
          selectedAddress = data.display_name;
          console.log("Fetched Address:", selectedAddress);
          document.getElementById("locationInput").value = selectedAddress; // Update input immediately
        } else {
          console.log("No address found for these coordinates.");
          alert("Unable to retrieve address. Please try another location.");
        }
      })
      .catch(error => {
        console.error("Error fetching address:", error);
        alert("Error fetching location details. Try again.");
      });
  }

  // Confirm Location Button Click
  document.getElementById("confirmLocation").addEventListener("click", function () {
    if (selectedAddress) {
      document.getElementById("locationInput").value = selectedAddress;
      document.getElementById("mapModal").style.display = "none";
      console.log("Location confirmed:", selectedAddress);
    } else {
      alert("Please select a location on the map before confirming.");
    }
  });
});
