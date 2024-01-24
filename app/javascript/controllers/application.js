// stimulusのパッケージからApplicationをimportしている
import { Application } from "@hotwired/stimulus"
import AutoCompleteController from "./autocomplete_controller"

const application = Application.start()
// HTML内で、data-controller="autocomplete"と指定された要素を
// AutoCompleteControllerで制御するように登録している
application.register('autocomplete', AutoCompleteController)

application.debug = false
window.Stimulus   = application

export { application }
