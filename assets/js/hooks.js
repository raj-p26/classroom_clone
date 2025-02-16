/**
 * @type {Object.<string, import("phoenix_live_view")}
 */
export const RippleEffect = {
  mounted() {
    this.el.addEventListener("click", (event) => {
      let ripple = document.createElement("span");
      this.el.classList.add("ripple-container");

      let rect = this.el.getBoundingClientRect();
      let size = Math.max(rect.width, rect.height);
      const x = event.clientX - rect.left - size / 2;
      const y = event.clientY - rect.top - size / 2;

      ripple.style.position = "absolute";
      ripple.style.width = `${size}px`;
      ripple.style.height = `${size}px`;
      ripple.style.top = `${y}px`;
      ripple.style.left = `${x}px`;
      ripple.style.borderRadius = "50%";
      ripple.style.pointerEvents = "none";
      ripple.style.background = "rgba(0, 0, 0, 0.3)";
      ripple.style.animation = "animate-ripple 0.5s ease";

      this.el.appendChild(ripple);

      ripple.addEventListener("animationend", () => {
        ripple.remove();
        this.el.classList.remove("ripple-container");
      });
    });
  },
};

/**
 * @type {Object<string, import("phoenix_live_view")}
 */
export const ModalHook = {
  mounted() {
    this.el.addEventListener("click", (event) => {
      this.pushEvent("modal_open", {
        type: "create",
      });
    });
  },
};
