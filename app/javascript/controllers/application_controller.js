import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]
  static values = { 
    inputId: String, 
    inputValue: String 
  }

  connect() {
    this.close()
    this.clickOutside = this.clickOutside.bind(this)
  }

  // Dropdown functionality
  toggle(event) {
    event.stopPropagation()
    this.menuTarget.classList.toggle("hidden")
    
    if (!this.menuTarget.classList.contains("hidden")) {
      document.addEventListener("click", this.clickOutside)
    }
  }

  close() {
    if (this.hasMenuTarget) {
      this.menuTarget.classList.add("hidden")
      document.removeEventListener("click", this.clickOutside)
    }
  }

  clickOutside(event) {
    if (!this.element.contains(event.target)) {
      this.close()
    }
  }

  // Input population functionality
  populateInput(event) {
    event.preventDefault()
    const inputId = event.params.inputId || this.inputIdValue
    const inputValue = event.params.inputValue || this.inputValueValue
    
    if (inputId && inputValue) {
      const inputElement = document.getElementById(inputId)
      if (inputElement) {
        inputElement.value = inputValue
        inputElement.dispatchEvent(new Event('input', { bubbles: true }))
      }
    }
  }

  disconnect() {
    this.close()
  }
}