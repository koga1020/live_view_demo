// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.scss";

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html";

// Import local files
//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"

import { Socket } from "phoenix";
import LiveSocket from "phoenix_live_view";

let Hooks = {};
Hooks.Task = {
  mounted() {
    this.el.addEventListener("dragstart", e => {
      e.dataTransfer.setData("task_id", this.el.attributes.data_task_id.value);
    });
  }
};
Hooks.TaskDrop = {
  mounted() {
    this.el.addEventListener("dragover", e => {
      e.preventDefault();
      this.el.className = "dropzone above";
    });

    this.el.addEventListener("dragleave", e => {
      e.preventDefault();
      this.el.className = "dropzone";
    });
    this.el.addEventListener("drop", e => {
      this.el.className = "dropzone";
      let payload = {};
      payload.new_sort_value = Number(this.el.attributes.data_sort_index.value);
      payload.moved_task_id = Number(e.dataTransfer.getData("task_id"));

      this.pushEvent("sort_task", payload);
    });
  }
};

let liveSocket = new LiveSocket("/live", Socket, { hooks: Hooks });
liveSocket.connect();
