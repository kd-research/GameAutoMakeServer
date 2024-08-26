import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="auth-overlay"
export default class extends Controller {
	static targets = [ "overlay" ]

  connect() {
  }

	hide() {
		this.overlayTarget.classList.remove('is-active');
	}

}
