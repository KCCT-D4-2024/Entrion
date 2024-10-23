import consumer from "./consumer"

consumer.subscriptions.create("InfoChannel", {
  connected() {
    console.log("Connected to InfoChannel");
    // Called when the subscription is ready for use on the server
  },
  
  disconnected() {
    console.log("Disconnected from InfoChannel");
    // Called when the subscription has been terminated by the server
  },
  
  received(data) {
    console.log("Data received: ", data);  // デバッグ用ログ
    document.getElementById('users_count').innerText = `${data.users_count}人`;
    document.getElementById('entered_count').innerText = `${data.entered_count}人`;
    document.getElementById('exited_count').innerText = `${data.exited_count}人`;
    document.getElementById('max_score').innerText = data.max_score;
  },
  
  rejected() {
    console.error("Subscription was rejected.");
  }
});
