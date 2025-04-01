import consumer from "./consumer";

consumer.subscriptions.create("NotificationChannel", {
  connected() {
    console.log("Connected to NotificationChannel");
  },

  disconnected() {
    console.log("Disconnected from NotificationChannel");
  },

  received(data) {
    console.log("New Notification:", data);

    // Display notification in UI
    const notificationContainer = document.getElementById("notifications");
    if (notificationContainer) {
      const notificationElement = document.createElement("div");
      notificationElement.classList.add("notification-item");
      notificationElement.innerHTML = `<p>${data.message}</p>`;
      notificationContainer.prepend(notificationElement); // Add to top
    } else {
      alert(data.message); // Fallback alert
    }
  }
});
